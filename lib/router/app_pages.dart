import 'package:dilidili/pages/about/view.dart';
import 'package:dilidili/pages/fav_detail/view.dart';
import 'package:dilidili/pages/follow/view.dart';
import 'package:dilidili/pages/history/view.dart';
import 'package:dilidili/pages/home/view.dart';
import 'package:dilidili/pages/live_room/view.dart';
import 'package:dilidili/pages/member/view.dart';
import 'package:dilidili/pages/moments/detail/view.dart';
import 'package:dilidili/pages/read/view.dart';
import 'package:dilidili/pages/search/view.dart';
import 'package:dilidili/pages/search_result/view.dart';
import 'package:dilidili/pages/setting/view.dart';
import 'package:dilidili/pages/video/detail/view.dart';
import 'package:dilidili/pages/webview/view.dart';
import 'package:dilidili/pages/whisper/view.dart';
import 'package:dilidili/pages/whisper_detail/view.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class Routes {
  static final List<GetPage<dynamic>> getPages = [
    CustomGetPage(name: '/', page: () => const HomePage()),
    CustomGetPage(name: '/video/:bvid', page: () => const VideoPage()),
    CustomGetPage(name: '/member/:mid', page: () => const MemberPage()),
    CustomGetPage(name: '/search', page: () => const SearchPage()),
    CustomGetPage(name: '/searchResult', page: () => const SearchResultPage()),
    CustomGetPage(name: '/read', page: () => const ReadPage()),
    CustomGetPage(name: '/webview', page: () => const WebviewPage()),
    CustomGetPage(name: '/whisper', page: () => const WhisperPage()),
    CustomGetPage(
        name: '/whisperDetail', page: () => const WhisperDetailPage()),
    CustomGetPage(name: '/liveRoom', page: () => const LiveRoomPage()),
    CustomGetPage(name: '/setting', page: () => const SettingPage()),
    CustomGetPage(name: '/about', page: () => const AboutPage()),
    CustomGetPage(name: '/momentsDetail', page: () => const MomentsDetail()),
    CustomGetPage(name: '/favDetail', page: () => const FavDetailPage()),
    CustomGetPage(name: '/follow', page: () => const FollowPage()),
    CustomGetPage(name: '/history', page: () => const HistoryPage()),
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
