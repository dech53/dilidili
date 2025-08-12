import 'package:dilidili/http/user.dart';
import 'package:dilidili/model/user/history.dart';
import 'package:dilidili/model/user/info.dart';
import 'package:dilidili/utils/storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';

class HistoryController extends GetxController {
  final ScrollController scrollController = ScrollController();
  RxBool isLoading = false.obs;
  RxList<HisListItem> historyList = <HisListItem>[].obs;
  RxBool isLoadingMore = false.obs;
  RxBool pauseStatus = false.obs;
  RxBool enableMultiple = false.obs;
  Box userInfoCache = SPStorage.userInfo;
  RxInt checkedCount = 0.obs;
  UserInfoData? userInfo;
  @override
  void onInit() {
    super.onInit();
    // historyStatus();
    userInfo = userInfoCache.get('userInfoCache');
  }

  Future queryHistoryList({type = 'init'}) async {
    if (userInfo == null) {
      return {'status': false, 'msg': '账号未登录', 'code': -101};
    }
    int max = 0;
    int viewAt = 0;
    if (type == 'onload') {
      max = historyList.last.history!.oid!;
      viewAt = historyList.last.viewAt!;
    }
    isLoadingMore.value = true;
    var res = await UserHttp.historyList(max, viewAt);
    isLoadingMore.value = false;
    if (res['status']) {
      if (type == 'onload') {
        historyList.addAll(res['data'].list);
      } else {
        historyList.value = res['data'].list;
      }
    }
    return res;
  }

  Future onLoad() async {
    queryHistoryList(type: 'onload');
  }

  Future onRefresh() async {
    queryHistoryList(type: 'onRefresh');
  }

  // 删除选中的记录
  Future onDelCheckedHistory() async {}
}
