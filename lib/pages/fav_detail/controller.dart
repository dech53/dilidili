import 'package:dilidili/http/user.dart';
import 'package:dilidili/model/user/fav_detail.dart';
import 'package:dilidili/model/user/fav_folder.dart';
import 'package:dilidili/pages/member_fav/controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:get/get.dart';

class FavDetailController extends GetxController {
  int? mediaId;
  FavFolderItemData? item;
  RxString title = ''.obs;
  RxInt mediaCount = 0.obs;
  late String heroTag;
  bool isLoadingMore = false;
  int currentPage = 1;
  RxMap favInfo = {}.obs;
  RxList<FavDetailItemData> favList = <FavDetailItemData>[].obs;
  RxString loadingText = '加载中...'.obs;
  late String isOwner;

  @override
  void onInit() {
    item = Get.arguments['favFolderItem'];
    title.value = item!.title!;
    heroTag = Get.arguments['heroTag']!;
    isOwner = Get.arguments['isOwner']!;
    mediaId = int.parse(Get.arguments['mediaId']!);
  }

  Future<dynamic> queryUserFavFolderDetail({type = 'init'}) async {
    if (type == 'onLoad' && favList.length >= mediaCount.value) {
      loadingText.value = '没有更多了';
      return;
    }
    isLoadingMore = true;
    var res = await UserHttp.userFavFolderDetail(
      pn: currentPage,
      ps: 20,
      mediaId: mediaId!,
    );
    if (res['status']) {
      favInfo.value = res['data'].info;
      if (currentPage == 1 && type == 'init') {
        favList.value = res['data'].medias;
        mediaCount.value = res['data'].info['media_count'];
      } else if (type == 'onLoad') {
        favList.addAll(res['data'].medias);
      }
      if (favList.length >= mediaCount.value) {
        loadingText.value = '没有更多了';
      }
    }
    currentPage += 1;
    isLoadingMore = false;
    return res;
  }

  onLoad() {
    queryUserFavFolderDetail(type: 'onLoad');
  }

  onDelFavFolder() async {
    SmartDialog.show(
      useSystem: true,
      animationType: SmartAnimationType.centerFade_otherSlide,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('提示'),
          content: const Text('确定删除这个收藏夹吗？'),
          actions: [
            TextButton(
              onPressed: () async {
                SmartDialog.dismiss();
              },
              child: Text(
                '点错了',
                style: TextStyle(color: Theme.of(context).colorScheme.outline),
              ),
            ),
            TextButton(
              onPressed: () async {
                var res = await UserHttp.delFavFolder(mediaIds: mediaId!);
                SmartDialog.dismiss();
                SmartDialog.showToast(res['status'] ? '操作成功' : res['msg']);
                if (res['status']) {
                  FavoriteController favController =
                      Get.find<FavoriteController>();
                  await favController.removeFavFolder(mediaIds: mediaId!);
                  Get.back();
                }
              },
              child: const Text('确认'),
            )
          ],
        );
      },
    );
  }
}
