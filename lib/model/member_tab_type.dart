import 'package:dilidili/model/space/space/tab2.dart';
import 'package:flutter/material.dart';

enum MainTabType { home, dynamic, contribute, favorite, bangumi, cheese, shop }

extension MainTabTypeDesc on MainTabType {
  String get description => ['主页', '动态', '投稿', '收藏', '番剧', '课堂', '小店'][index];
  String get id => [
        'home',
        'dynamic',
        'contribute',
        'favorite',
        'bangumi',
        'cheese',
        'shop'
      ][index];
}

typedef MemberTabConfig = Map<String, dynamic>;

const Set<String> supportedMemberTabParams = {
  'home',
  'dynamic',
  'contribute',
  'favorite',
  'bangumi',
  'cheese',
  'shop',
};

final List<MemberTabConfig> memberTabs = [
  {
    'icon': const Icon(Icons.home_outlined, size: 15),
    'label': '主页',
    'param': 'home',
    'type': MainTabType.home,
    'implemented': true,
  },
  {
    'icon': const Icon(Icons.home_outlined, size: 15),
    'label': '动态',
    'param': 'dynamic',
    'type': MainTabType.dynamic,
    'implemented': true,
  },
  {
    'label': '投稿',
    'icon': const Icon(Icons.post_add, size: 15),
    'param': 'contribute',
    'type': MainTabType.contribute,
    'implemented': true,
  },
  {
    'icon': const Icon(Icons.favorite_outline, size: 15),
    'label': '收藏',
    'param': 'favorite',
    'type': MainTabType.favorite,
    'implemented': true,
  },
  {
    'icon': const Icon(Icons.movie_creation_outlined, size: 15),
    'label': '番剧',
    'param': 'bangumi',
    'type': MainTabType.bangumi,
    'implemented': false,
  },
  {
    'icon': const Icon(Icons.school_outlined, size: 15),
    'label': '课堂',
    'param': 'cheese',
    'type': MainTabType.cheese,
    'implemented': false,
  },
  {
    'icon': const Icon(Icons.storefront_outlined, size: 15),
    'label': '小店',
    'param': 'shop',
    'type': MainTabType.shop,
    'implemented': false,
  }
];

List<MemberTabConfig> fallbackMemberTabs({bool includeHome = false}) {
  final List<String> fallbackParams = [
    if (includeHome) MainTabType.home.id else MainTabType.dynamic.id,
    MainTabType.contribute.id,
    MainTabType.favorite.id,
    MainTabType.bangumi.id,
  ];
  return fallbackParams
      .map(
        (param) => memberTabs.firstWhere((item) => item['param'] == param),
      )
      .toList();
}

List<MemberTabConfig> memberTabsFromSpace(
  List<SpaceTab2>? tab2, {
  bool? hasItem,
}) {
  final bool hideEmptyHome = hasItem != true;
  if (tab2 == null || tab2.isEmpty) {
    return [];
  }

  final List<MemberTabConfig> tabs = [];
  for (final SpaceTab2 item in tab2) {
    final String? param = item.param;
    if (param == null || !supportedMemberTabParams.contains(param)) {
      continue;
    }
    if (hideEmptyHome && param == MainTabType.home.id) {
      continue;
    }
    final MemberTabConfig? config =
        memberTabs.cast<MemberTabConfig?>().firstWhere(
              (tab) => tab?['param'] == param,
              orElse: () => null,
            );
    if (config == null) continue;
    final String label =
        item.title?.isNotEmpty == true ? item.title! : config['label'];
    tabs.add({
      ...config,
      'label': label,
    });
  }
  return tabs;
}

String normalizeMemberDefaultTab(String? defaultTab) {
  return defaultTab == 'video' ? 'contribute' : defaultTab ?? 'contribute';
}
