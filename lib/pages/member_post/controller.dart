import 'package:dilidili/http/member.dart';
import 'package:dilidili/model/member/archive.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MemberPostController extends GetxController {
  late int mid;
  int pn = 1;
  int count = 0;
  RxMap<String, String> currentOrder = <String, String>{}.obs;
  RxList<Map<String, String>> orderList = [
    {'type': 'pubdate', 'label': '最新发布'},
    {'type': 'click', 'label': '最多播放'},
    {'type': 'stow', 'label': '最多收藏'},
    {'type': 'charge', 'label': '充电专属'},
  ].obs;
  final ScrollController scrollController = ScrollController();
  RxList<VListItemModel> postsList = <VListItemModel>[].obs;
  RxBool isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    mid = int.parse(Get.arguments['mid']!);
    currentOrder.value = orderList.first;
  }

  // 获取用户投稿
  Future getMemberPost(type) async {
    if (isLoading.value) {
      return;
    }
    isLoading.value = true;
    if (type == 'init') {
      pn = 1;
      postsList.clear();
    }
    var res = await MemberHttp.memberPost(
      mid: mid,
      pn: pn,
      order: currentOrder['type']!,
    );
    if (res['status']) {
      if (type == 'init') {
        postsList.value = res['data'].list.vlist;
      }
      if (type == 'onLoad') {
        postsList.addAll(res['data'].list.vlist);
      }
      count = res['data'].page['count'];
      pn += 1;
    }
    isLoading.value = false;
    return res;
  }

  // 上拉加载
  Future onLoad() async {
    getMemberPost('onLoad');
  }
}
