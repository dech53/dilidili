import 'package:dilidili/http/user.dart';
import 'package:dilidili/model/user/history.dart';
import 'package:dilidili/model/user/info.dart';
import 'package:dilidili/utils/storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
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

  // 删除某条历史记录
  Future delHistory(kid, business) async {
    String resKid = 'archive_$kid';
    if (business == 'live') {
      resKid = 'live_$kid';
    } else if (business.contains('article')) {
      resKid = 'article_$kid';
    }

    var res = await UserHttp.delHistory(resKid);
    if (res['status']) {
      historyList.removeWhere((e) => e.kid == kid);
      SmartDialog.showToast(res['msg']);
    }
  }

  

  // 删除已看历史记录
  Future onDelHistory() async {
    List<HisListItem> result =
        historyList.where((e) => e.progress == -1).toList();
    for (HisListItem i in result) {
      String resKid = 'archive_${i.kid}';
      await UserHttp.delHistory(resKid);
      historyList.removeWhere((e) => e.kid == i.kid);
    }
    SmartDialog.showToast('操作完成');
  }

  // 删除选中的记录
  Future onDelCheckedHistory() async {
    SmartDialog.show(
      useSystem: true,
      animationType: SmartAnimationType.centerFade_otherSlide,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('提示'),
          content: const Text('确认删除所选历史记录吗？'),
          actions: [
            TextButton(
              onPressed: () => SmartDialog.dismiss(),
              child: Text(
                '取消',
                style: TextStyle(
                  color: Theme.of(context).colorScheme.outline,
                ),
              ),
            ),
            TextButton(
              onPressed: () async {
                await SmartDialog.dismiss();
                SmartDialog.showLoading(msg: '请求中');
                List<HisListItem> result =
                    historyList.where((e) => e.checked!).toList();
                for (HisListItem i in result) {
                  String str = 'archive';
                  try {
                    str = i.history!.business!;
                  } catch (_) {}
                  String resKid = '${str}_${i.kid}';
                  await UserHttp.delHistory(resKid);
                  historyList.removeWhere((e) => e.kid == i.kid);
                }
                checkedCount.value = 0;
                SmartDialog.dismiss();
                enableMultiple.value = false;
              },
              child: const Text('确认'),
            )
          ],
        );
      },
    );
  }
}
