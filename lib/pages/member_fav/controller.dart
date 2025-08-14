import 'package:dilidili/http/user.dart';
import 'package:dilidili/model/user/fav_folder.dart';
import 'package:dilidili/model/user/info.dart';
import 'package:dilidili/utils/storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';

class FavoriteController extends GetxController {
  late int mid;
  late int ownerMid;
  Rx<FavFolderData> favFolderData = FavFolderData().obs;
  RxList<FavFolderItemData> favFolderList = <FavFolderItemData>[].obs;
  final ScrollController scrollController = ScrollController();
  Box userInfoCache = SPStorage.userInfo;
  UserInfoData? userInfo;
  RxBool hasMore = true.obs;
  int currentPage = 1;
  int pageSize = 60;
  RxBool isOwner = false.obs;
  @override
  void onInit() {
    super.onInit();
    mid = int.parse(Get.arguments['mid'] ?? '-1');
    userInfo = userInfoCache.get('userInfoCache');
    ownerMid = userInfo != null ? userInfo!.mid! : -1;
    isOwner.value = mid == -1 || mid == ownerMid;
  }

  Future<dynamic> queryFavFolder({type = 'init'}) async {
    if (userInfo == null) {
      return {'status': false, 'msg': '账号未登录', 'code': -101};
    }
    if (!hasMore.value) {
      return;
    }
    var res = await UserHttp.userfavFolder(
      pn: currentPage,
      ps: pageSize,
      mid: isOwner.value ? ownerMid : mid,
    );
    if (res['status']) {
      if (type == 'init') {
        favFolderData.value = res['data'];
        favFolderList.value = res['data'].list;
      } else {
        if (res['data'].list.isNotEmpty) {
          favFolderList.addAll(res['data'].list);
          favFolderData.update((val) {});
        }
      }
      hasMore.value = res['data'].hasMore;
      currentPage++;
    } else {
      SmartDialog.showToast(res['msg']);
    }
    return res;
  }

  Future onLoad() async {
    queryFavFolder(type: 'onload');
  }

  removeFavFolder({required int mediaIds}) async {
    for (var i in favFolderList) {
      if (i.id == mediaIds) {
        favFolderList.remove(i);
        break;
      }
    }
  }
}
