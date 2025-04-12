import 'package:dilidili/pages/home/home_page.dart';
import 'package:dilidili/pages/video/detail/video_page.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class Routes {
  static final List<GetPage<dynamic>> getPages = [
    CustomGetPage(name: '/', page: () => const HomePage()),
    CustomGetPage(name: '/video', page: () => const VideoPage()),
  ];
}

class CustomGetPage extends GetPage<dynamic> {
  CustomGetPage({
    required super.name,
    required super.page,
    this.fullscreen,
    super.transitionDuration,
  }) : super(
          curve: Curves.linear,
          transition: Transition.native,
          showCupertinoParallax: false,
          popGesture: false,
          fullscreenDialog: fullscreen != null && fullscreen,
        );
  bool? fullscreen = false;
}
