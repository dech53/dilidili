import 'package:dilidili/pages/favorite/controller.dart';
import 'package:dilidili/pages/favorite/view.dart';
import 'package:dilidili/pages/memberHome/controller.dart';
import 'package:dilidili/pages/memberHome/view.dart';
import 'package:dilidili/pages/post/controller.dart';
import 'package:dilidili/pages/post/view.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

enum MainTabType { home, post, dynamic, favorite, column }

extension MainTabTypeDesc on MainTabType {
  String get description => ['主页', '投稿', '动态', '收藏', '专栏'][index];
  String get id => ['home', 'post', 'dynamic', 'favorite', 'column'][index];
}

List memberTabs = [
  {
    'icon': const Icon(Icons.home_outlined, size: 15),
    'label': '主页',
    'type': MainTabType.home,
    'ctr': Get.find<MemberHomeController>,
    'page': const MemberHomePage(),
  },
  {
    'label': '投稿',
    'icon': const Icon(Icons.post_add, size: 15),
    'type': MainTabType.post,
    'ctr':Get.find<PostController>,
    'page': const PostPage(),
  },
  {
    'icon': const Icon(Icons.favorite_outline, size: 15),
    'label': '收藏',
    'type': MainTabType.favorite,
    'ctr': Get.find<FavoriteController>,
    'page': const FavoritePage(),
  }
];
