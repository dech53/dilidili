import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:media_kit/media_kit.dart';
import 'package:media_kit_video/media_kit_video.dart';

class DownloadVerifyPlayerPage extends StatefulWidget {
  const DownloadVerifyPlayerPage({super.key});

  @override
  State<DownloadVerifyPlayerPage> createState() =>
      _DownloadVerifyPlayerPageState();
}

class _DownloadVerifyPlayerPageState extends State<DownloadVerifyPlayerPage> {
  late final Player _player;
  late final VideoController _videoController;
  late final String _title;
  late final String _videoPath;
  late final String? _audioPath;
  late final Map _arguments;
  String? _error;

  @override
  void initState() {
    super.initState();
    _arguments = Get.arguments as Map;
    _title = _arguments['title']?.toString() ?? '本地播放验证';
    _videoPath = _arguments['videoPath']?.toString() ?? '';
    _audioPath = _arguments['audioPath']?.toString();
    _player = Player();
    _videoController = VideoController(_player);
    _openLocalMedia();
  }

  Future<void> _openLocalMedia() async {
    try {
      final File videoFile = File(_videoPath);
      if (!await videoFile.exists()) {
        setState(() {
          _error = '视频文件不存在';
        });
        return;
      }

      final String? audioPath = _audioPath;
      if (audioPath != null && audioPath.isNotEmpty) {
        final File audioFile = File(audioPath);
        if (await audioFile.exists()) {
          final NativePlayer nativePlayer = _player.platform as NativePlayer;
          await nativePlayer.setProperty(
            'audio-files',
            audioPath.replaceAll(':', '\\:'),
          );
        }
      }

      await _player.open(Media(_videoPath), play: true);
    } catch (err) {
      setState(() {
        _error = err.toString();
      });
    }
  }

  @override
  void dispose() {
    _player.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final ColorScheme colorScheme = Theme.of(context).colorScheme;
    return Scaffold(
      appBar: AppBar(
        titleSpacing: 0,
        centerTitle: false,
        title: Text(
          '本地播放验证',
          style: Theme.of(context).textTheme.titleMedium,
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(12, 12, 12, 24),
        children: [
          AspectRatio(
            aspectRatio: 16 / 9,
            child: ColoredBox(
              color: Colors.black,
              child: _error == null
                  ? Video(controller: _videoController)
                  : Center(
                      child: Text(
                        _error!,
                        style: TextStyle(color: colorScheme.error),
                      ),
                    ),
            ),
          ),
          const SizedBox(height: 16),
          Text(_title, style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 12),
          _DetailSection(arguments: _arguments),
          const SizedBox(height: 12),
          _PathInfo(title: '视频文件', path: _videoPath),
          if (_audioPath != null && _audioPath.isNotEmpty)
            _PathInfo(title: '音频文件', path: _audioPath),
        ],
      ),
    );
  }
}

class _DetailSection extends StatelessWidget {
  const _DetailSection({required this.arguments});

  final Map arguments;

  @override
  Widget build(BuildContext context) {
    final List<_DetailItem> items = [
      _DetailItem(
        '画质',
        '${arguments['qualityDescription'] ?? '未知'} (${arguments['quality'] ?? '-'})',
      ),
      _DetailItem(
        '视频编码',
        '${arguments['videoCodecDescription'] ?? '未知'} (${arguments['videoCodec'] ?? '-'})',
      ),
      _DetailItem(
        '音质',
        '${arguments['audioQualityDescription'] ?? '无'} (${arguments['audioQuality'] ?? '-'})',
      ),
      _DetailItem('资源类型', arguments['sourceType']?.toString() ?? '-'),
      _DetailItem('时长', _formatDuration(arguments['duration'])),
      _DetailItem(
        '记录大小',
        '${_formatBytes(arguments['downloadedBytes'])} / ${_formatBytes(arguments['totalBytes'])}',
      ),
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('缓存信息', style: Theme.of(context).textTheme.titleSmall),
        const SizedBox(height: 8),
        for (final _DetailItem item in items)
          Padding(
            padding: const EdgeInsets.only(bottom: 6),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  width: 76,
                  child: Text(
                    item.label,
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ),
                Expanded(
                  child: Text(
                    item.value,
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ),
              ],
            ),
          ),
      ],
    );
  }

  String _formatDuration(dynamic value) {
    final int? milliseconds = _asInt(value);
    if (milliseconds == null || milliseconds <= 0) {
      return '-';
    }
    final Duration duration = Duration(milliseconds: milliseconds);
    final String minutes = duration.inMinutes.toString().padLeft(2, '0');
    final String seconds =
        duration.inSeconds.remainder(60).toString().padLeft(2, '0');
    return '$minutes:$seconds';
  }

  String _formatBytes(dynamic value) {
    final int bytes = _asInt(value) ?? 0;
    if (bytes <= 0) {
      return '-';
    }
    const int kb = 1024;
    const int mb = kb * 1024;
    const int gb = mb * 1024;
    if (bytes >= gb) {
      return '${(bytes / gb).toStringAsFixed(2)} GB';
    }
    if (bytes >= mb) {
      return '${(bytes / mb).toStringAsFixed(2)} MB';
    }
    if (bytes >= kb) {
      return '${(bytes / kb).toStringAsFixed(2)} KB';
    }
    return '$bytes B';
  }

  int? _asInt(dynamic value) {
    if (value == null) {
      return null;
    }
    if (value is int) {
      return value;
    }
    if (value is num) {
      return value.toInt();
    }
    return int.tryParse(value.toString());
  }
}

class _DetailItem {
  const _DetailItem(this.label, this.value);

  final String label;
  final String value;
}

class _PathInfo extends StatelessWidget {
  const _PathInfo({required this.title, required this.path});

  final String title;
  final String path;

  @override
  Widget build(BuildContext context) {
    final bool exists = File(path).existsSync();
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '$title：${exists ? '存在' : '不存在'}',
            style: Theme.of(context).textTheme.titleSmall,
          ),
          const SizedBox(height: 4),
          SelectableText(
            path,
            style: Theme.of(context).textTheme.bodySmall,
          ),
        ],
      ),
    );
  }
}
