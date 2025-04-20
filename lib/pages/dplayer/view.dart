import 'package:dilidili/pages/dplayer/controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:media_kit_video/media_kit_video.dart';

class DPlayer extends StatefulWidget {
  const DPlayer({super.key, required this.controller});
  final DPlayerController controller;
  @override
  State<DPlayer> createState() => _DPlayerState();
}

class _DPlayerState extends State<DPlayer> {
  @override
  void initState() {
    super.initState();
  }

  

  // 双击播放、暂停
  void onDoubleTapCenter() {
    final DPlayerController _ = widget.controller;
    _.videoPlayerController!.playOrPause();
  }

  @override
  Widget build(BuildContext context) {
    final DPlayerController _ = widget.controller;
    final Color colorTheme = Theme.of(context).colorScheme.primary;
    const TextStyle subTitleStyle = TextStyle(
      height: 1.5,
      fontSize: 40.0,
      letterSpacing: 0.0,
      wordSpacing: 0.0,
      color: Color(0xffffffff),
      fontWeight: FontWeight.normal,
      backgroundColor: Color(0xaa000000),
    );
    const TextStyle textStyle = TextStyle(
      color: Colors.white,
      fontSize: 12,
    );
    return Stack(
      fit: StackFit.passthrough,
      children: <Widget>[
        Video(
          controls: NoVideoControls,
          controller: widget.controller.videoController!,
        ),
        Obx(
          () => Align(
            alignment: Alignment.topCenter,
            child: FractionalTranslation(
              translation: const Offset(0.0, 0.3),
              child: AnimatedOpacity(
                opacity: _.doubleSpeedStatus.value ? 1.0 : 0.0,
                duration: const Duration(milliseconds: 150),
                child: Container(
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: const Color(0x88000000),
                    borderRadius: BorderRadius.circular(16.0),
                  ),
                  height: 32.0,
                  width: 70.0,
                  child: const Center(
                    child: Text(
                      '倍速中',
                      style: TextStyle(color: Colors.white, fontSize: 13),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
        Positioned.fill(
          left: 16,
          top: 25,
          right: 15,
          bottom: 15,
          child: GestureDetector(
            onDoubleTapDown: (TapDownDetails details) {
              onDoubleTapCenter();
            },
            onLongPressStart: (LongPressStartDetails detail) {
              _.setDoubleSpeedStatus(true);
            },
            onLongPressEnd: (LongPressEndDetails details) {
              _.setDoubleSpeedStatus(false);
            },
          ),
        ),
        //
        Obx(() {
          if (_.dataStatus.loading) {
            return Center(
              child: Container(
                padding: const EdgeInsets.all(30),
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: RadialGradient(
                    colors: [Colors.black26, Colors.transparent],
                  ),
                ),
                child: Lottie.asset(
                  'assets/loading.json',
                  width: 200,
                ),
              ),
            );
          } else {
            return const SizedBox();
          }
        }),
      ],
    );
  }
}
