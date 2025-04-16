import 'package:dilidili/http/member.dart';
import 'package:dilidili/model/member/folder_detail.dart';
import 'package:dilidili/model/member/folder_info.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class FavoriteController extends GetxController {
  late int mid;
  RxList<FolderItem> favorites = <FolderItem>[].obs;
  RxList<FolderDetail> favoriteInfos = <FolderDetail>[].obs;
  final ScrollController scrollController = ScrollController();
  @override
  void onInit() {
    super.onInit();
    mid = int.parse(Get.parameters['mid']!);
  }

  Future getUserFolder() async {
    var res = await MemberHttp.getUserFolder(mid: mid);
    if (res['status']) {
      favorites.value = res['data'];
    }
    return res;
  }

  Future getUserFolderDetail() async {
    await getUserFolder();
    var res;
    if (favorites.isNotEmpty) {
      for (var item in favorites) {
        res = await MemberHttp.memberFolderDetail(id: item.id!);
        if (res['status']) {
          favoriteInfos.add(res['data']);
        }
      }
    } else {
      res = {
        'status': false,
        'data': [],
        'msg': '用户没有公开收藏夹',
      };
    }
    return res;
  }
}
