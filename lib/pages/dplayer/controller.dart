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
import 'package:screen_brightness/screen_brightness.dart';

class DPlayerController extends GetxController {
  //头部控制栏
  PreferredSizeWidget? headerControl;

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

  /// 亮度控制
  final Rx<double> _currentBrightness = 0.0.obs;
  Rx<double> get brightness => _currentBrightness;

  //私有构造函数
  DPlayerController._internal();

  //获取私有控制器
  Player? get videoPlayerController => _videoPlayerController;
  VideoController? get videoController => _videoController;

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

  //构造函数
  factory DPlayerController({
    String videoType = 'archive',
  }) {
    _instance ??= DPlayerController._internal();
    if (videoType != 'none') {
      _instance!._playerCount.value += 1;
      
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

  Future<void> setDataSource(DataSource dataSource) async {
    if (_playerCount.value == 0) {
      return;
    }
    dataStatus.status.value = DataStatus.loading;
    _videoPlayerController = await _createVideoController(
        dataSource, PlaylistMode.none, true, Duration.zero);
    dataStatus.status.value = DataStatus.loaded;
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

  Future<void> dispose({String type = 'single'}) async {
    if (type == 'single' && playerCount.value > 1) {
      _playerCount.value -= 1;
      pause();
      return;
    }
    _playerCount.value = 0;
    try {
      _timer?.cancel();
      if (_videoPlayerController != null) {
        var pp = _videoPlayerController!.platform as NativePlayer;
        await pp.setProperty('audio-files', '');
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

  Future<void> play() async {
    await _videoPlayerController?.play();
    playerStatus.status.value = DPlayerStatus.playing;
  }
}
