import 'package:dilidili/model/danmaku/dm.pb.dart';
import 'package:dilidili/pages/damuku/controller.dart';
import 'package:dilidili/pages/dplayer/controller.dart';
import 'package:dilidili/pages/dplayer/models/play_status.dart';
import 'package:dilidili/utils/danmaku.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ns_danmaku/danmaku_controller.dart';
import 'package:ns_danmaku/danmaku_view.dart';
import 'package:ns_danmaku/models/danmaku_item.dart';
import 'package:ns_danmaku/models/danmaku_option.dart';

class Danmuku extends StatefulWidget {
  const Danmuku({
    super.key,
    required this.cid,
    required this.playerController,
    this.type = 'video',
  });
  final int cid;
  final DPlayerController playerController;
  final String type;
  @override
  State<Danmuku> createState() => _DanmukuState();
}

class _DanmukuState extends State<Danmuku> {
  late DPlayerController playerController;
  late DanmukuController _danmakuController;
  DanmakuController? _controller;
  late bool enableShowDanmaku;
  int latestAddedPosition = -1;
  @override
  void initState() {
    super.initState();
    enableShowDanmaku = false;
    _danmakuController = DanmukuController(widget.cid, widget.type);
    playerController = widget.playerController;
    if (mounted && widget.type == 'video') {
      if (enableShowDanmaku || playerController.isOpenDanmu.value) {
        _danmakuController.initiate(
          playerController.duration.value.inMilliseconds,
          playerController.position.value.inMilliseconds,
        );
      }
      playerController
        ..addStatusLister(playerListener)
        ..addPositionListener(videoPositionListen);
    }
  }

  void playerListener(DPlayerStatus? status) {
    if (status == DPlayerStatus.paused) {
      _controller!.pause();
    }
    if (status == DPlayerStatus.playing) {
      _controller!.onResume();
    }
  }

  void videoPositionListen(Duration position) {
    if (!playerController.isOpenDanmu.value) {
      return;
    }
    int currentPosition = position.inMilliseconds;
    currentPosition -= currentPosition % 100;

    if (currentPosition == latestAddedPosition) {
      return;
    }
    latestAddedPosition = currentPosition;

    List<DanmakuElem>? currentDanmakuList =
        _danmakuController.getCurrentDanmaku(currentPosition);

    if (currentDanmakuList != null) {
      _controller!.addItems(currentDanmakuList
          .map((e) => DanmakuItem(
                e.content,
                color: DmUtils.decimalToColor(e.color),
                time: e.progress,
                type: DmUtils.getPosition(e.mode),
              ))
          .toList());
    }
  }

  @override
  void dispose() {
    playerController.removePositionListener(videoPositionListen);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, box) {
        return Obx(
          () => AnimatedOpacity(
            opacity: playerController.isOpenDanmu.value ? 1 : 0,
            duration: const Duration(milliseconds: 100),
            child: DanmakuView(
              createdController: (DanmakuController e) async {
                playerController.danmakuController = _controller = e;
              },
              option: DanmakuOption(
                strokeWidth: 1.5,
                area: 0.5,
                opacity: 1.0,
                fontSize: 15.0,
                duration: 4.0 / playerController.playbackSpeed,
              ),
              statusChanged: (isPlaying) {},
            ),
          ),
        );
      },
    );
  }
}
