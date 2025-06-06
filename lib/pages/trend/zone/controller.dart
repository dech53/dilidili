import 'package:dilidili/http/video.dart';
import 'package:dilidili/model/model_hot_video_item.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ZoneController extends GetxController {
  final ScrollController scrollController = ScrollController();
  RxList<HotVideoItemModel> videoList = <HotVideoItemModel>[].obs;
  bool isLoadingMore = false;
  bool flag = false;
  int zoneID = 0;
  // 获取推荐
  Future queryRankFeed(type, rid) async {
    zoneID = rid;
    var res = await VideoHttp.getRankVideoList(zoneID);
    if (res['status']) {
      if (type == 'init') {
        videoList.value = res['data'];
      } else if (type == 'onRefresh') {
        videoList.clear();
        videoList.addAll(res['data']);
      } else if (type == 'onLoad') {
        videoList.clear();
        videoList.addAll(res['data']);
      }
    }
    isLoadingMore = false;
    return res;
  }

  // 下拉刷新
  Future onRefresh() async {
    queryRankFeed('onRefresh', zoneID);
  }

  // 上拉加载
  Future onLoad() async {
    queryRankFeed('onLoad', zoneID);
  }

  // 返回顶部并刷新
  void animateToTop() async {
    if (scrollController.hasClients) {
      if (scrollController.offset >=
          MediaQuery.of(Get.context!).size.height * 5) {
        scrollController.jumpTo(0);
      } else {
        await scrollController.animateTo(0,
            duration: const Duration(milliseconds: 500),
            curve: Curves.easeInOut);
      }
    }
  }
}
