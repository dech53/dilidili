import 'package:dilidili/pages/home/view.dart';
import 'package:dilidili/pages/member/view.dart';
import 'package:dilidili/pages/search/view.dart';
import 'package:dilidili/pages/search_result/view.dart';
import 'package:dilidili/pages/video/detail/view.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class Routes {
  static final List<GetPage<dynamic>> getPages = [
    CustomGetPage(name: '/', page: () => const HomePage()),
    CustomGetPage(name: '/video', page: () => const VideoPage()),
    CustomGetPage(name: '/member', page: () => const MemberPage()),
    CustomGetPage(name: '/search', page: () => const SearchPage()),
    CustomGetPage(name: '/searchResult', page: () => const SearchResultPage())
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
