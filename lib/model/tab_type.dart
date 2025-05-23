import 'package:dilidili/pages/bangumi/controller.dart';
import 'package:dilidili/pages/bangumi/view.dart';
import 'package:dilidili/pages/hot/controller.dart';
import 'package:dilidili/pages/hot/view.dart';
import 'package:dilidili/pages/live/controller.dart';
import 'package:dilidili/pages/live/view.dart';
import 'package:dilidili/pages/rcmd/controller.dart';
import 'package:dilidili/pages/rcmd/view.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

enum TabType { live, rcmd, hot, bangumi }

extension TabTypeDesc on TabType {
  String get description => ['推荐', '热门'][index];
  String get id => ['rcmd', 'hot'][index];
}

List tabsConfig = [
  {
    'icon': const Icon(
      Icons.live_tv_outlined,
      size: 15,
    ),
    'label': '直播',
    'type': TabType.live,
    'ctr': Get.find<LiveController>,
    'page': const LivePage(),
  },
  {
    'icon': const Icon(
      Icons.thumb_up_off_alt_outlined,
      size: 15,
    ),
    'label': '推荐',
    'type': TabType.rcmd,
    'ctr': Get.find<RcmdController>,
    'page': const RcmdPage(),
  },
  {
    'icon': const Icon(
      Icons.whatshot_outlined,
      size: 15,
    ),
    'label': '热门',
    'type': TabType.hot,
    'ctr': Get.find<HotController>,
    'page': const HotPage(),
  },
  {
    'icon': const Icon(
      Icons.play_circle_outlined,
      size: 15,
    ),
    'label': '番剧',
    'type': TabType.bangumi,
    'ctr': Get.find<BangumiController>,
    'page': const BangumiPage(),
  },
];
