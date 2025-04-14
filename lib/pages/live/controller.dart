import 'package:dilidili/http/live.dart';
import 'package:dilidili/model/live/following_item.dart';
import 'package:dilidili/model/live/rcmd_item.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LiveController extends GetxController {
  final ScrollController scrollController = ScrollController();
  int _currentPage = 1;
  RxInt crossAxisCount = 2.obs;
  @override
  void onInit() {
    super.onInit();
    fetchLiveFollowing();
  }

  RxList<RecommendLiveItem> liveRcmdList = <RecommendLiveItem>[].obs;
  RxList<FollowingLiveItem> liveFollowingList = <FollowingLiveItem>[].obs;
  Future fetchLiveFollowing() async {
    var res = await LiveHttp.liveFollowing(pn: 1, ps: 20);
    if (res['status']) {
      liveFollowingList.value = (res['data'].list as List<FollowingLiveItem>)
          .where((FollowingLiveItem item) =>
              item.liveStatus == 1 && item.recordLiveTime == 0)
          .toList();
    }
    return res;
  }

// 下拉刷新
  Future onRefresh() async {
    queryLiveList('init');
    fetchLiveFollowing();
  }

  // 上拉加载
  Future onLoad() async {
    queryLiveList('onLoad');
  }

// 获取推荐
  Future queryLiveList(type) async {
    var res = await LiveHttp.liveList();
    if (res['status']) {
      if (type == 'init') {
        liveRcmdList.value = res['data'];
      } else if (type == 'onLoad') {
        liveRcmdList.addAll(res['data']);
      }
    }
    return res;
  }

  // 返回顶部
  void animateToTop() async {
    if (scrollController.offset >=
        MediaQuery.of(Get.context!).size.height * 5) {
      scrollController.jumpTo(0);
    } else {
      await scrollController.animateTo(0,
          duration: const Duration(milliseconds: 500), curve: Curves.easeInOut);
    }
  }
}
