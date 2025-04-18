import 'dart:io';

import 'package:dilidili/pages/dplayer/models/data_source.dart';
import 'package:dilidili/pages/video/detail/play/ao_output.dart';
import 'package:get/get.dart';
import 'package:media_kit/media_kit.dart';
import 'package:media_kit_video/media_kit_video.dart';

class DPlayerController extends GetxController {
  Player? _videoPlayerController;
  VideoController? _videoController;
  final Rx<int> _playerCount = Rx(0);
  static DPlayerController? _instance;
  Player? get videoPlayerController => _videoPlayerController;
  //私有构造函数
  DPlayerController._internal();

  VideoController? get videoController => _videoController;

  factory DPlayerController({
    String videoType = 'archive',
  }) {
    _instance ??= DPlayerController._internal();
    if (videoType != 'none') {
      _instance!._playerCount.value += 1;
    }
    return _instance!;
  }

  Future<void> initVideoController() async {
    _videoController = VideoController(Player());
  }

  Future<void> setDataSource(DataSource dataSource) async {
    _videoPlayerController = await _createVideoController(
        dataSource, PlaylistMode.none, true, Duration.zero);
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

  Future<void> dispose() async {
    try {
    if (_videoPlayerController != null) {
      var pp = _videoPlayerController!.platform as NativePlayer;
      await pp.setProperty('audio-files', '');
      await _videoPlayerController?.dispose();
      _videoPlayerController = null;
    }
     _instance = null;
    }catch(e){
      print(e);
    }
  }
}
