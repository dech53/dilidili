import 'package:dilidili/model/tab_type.dart';
import 'package:dilidili/utils/storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';

class HomeController extends GetxController with GetTickerProviderStateMixin {
  late TabController tabController;
  late RxList tabs = [].obs;
  late List tabsCtrList;
  late List<Widget> tabsPageList;
  RxInt initialIndex = 1.obs;
  RxString userFace = ''.obs;
  RxString userName = ''.obs;
  Box userInfoCache = SPStorage.userInfo;
  var userInfo;

  void onRefresh() {
    int index = tabController.index;
    var ctr = tabsCtrList[index];
    ctr().onRefresh();
  }

  void animateToTop() {
    int index = tabController.index;
    var ctr = tabsCtrList[index];
    ctr().animateToTop();
  }

  @override
  void onInit() {
    super.onInit();
    tabs.value = tabsConfig;
    tabsCtrList = tabs.map((e) => e['ctr']).toList();
    tabsPageList = tabs.map<Widget>((e) => e['page']).toList();
    tabController = TabController(
      initialIndex: initialIndex.value,
      length: tabs.length,
      vsync: this,
    );
    userInfo = userInfoCache.get('userInfoCache');
    userFace.value = userInfo != null ? userInfo.face : '';
    userName.value = userInfo != null ? userInfo.uname : '';
    tabController.animation!.addListener(() {
      if (tabController.indexIsChanging) {
        if (initialIndex.value != tabController.index) {
          initialIndex.value = tabController.index;
        }
      } else {
        final int temp = tabController.animation!.value.round();
        if (initialIndex.value != temp) {
          initialIndex.value = temp;
          tabController.index = initialIndex.value;
        }
      }
    });
  }
}
