import 'dart:async';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:dilidili/http/dio_instance.dart';
import 'package:dilidili/http/static/api_string.dart';
import 'package:dilidili/http/video.dart';
import 'package:dilidili/model/download.dart';
import 'package:dilidili/model/video/url.dart';
import 'package:dilidili/utils/storage.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart' hide Response;
import 'package:path_provider/path_provider.dart';

class DownloadController extends GetxController with WidgetsBindingObserver {
  static DownloadController get to => Get.find<DownloadController>();

  static const String _tasksKey = 'downloadTasks';
  static const int _maxConcurrent = 1;

  final RxList<DownloadTask> tasks = <DownloadTask>[].obs;
  final List<String> _queue = [];
  final Set<String> _runningTaskIds = <String>{};
  final Map<String, CancelToken> _cancelTokens = <String, CancelToken>{};

  @override
  void onInit() {
    super.onInit();
    WidgetsBinding.instance.addObserver(this);
    _restoreTasks();
    _resumeInterruptedTasks();
  }

  @override
  void onClose() {
    WidgetsBinding.instance.removeObserver(this);
    _pauseActiveTasks(markUserPaused: false);
    super.onClose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.inactive ||
        state == AppLifecycleState.paused ||
        state == AppLifecycleState.detached) {
      _pauseActiveTasks(markUserPaused: false);
    } else if (state == AppLifecycleState.resumed) {
      _resumePendingTasks();
    }
  }

  bool addTask(DownloadTask task) {
    final bool exists = tasks.any((item) => item.id == task.id);
    if (exists) {
      return false;
    }
    tasks.insert(0, task);
    _saveTasks();
    startTask(task.id);
    return true;
  }

  void startTask(String id) {
    final DownloadTask? task = _findTask(id);
    if (task == null || task.status == DownloadStatus.completed) {
      return;
    }
    if (!_queue.contains(id) && !_runningTaskIds.contains(id)) {
      _queue.add(id);
    }
    if (task.status != DownloadStatus.downloading) {
      task.status = DownloadStatus.pending;
      task.errorMessage = null;
      _refreshTask(task);
    }
    _pumpQueue();
  }

  void resumeTask(String id) {
    startTask(id);
  }

  void pauseTask(String id) {
    final DownloadTask? task = _findTask(id);
    if (task == null) {
      return;
    }
    task.status = DownloadStatus.paused;
    task.updateAggregateProgress();
    _queue.remove(id);
    _cancelTokens[id]?.cancel('paused');
    _refreshTask(task);
  }

  Future<void> removeTask(String id) async {
    _queue.remove(id);
    _cancelTokens[id]?.cancel('removed');
    final DownloadTask? task = _findTask(id);
    if (task != null) {
      await _deleteTaskFiles(task);
    }
    tasks.removeWhere((task) => task.id == id);
    _saveTasks();
  }

  void _restoreTasks() {
    final List<dynamic> cache =
        SPStorage.localCache.get(_tasksKey, defaultValue: <dynamic>[]);
    tasks.value = cache
        .whereType<Map<dynamic, dynamic>>()
        .map((json) => DownloadTask.fromJson(json))
        .toList();
  }

  Future<void> _resumeInterruptedTasks() async {
    for (final DownloadTask task in tasks) {
      await _prepareTaskFiles(task);
      await _refreshLocalProgress(task);
      if (task.status == DownloadStatus.completed &&
          !_isCompletedFileReady(task)) {
        task.status = DownloadStatus.failed;
        task.errorMessage = '本地缓存文件丢失，请重新下载';
      } else if (task.status == DownloadStatus.downloading ||
          task.status == DownloadStatus.pending) {
        task.status = DownloadStatus.pending;
        startTask(task.id);
      }
    }
    _saveTasks();
  }

  void _resumePendingTasks() {
    for (final DownloadTask task in tasks) {
      if (task.status == DownloadStatus.pending ||
          task.status == DownloadStatus.downloading) {
        startTask(task.id);
      }
    }
  }

  void _pauseActiveTasks({required bool markUserPaused}) {
    for (final String id in _runningTaskIds.toList()) {
      final DownloadTask? task = _findTask(id);
      if (task != null) {
        task.status =
            markUserPaused ? DownloadStatus.paused : DownloadStatus.pending;
        task.updateAggregateProgress();
        _refreshTask(task);
      }
      _cancelTokens[id]?.cancel('lifecycle');
    }
    if (markUserPaused) {
      _queue.clear();
    }
    _saveTasks();
  }

  void _pumpQueue() {
    while (_runningTaskIds.length < _maxConcurrent && _queue.isNotEmpty) {
      final String id = _queue.removeAt(0);
      if (_runningTaskIds.contains(id)) {
        continue;
      }
      final DownloadTask? task = _findTask(id);
      if (task == null ||
          task.status == DownloadStatus.paused ||
          task.status == DownloadStatus.completed) {
        continue;
      }
      _runningTaskIds.add(id);
      unawaited(
        _runTask(task).whenComplete(() {
          _runningTaskIds.remove(id);
          _cancelTokens.remove(id);
          _pumpQueue();
        }),
      );
    }
  }

  Future<void> _runTask(DownloadTask task) async {
    final CancelToken cancelToken = CancelToken();
    _cancelTokens[task.id] = cancelToken;
    task.status = DownloadStatus.downloading;
    task.errorMessage = null;
    _refreshTask(task);

    try {
      await _prepareTaskFiles(task);
      final PlayUrlModel playUrl = await _queryFreshPlayUrl(task);
      if (task.sourceType == 'durl') {
        final String? url = playUrl.durl?.first.url;
        if (url == null || url.isEmpty) {
          throw Exception('未获取到可下载的视频链接');
        }
        await _downloadOneFile(
          url: url,
          savePath: task.videoPath!,
          cancelToken: cancelToken,
          onProgress: (downloaded, total) {
            task.videoDownloadedBytes = downloaded;
            task.videoTotalBytes = total;
            task.audioDownloadedBytes = 0;
            task.audioTotalBytes = 0;
            _refreshTask(task, persist: false);
          },
        );
      } else {
        final VideoItem video = _pickVideo(playUrl, task);
        await _downloadOneFile(
          url: video.baseUrl!,
          savePath: task.videoPath!,
          cancelToken: cancelToken,
          onProgress: (downloaded, total) {
            task.videoDownloadedBytes = downloaded;
            task.videoTotalBytes = total;
            _refreshTask(task, persist: false);
          },
        );

        final AudioItem? audio = _pickAudio(playUrl, task);
        if (audio != null &&
            audio.baseUrl != null &&
            audio.baseUrl!.isNotEmpty) {
          await _downloadOneFile(
            url: audio.baseUrl!,
            savePath: task.audioPath!,
            cancelToken: cancelToken,
            onProgress: (downloaded, total) {
              task.audioDownloadedBytes = downloaded;
              task.audioTotalBytes = total;
              _refreshTask(task, persist: false);
            },
          );
        }
      }

      task.status = DownloadStatus.completed;
      task.updateAggregateProgress();
      _refreshTask(task);
    } on DioException catch (err) {
      if (CancelToken.isCancel(err)) {
        task.updateAggregateProgress();
        _refreshTask(task);
        return;
      }
      task.status = DownloadStatus.failed;
      task.errorMessage = err.message;
      task.updateAggregateProgress();
      _refreshTask(task);
    } catch (err) {
      if (cancelToken.isCancelled) {
        task.updateAggregateProgress();
        _refreshTask(task);
        return;
      }
      task.status = DownloadStatus.failed;
      task.errorMessage = err.toString();
      task.updateAggregateProgress();
      _refreshTask(task);
    }
  }

  Future<PlayUrlModel> _queryFreshPlayUrl(DownloadTask task) async {
    final result = await VideoHttp.videoUrl(
      avid: task.aid,
      bvid: task.bvid,
      cid: task.cid,
      qn: task.quality,
    );
    if (result['status'] == true) {
      return result['data'] as PlayUrlModel;
    }
    throw Exception(result['msg'] ?? '获取播放链接失败');
  }

  VideoItem _pickVideo(PlayUrlModel playUrl, DownloadTask task) {
    final List<VideoItem> videos = [...?playUrl.dash?.video];
    if (videos.isEmpty) {
      throw Exception('未获取到视频轨');
    }
    final Iterable<VideoItem> sameQuality =
        videos.where((item) => item.id == task.quality);
    final List<VideoItem> candidates =
        sameQuality.isEmpty ? videos : sameQuality.toList();
    if (task.videoCodec != null && task.videoCodec!.isNotEmpty) {
      final VideoItem? matched = _firstVideoWhere(
        candidates,
        (item) => item.codecs?.startsWith(task.videoCodec!) == true,
      );
      if (matched != null) {
        return matched;
      }
    }
    candidates.sort((a, b) => (b.id ?? 0).compareTo(a.id ?? 0));
    return candidates.first;
  }

  AudioItem? _pickAudio(PlayUrlModel playUrl, DownloadTask task) {
    final List<AudioItem> audios = [...?playUrl.dash?.audio];
    if (audios.isEmpty) {
      return null;
    }
    if (task.audioQuality != null) {
      final AudioItem? matched = _firstAudioWhere(
        audios,
        (item) => item.id == task.audioQuality,
      );
      if (matched != null) {
        return matched;
      }
    }
    return audios.first;
  }

  VideoItem? _firstVideoWhere(
    Iterable<VideoItem> items,
    bool Function(VideoItem item) test,
  ) {
    for (final VideoItem item in items) {
      if (test(item)) {
        return item;
      }
    }
    return null;
  }

  AudioItem? _firstAudioWhere(
    Iterable<AudioItem> items,
    bool Function(AudioItem item) test,
  ) {
    for (final AudioItem item in items) {
      if (test(item)) {
        return item;
      }
    }
    return null;
  }

  Future<void> _downloadOneFile({
    required String url,
    required String savePath,
    required CancelToken cancelToken,
    required void Function(int downloaded, int total) onProgress,
  }) async {
    final File file = File(savePath);
    final File partFile = File('$savePath.part');
    await partFile.parent.create(recursive: true);

    if (await file.exists()) {
      final int length = await file.length();
      onProgress(length, length);
      return;
    }

    int downloaded = await partFile.exists() ? await partFile.length() : 0;
    final Map<String, String> headers = {
      'user-agent':
          'Mozilla/5.0 (Macintosh; Intel Mac OS X 13_3_1) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/16.4 Safari/605.1.15',
      'referer': ApiString.mainUrl,
      if (downloaded > 0) 'range': 'bytes=$downloaded-',
    };

    final Response<ResponseBody> response =
        await DioInstance.dio.get<ResponseBody>(
      url,
      options: Options(
        responseType: ResponseType.stream,
        headers: headers,
        validateStatus: (status) => status != null && status < 500,
      ),
      cancelToken: cancelToken,
    );

    if (downloaded > 0 && response.statusCode == 200) {
      downloaded = 0;
      if (await partFile.exists()) {
        await partFile.delete();
      }
    } else if (response.statusCode == 416) {
      final int localLength =
          await partFile.exists() ? await partFile.length() : 0;
      if (localLength > 0) {
        await partFile.rename(savePath);
        onProgress(localLength, localLength);
        return;
      }
      throw Exception('断点范围无效');
    } else if (response.statusCode != 200 && response.statusCode != 206) {
      throw Exception('下载请求失败: ${response.statusCode}');
    }

    final int total = _resolveTotalBytes(response.headers, downloaded);
    onProgress(downloaded, total);

    final IOSink sink = partFile.openWrite(
      mode: downloaded > 0 ? FileMode.append : FileMode.write,
    );
    int lastPersistAt = DateTime.now().millisecondsSinceEpoch;
    try {
      await for (final List<int> chunk in response.data!.stream) {
        if (cancelToken.isCancelled) {
          throw DioException(
            requestOptions: response.requestOptions,
            type: DioExceptionType.cancel,
          );
        }
        sink.add(chunk);
        downloaded += chunk.length;
        onProgress(downloaded, total);
        final int now = DateTime.now().millisecondsSinceEpoch;
        if (now - lastPersistAt >= 800) {
          _saveTasks();
          lastPersistAt = now;
        }
      }
    } finally {
      await sink.close();
    }

    if (total > 0 && downloaded < total) {
      throw Exception('下载未完成');
    }
    await partFile.rename(savePath);
    final int finalLength = await File(savePath).length();
    onProgress(finalLength, total > 0 ? total : finalLength);
  }

  int _resolveTotalBytes(Headers headers, int downloaded) {
    final String? contentRange = headers.value('content-range');
    if (contentRange != null) {
      final RegExpMatch? match =
          RegExp(r'bytes\s+\d+-\d+/(\d+)').firstMatch(contentRange);
      if (match != null) {
        return int.parse(match.group(1)!);
      }
    }
    final int contentLength =
        int.tryParse(headers.value('content-length') ?? '') ?? 0;
    return downloaded + contentLength;
  }

  Future<void> _prepareTaskFiles(DownloadTask task) async {
    final String? oldVideoPath = task.videoPath;
    final String? oldAudioPath = task.audioPath;
    final Directory dir = await _taskDirectory(task);
    await dir.create(recursive: true);
    task.videoPath =
        '${dir.path}/video.${task.sourceType == 'durl' ? 'mp4' : 'm4s'}';
    task.audioPath = task.sourceType == 'dash' ? '${dir.path}/audio.m4s' : null;
    await _migrateLegacyFile(oldVideoPath, task.videoPath);
    await _migrateLegacyFile(oldAudioPath, task.audioPath);
  }

  Future<void> _refreshLocalProgress(DownloadTask task) async {
    await _prepareTaskFiles(task);
    final int videoLength = await _localFileLength(task.videoPath);
    final int audioLength = await _localFileLength(task.audioPath);
    task.videoDownloadedBytes = videoLength;
    task.audioDownloadedBytes = audioLength;
    task.updateAggregateProgress();
    _refreshTask(task);
  }

  bool _isCompletedFileReady(DownloadTask task) {
    if (task.sourceType == 'dash') {
      return task.videoPath != null &&
          File(task.videoPath!).existsSync() &&
          task.audioPath != null &&
          File(task.audioPath!).existsSync();
    }
    return task.videoPath != null && File(task.videoPath!).existsSync();
  }

  Future<int> _localFileLength(String? path) async {
    if (path == null) {
      return 0;
    }
    final File file = File(path);
    if (await file.exists()) {
      return file.length();
    }
    final File partFile = File('$path.part');
    if (await partFile.exists()) {
      return partFile.length();
    }
    return 0;
  }

  Future<void> _migrateLegacyFile(String? oldPath, String? newPath) async {
    if (oldPath == null ||
        oldPath.isEmpty ||
        newPath == null ||
        newPath.isEmpty ||
        oldPath == newPath) {
      return;
    }
    await _moveFileIfNeeded(oldPath, newPath);
    await _moveFileIfNeeded('$oldPath.part', '$newPath.part');
  }

  Future<void> _moveFileIfNeeded(String oldPath, String newPath) async {
    final File oldFile = File(oldPath);
    final File newFile = File(newPath);
    if (!await oldFile.exists() || await newFile.exists()) {
      return;
    }
    await newFile.parent.create(recursive: true);
    try {
      await oldFile.rename(newPath);
    } catch (_) {
      await oldFile.copy(newPath);
      await oldFile.delete();
    }
  }

  Future<void> _deleteTaskFiles(DownloadTask task) async {
    final Directory dir = await _taskDirectory(task);
    if (await dir.exists()) {
      await dir.delete(recursive: true);
    }
  }

  Future<Directory> _taskDirectory(DownloadTask task) async {
    final Directory documentsDir = await getApplicationDocumentsDirectory();
    return Directory('${documentsDir.path}/dldl/downloads/${task.id}');
  }

  DownloadTask? _findTask(String id) {
    for (final DownloadTask task in tasks) {
      if (task.id == id) {
        return task;
      }
    }
    return null;
  }

  void _refreshTask(DownloadTask task, {bool persist = true}) {
    task.updateAggregateProgress();
    tasks.refresh();
    if (persist) {
      _saveTasks();
    }
  }

  void _saveTasks() {
    SPStorage.localCache.put(
      _tasksKey,
      tasks.map((task) => task.toJson()).toList(),
    );
  }
}
