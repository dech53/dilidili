import 'dart:math';

import 'package:dilidili/http/video.dart';
import 'package:dilidili/model/rcmd_video.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class RcmdController extends GetxController {
  final ScrollController scrollController = ScrollController();
  late RxList<dynamic> videoList;
  bool isLoadingMore = true;
  int _currentPage = 0;
  RxInt crossAxisCount = 2.obs;

  @override
  void onInit() {
    super.onInit();
    videoList = <RcmdVideoItem>[].obs;
  }

  Future queryRcmdFeed(type) async {
    if (isLoadingMore == false) {
      return;
    }
    if (type == 'onRefresh') {
      _currentPage = Random().nextInt(1000);
    }
    late final Map<String, dynamic> res;
    res = await VideoHttp.rcmdVideoList(
      freshIdx: _currentPage,
      ps: 20,
    );
    if (res['status']) {
      if (type == 'init') {
        if (videoList.isNotEmpty) {
          videoList.addAll(res['data']);
        } else {
          videoList.value = res['data'];
        }
      } else if (type == 'onRefresh') {
        videoList.value = res['data'];
      } else if (type == 'onLoad') {
        videoList.addAll(res['data']);
      }
      _currentPage += 1;
      if (res['data'].length > 1 && videoList.length < 10) {
        queryRcmdFeed('onLoad');
      }
    }
    _currentPage += 1;
    if (res['data'].length > 1 && videoList.length < 10) {
      queryRcmdFeed('onLoad');
    }
    isLoadingMore = false;
    return res;
  }

  void animateToTop() async {
    if (scrollController.offset >=
        MediaQuery.of(Get.context!).size.height * 5) {
      scrollController.jumpTo(0);
    } else {
      await scrollController.animateTo(0,
          duration: const Duration(milliseconds: 500), curve: Curves.easeInOut);
    }
  }

  // 下拉刷新
  Future onRefresh() async {
    isLoadingMore = true;
    queryRcmdFeed('onRefresh');
  }

  // 上拉加载
  Future onLoad() async {
    queryRcmdFeed('onLoad');
  }
}
