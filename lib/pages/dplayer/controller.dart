import 'dart:async';
import 'dart:io';

import 'package:dilidili/pages/dplayer/models/data_source.dart';
import 'package:dilidili/pages/dplayer/models/data_status.dart';
import 'package:dilidili/pages/dplayer/models/play_status.dart';
import 'package:dilidili/pages/video/detail/play/ao_output.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:media_kit/media_kit.dart';
import 'package:media_kit_video/media_kit_video.dart';
import 'package:ns_danmaku/danmaku_controller.dart';
import 'package:screen_brightness/screen_brightness.dart';

class DPlayerController extends GetxController {
  Timer? _timerForSeek;
  //头部控制栏
  PreferredSizeWidget? headerControl;
  String videoType = 'archive';
  //弹幕组件
  Widget? danmuWidget;

  /// 弹幕开关
  Rx<bool> isOpenDanmu = true.obs;
  DanmakuController? danmakuController;

  /// 视频比例
  Rx<BoxFit> get videoFit => _videoFit;
  final Rx<BoxFit> _videoFit = Rx(BoxFit.contain);

  /// 视频时长
  Rx<Duration> get duration => _duration;
  final Rx<Duration> _duration = Rx(Duration.zero);
  final RxInt durationSeconds = 0.obs;
  final Rx<Duration> _buffered = Rx(Duration.zero);
  final RxInt bufferedSeconds = 0.obs;
// 播放位置
  final Rx<Duration> _sliderPosition = Rx(Duration.zero);
  final RxInt sliderPositionSeconds = 0.obs;

  /// 全屏状态
  final Rx<bool> _isFullScreen = false.obs;
  Rx<bool> get isFullScreen => _isFullScreen;
  // 播放位置
  final Rx<Duration> _position = Rx(Duration.zero);
  Rx<Duration> get position => _position;
  Stream<Duration> get onPositionChanged => _position.stream;
  final RxInt positionSeconds = 0.obs;

  final DPPlayerStatus playerStatus = DPPlayerStatus();

  /// 播放状态监听
  Stream<DPlayerStatus> get onPlayerStatusChanged => playerStatus.status.stream;
  //数据状态、监听
  final DPlayerDataStatus dataStatus = DPlayerDataStatus();
  Stream<DataStatus> get onDataStatusChanged => dataStatus.status.stream;

  Timer? _timer;
  //主控制器
  Player? _videoPlayerController;
  VideoController? _videoController;
  final Rx<int> _playerCount = Rx(0);
  Rx<int> get playerCount => _playerCount;
  // 默认投稿视频格式
  static Rx<String> _videoType = 'archive'.obs;

  /// 是否展示控制条及监听
  final Rx<bool> _showControls = false.obs;
  Rx<bool> get showControls => _showControls;
  Stream<bool> get onShowControlsChanged => _showControls.stream;

  //是否倍速
  final Rx<bool> _doubleSpeedStatus = false.obs;
  Rx<bool> get doubleSpeedStatus => _doubleSpeedStatus;

  //播放速度
  final Rx<double> _playbackSpeed = 1.0.obs;
  double get playbackSpeed => _playbackSpeed.value;

  static DPlayerController? _instance;

  Rx<bool> _isSliderMoving = false.obs;
  Rx<bool> get isSliderMoving => _isSliderMoving;

  /// 亮度控制
  final Rx<double> _currentBrightness = 0.0.obs;
  Rx<double> get brightness => _currentBrightness;

  //私有构造函数
  DPlayerController._internal(this.videoType) {}

  //获取私有控制器
  Player? get videoPlayerController => _videoPlayerController;
  VideoController? get videoController => _videoController;

  List<StreamSubscription> subscriptions = [];
  final List<Function(Duration position)> _positionListeners = [];
  final List<Function(DPlayerStatus status)> _statusListeners = [];

