import 'dart:async';

import 'package:dilidili/pages/dplayer/controller.dart';
import 'package:dilidili/pages/dplayer/widgets/control_bar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:media_kit_video/media_kit_video.dart';
import 'package:screen_brightness/screen_brightness.dart';

class DPlayer extends StatefulWidget {
  const DPlayer({super.key, required this.controller});
  final DPlayerController controller;
  @override
  State<DPlayer> createState() => _DPlayerState();
}

class _DPlayerState extends State<DPlayer> {
  final RxDouble _brightnessValue = 0.0.obs;
  final RxBool _brightnessIndicator = false.obs;
  Timer? _brightnessTimer;
  late double screenWidth;
  @override
  void initState() {
    super.initState();
    screenWidth = Get.size.width;
    Future.microtask(() async {
      try {
        // ignore: deprecated_member_use
        _brightnessValue.value = await ScreenBrightness().current;
        // ignore: deprecated_member_use
        ScreenBrightness().onCurrentBrightnessChanged.listen((double value) {
          if (mounted) {
            _brightnessValue.value = value;
          }
        });
      } catch (_) {}
    });
  }

  Future<void> setBrightness(double value) async {
    try {
      // ignore: deprecated_member_use
      await ScreenBrightness().setScreenBrightness(value);
    } catch (_) {}
    _brightnessIndicator.value = true;
    _brightnessTimer?.cancel();
    _brightnessTimer = Timer(const Duration(milliseconds: 200), () {
      if (mounted) {
        _brightnessIndicator.value = false;
      }
    });
    widget.controller.brightness.value = value;
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

        //亮度控制条展示
        Obx(
          () => ControlBar(
            visible: _brightnessIndicator.value,
            icon: _brightnessValue.value < 1.0 / 3.0
                ? Icons.brightness_low
                : _brightnessValue.value < 2.0 / 3.0
                    ? Icons.brightness_medium
                    : Icons.brightness_high,
            value: _brightnessValue.value,
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
            // 垂直方向 音量/亮度调节
            onVerticalDragUpdate: (DragUpdateDetails details) async {
              final double totalWidth = MediaQuery.sizeOf(context).width;
              final double tapPosition = details.localPosition.dx;
              final double sectionWidth = totalWidth / 3;
              final double delta = details.delta.dy;
              if (tapPosition < sectionWidth) {
                // 左边区域 👈
                final double level = (screenWidth * 9 / 16) * 3;
                final double brightness =
                    _brightnessValue.value - delta / level;
                final double result = brightness.clamp(0.0, 1.0);
                setBrightness(result);
              } else if (tapPosition < sectionWidth * 2) {
              } else {}
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
