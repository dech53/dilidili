import 'dart:async';

import 'package:dilidili/model/rank_type.dart';
import 'package:dilidili/pages/trend/zone/controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class TrendController extends GetxController with GetTickerProviderStateMixin {
  late final StreamController<bool> searchBarStream =
      StreamController<bool>.broadcast();
  late RxList tabs = [].obs;
  late TabController tabController;
  late List<Widget> tabsPageList;
  late List tabsCtrList;
  RxInt initialIndex = 0.obs;
  @override
  void onInit() {
    super.onInit();
    tabs.value = tabsConfig;
    initialIndex.value = 0;
    tabsCtrList = tabs
        .map((e) => Get.put(ZoneController(), tag: e['rid'].toString()))
        .toList();
    tabsPageList = tabs.map<Widget>((e) => e['page']).toList();
    tabController = TabController(
      initialIndex: initialIndex.value,
      length: tabs.length,
      vsync: this,
    );
  }

  @override
  void onClose() {
    searchBarStream.close();
    super.onClose();
  }
}