  /// 播放事件监听
  void startListeners() {
    subscriptions.addAll([
      videoPlayerController!.stream.position.listen((event) {
        _position.value = event;
        updatePositionSecond();
        if (!isSliderMoving.value) {
          _sliderPosition.value = event;
          updateSliderPositionSecond();
        }
        for (var element in _positionListeners) {
          element(event);
        }
      }),
      videoPlayerController!.stream.playing.listen(
        (event) {
          if (event) {
            playerStatus.status.value = DPlayerStatus.playing;
          } else {
            playerStatus.status.value = DPlayerStatus.paused;
          }

          /// 触发回调事件
          for (var element in _statusListeners) {
            element(event ? DPlayerStatus.playing : DPlayerStatus.paused);
          }
        },
      ),
      videoPlayerController!.stream.completed.listen((event) {
        if (event) {
          playerStatus.status.value = DPlayerStatus.completed;

          /// 触发回调事件
          for (var element in _statusListeners) {
            element(DPlayerStatus.completed);
          }
        }
      }),
      videoPlayerController!.stream.duration.listen((event) {
        if (event > Duration.zero) {
          duration.value = event;
        }
      }),
      videoPlayerController!.stream.buffer.listen((event) {
        _buffered.value = event;
        updateBufferedSecond();
      }),
    ]);
  }

  void addPositionListener(Function(Duration position) listener) =>
      _positionListeners.add(listener);
  void removePositionListener(Function(Duration position) listener) =>
      _positionListeners.remove(listener);
  void addStatusLister(Function(DPlayerStatus status) listener) =>
      _statusListeners.add(listener);
  void removeStatusLister(Function(DPlayerStatus status) listener) =>
      _statusListeners.remove(listener);

  set controls(bool visible) {
    _showControls.value = visible;
    _timer?.cancel();
    if (visible) {
      _hideTaskControls();
    }
  }

  /// 隐藏控制条
  void _hideTaskControls() {
    if (_timer != null) {
      _timer!.cancel();
    }
    _timer = Timer(const Duration(milliseconds: 3000), () {
      controls = false;
      _timer = null;
    });
  }

  void updateSliderPositionSecond() {
    int newSecond = _sliderPosition.value.inSeconds;
    if (sliderPositionSeconds.value != newSecond) {
      sliderPositionSeconds.value = newSecond;
    }
  }

  void updatePositionSecond() {
    int newSecond = _position.value.inSeconds;
    if (positionSeconds.value != newSecond) {
      positionSeconds.value = newSecond;
    }
  }

  void updateDurationSecond() {
    int newSecond = _duration.value.inSeconds;
    if (durationSeconds.value != newSecond) {
      durationSeconds.value = newSecond;
    }
  }

  void updateBufferedSecond() {
    int newSecond = _buffered.value.inSeconds;
    if (bufferedSeconds.value != newSecond) {
      bufferedSeconds.value = newSecond;
    }
  }

  //构造函数
  factory DPlayerController({
    String videoType = 'archive',
  }) {
    _instance ??= DPlayerController._internal(videoType);
    if (videoType != 'none') {
      _instance!._playerCount.value += 1;
      _videoType.value = videoType;
    }
    return _instance!;
  }

  Future<void> setBrightness(double brightnes) async {
    try {
      brightness.value = brightnes;
      ScreenBrightness().setScreenBrightness(brightnes);
      // setVideoBrightness();
    } catch (e) {
      throw 'Failed to set brightness';
    }
  }

  Future<void> resetBrightness() async {
    try {
      await ScreenBrightness().resetScreenBrightness();
    } catch (e) {
      throw 'Failed to reset brightness';
    }
  }

  Future<void> setDataSource(
    DataSource dataSource, {
    Duration? duration,
  }) async {
    if (_playerCount.value == 0) {
      return;
    }
    dataStatus.status.value = DataStatus.loading;
    _videoPlayerController = await _createVideoController(
        dataSource, PlaylistMode.none, true, Duration.zero);
    _duration.value = duration ?? _videoPlayerController!.state.duration;
    updateDurationSecond();
    dataStatus.status.value = DataStatus.loaded;
    startListeners();
    await play(duration: duration);
  }

  /// 设置倍速
  Future<void> setPlaybackSpeed(double speed) async {
    await _videoPlayerController?.setRate(speed);
    // fix 长按倍速后放开不恢复
    if (!doubleSpeedStatus.value) {
      _playbackSpeed.value = speed;
    }
  }

