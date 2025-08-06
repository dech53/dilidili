import 'package:dilidili/pages/favorite/controller.dart';
import 'package:dilidili/pages/favorite/view.dart';
import 'package:dilidili/pages/memberMoment/controller.dart';
import 'package:dilidili/pages/memberMoment/view.dart';
import 'package:dilidili/pages/member_post/controller.dart';
import 'package:dilidili/pages/member_post/view.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

enum MainTabType { home, post, moment, favorite, column }

extension MainTabTypeDesc on MainTabType {
  String get description => ['主页', '投稿', '动态', '收藏', '专栏'][index];
  String get id => ['home', 'post', 'moment', 'favorite', 'column'][index];
}

List memberTabs = [
  {
    'icon': const Icon(Icons.home_outlined, size: 15),
    'label': '动态',
    'type': MainTabType.moment,
    'ctr': Get.find<MemberMomentController>,
    'page': const MemberMomentPage(),
  },
  {
    'label': '投稿',
    'icon': const Icon(Icons.post_add, size: 15),
    'type': MainTabType.post,
    'ctr': Get.find<MemberPostController>,
    'page': const MemberPostPage(),
  },
  {
    'icon': const Icon(Icons.favorite_outline, size: 15),
    'label': '收藏',
    'type': MainTabType.favorite,
    'ctr': Get.find<FavoriteController>,
    'page': const FavoritePage(),
  }
];