  // 配置播放器
  Future<Player> _createVideoController(
    DataSource dataSource,
    PlaylistMode looping,
    bool enableHA,
    Duration seekTo,
  ) async {
    _position.value = Duration.zero;
    Player player = _videoPlayerController ??
        Player(
          configuration: const PlayerConfiguration(
            // 默认缓存 5M 大小
            bufferSize: 5 * 1024 * 1024,
          ),
        );
    var pp = player.platform as NativePlayer;
    await pp.setProperty("af", "scaletempo2=max-speed=8");
    //  音量不一致
    if (Platform.isAndroid) {
      await pp.setProperty("volume-max", "100");
      String defaultAoOutput = '0';

      await pp.setProperty(
          "ao",
          aoOutputList
              .where((e) => e['value'] == defaultAoOutput)
              .first['title']);
    }
    await player.setAudioTrack(
      AudioTrack.auto(),
    ); // 音轨
    if (dataSource.audioSource != '' && dataSource.audioSource != null) {
      await pp.setProperty(
        'audio-files',
        dataSource.audioSource!.replaceAll(':', '\\:'),
      );
    } else {
      await pp.setProperty(
        'audio-files',
        '',
      );
    }
    _videoController = _videoController ??
        VideoController(
          player,
          configuration: VideoControllerConfiguration(
            enableHardwareAcceleration: enableHA,
            androidAttachSurfaceAfterVideoParameters: false,
          ),
        );
    if (dataSource.type == DataSourceType.asset) {
      final assetUrl = dataSource.videoSource!.startsWith("asset://")
          ? dataSource.videoSource!
          : "asset://${dataSource.videoSource!}";
      player.open(
        Media(assetUrl, httpHeaders: dataSource.httpHeaders),
        play: false,
      );
    }
    await player.open(
      Media(dataSource.videoSource!,
          httpHeaders: dataSource.httpHeaders, start: seekTo),
      play: false,
    );
    await player.play();
    return player;
  }

  /// 移除事件监听
  void removeListeners() {
    for (final s in subscriptions) {
      s.cancel();
    }
  }

  Future<void> dispose({String type = 'single'}) async {
    if (type == 'single' && playerCount.value > 1) {
      _playerCount.value -= 1;
      pause();
      return;
    }
    _playerCount.value = 0;
    try {
      _timer?.cancel();
      _timerForSeek?.cancel();
      if (_videoPlayerController != null) {
        var pp = _videoPlayerController!.platform as NativePlayer;
        await pp.setProperty('audio-files', '');
        removeListeners();
        await _videoPlayerController?.dispose();
        _videoPlayerController = null;
      }
      _instance = null;
      resetBrightness();
    } catch (e) {
      print(e);
    }
  }

  void setDoubleSpeedStatus(bool status) {
    if (videoType == 'live') {
      return;
    }
    _doubleSpeedStatus.value = status;
    if (status) {
      setPlaybackSpeed(playbackSpeed * 2);
    } else {
      setPlaybackSpeed(playbackSpeed);
    }
  }

  /// 暂停播放
  Future<void> pause({bool notify = true, bool isInterrupt = false}) async {
    await _videoPlayerController?.pause();
    playerStatus.status.value = DPlayerStatus.paused;
  }

  Future<void> play(
      {bool repeat = false, bool hideControls = true, dynamic duration}) async {
    await _videoPlayerController?.play();
    playerStatus.status.value = DPlayerStatus.playing;
    if (duration != null) {
      _duration.value = duration;
      updateDurationSecond();
    }
  }

  /// 跳转至指定位置
  Future<void> seekTo(Duration position, {type = 'seek'}) async {
    try {
      if (position < Duration.zero) {
        position = Duration.zero;
      }
      _position.value = position;
      updatePositionSecond();
      if (duration.value.inSeconds != 0) {
        if (type != 'slider') {
          await _videoPlayerController?.stream.buffer.first;
        }
        await _videoPlayerController?.seek(position);
      } else {
        _timerForSeek?.cancel();
        _timerForSeek ??= _startSeekTimer(position);
      }
    } catch (err) {
      print('Error while seeking: $err');
    }
  }

  Timer? _startSeekTimer(Duration position) {
    return Timer.periodic(const Duration(milliseconds: 200), (Timer t) async {
      if (duration.value.inSeconds != 0) {
        await _videoPlayerController!.stream.buffer.first;
        await _videoPlayerController?.seek(position);
        t.cancel();
        _timerForSeek = null;
      }
    });
  }
}
