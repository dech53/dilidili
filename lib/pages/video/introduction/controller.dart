import 'dart:async';

import 'package:dilidili/cache/shared_preferences_instance.dart';
import 'package:dilidili/http/static/api_string.dart';
import 'package:dilidili/http/video.dart';
import 'package:dilidili/model/nav_user_info.dart';
import 'package:dilidili/model/user/fav_folder.dart';
import 'package:dilidili/model/video/video_basic_info.dart';
import 'package:dilidili/model/video/video_tag.dart';
import 'package:dilidili/utils/id_utils.dart';
import 'package:dilidili/utils/storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:get/get.dart';
import 'package:share_plus/share_plus.dart';

class VideoIntroController extends GetxController {
  VideoIntroController({required this.bvid});
  SharedPreferencesInstance prefs = SPStorage.prefs;
  String bvid;
  // 在线人数
  RxString total = '1'.obs;
  Timer? timer;
  bool isPaused = false;
  // 是否关注
  RxMap followStatus = {}.obs;
  Rx<FavFolderData> favFolderData = FavFolderData().obs;
  // 是否点赞
  RxBool hasLike = false.obs;
  //是否点踩
  RxBool hasDisLike = false.obs;
  // 是否投币
  RxBool hasCoin = false.obs;
  PersistentBottomSheetController? bottomSheetController;
  // 是否收藏
  RxBool hasFav = false.obs;
  // up mid
  // int mid = int.parse(Get.arguments['mid']!);
  Rx<UserCardInfo> userInfo = UserCardInfo().obs;
  Rx<VideoDetailData> videoDetail = VideoDetailData().obs;
  RxList<VideoTag> videoTags = <VideoTag>[].obs;
  // 最近播放集数
  RxInt lastPlayCid = 0.obs;
  @override
  void onInit() async {
    super.onInit();
    // 定时更新在线人数
    queryOnlineTotal();
    startTimer();
    lastPlayCid.value = int.parse(Get.arguments['cid']!);
  }

  @override
  void onClose() {
    if (timer != null) {
      timer!.cancel();
    }
    super.onClose();
  }

  // 计时器
  void startTimer() {
    const duration = Duration(seconds: 30);
    timer = Timer.periodic(duration, (Timer timer) {
      if (!isPaused) {
        queryOnlineTotal();
      }
    });
  }

  // 修改分P或番剧分集
  Future changeSeasonOrbangu(
    String bvid,
    int cid,
    int? aid,
    String? cover,
  ) async {}

  // 查看同时在看人数
  Future queryOnlineTotal() async {
    var result = await VideoHttp.onlineTotal(
      aid: IdUtils.bv2av(bvid),
      bvid: bvid,
      cid: lastPlayCid.value,
    );
    if (result['status']) {
      total.value = result['data']['total'];
    }
  }

  //查询视频信息
  Future queryVideoIntro() async {
    var tagResult = await VideoHttp.videoTag(bvid: bvid);
    if (tagResult['status']) {
      videoTags.value = tagResult['data'];
    }
    var result = await VideoHttp.videoIntro(bvid: bvid);
    if (result['status']) {
      videoDetail.value = result['data'];
    }

    await queryUserInfo();
    queryFollowStatus();
    queryHasLikeVideo();
    queryHasCoinVideo();
    queryHasFavVideo();
    return tagResult;
  }

  //获取用户所有收藏夹信息
  Future queryVideoInFolder() async {
    var result = await VideoHttp.videoInFolder(
      mid: int.parse(await prefs.getString("DedeUserID")!),
      rid: IdUtils.bv2av(bvid),
    );
    if (result['status']) {
      favFolderData.value = result['data'];
    }
    return result;
  }

  // 查询关注状态
  Future queryFollowStatus() async {
    if (videoDetail.value.owner == null) {
      return;
    }
    var result = await VideoHttp.hasFollow(videoDetail.value.owner!.mid);
    if (result['status']) {
      followStatus.value = result['data'];
    }
    return result;
  }

  // 获取点赞状态
  Future queryHasLikeVideo() async {
    var result = await VideoHttp.hasLikeVideo(bvid: bvid);
    hasLike.value = result["data"] == 1 ? true : false;
  }

  // 获取投币状态
  Future queryHasCoinVideo() async {
    var result = await VideoHttp.hasCoinVideo(bvid: bvid);
    hasCoin.value = result["data"]['multiply'] == 0 ? false : true;
  }

  // 获取收藏状态
  Future queryHasFavVideo() async {
    var result = await VideoHttp.hasFavVideo(aid: IdUtils.bv2av(bvid));
    if (result['status']) {
      hasFav.value = result["data"]['favoured'];
    } else {
      hasFav.value = false;
    }
  }

  // 点赞
  Future actionLikeVideo() async {
    var result = await VideoHttp.likeVideo(bvid: bvid, type: !hasLike.value);
    if (result['status']) {
      if (!hasLike.value) {
        SmartDialog.showToast('点赞成功');
        hasLike.value = true;
        videoDetail.value.stat!.like = videoDetail.value.stat!.like! + 1;
      } else if (hasLike.value) {
        SmartDialog.showToast('取消赞');
        hasLike.value = false;
        videoDetail.value.stat!.like = videoDetail.value.stat!.like! - 1;
      }
      hasLike.refresh();
    } else {
      SmartDialog.showToast(result['msg']);
    }
  }

  // 分享视频
  Future actionShareVideo() async {
    var result = await Share.share(
            '${videoDetail.value.title} - ${ApiString.baseUrl}/video/$bvid')
        .whenComplete(() {});
    return result;
  }

  // 投币
  Future actionCoinVideo() async {
    showDialog(
      context: Get.context!,
      builder: (context) {
        return AlertDialog(
          title: const Text('选择投币个数'),
          contentPadding: const EdgeInsets.fromLTRB(0, 12, 0, 24),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [1, 2]
                .map(
                  (e) => ListTile(
                    title: Padding(
                      padding: const EdgeInsets.only(left: 20),
                      child: Text('$e 枚'),
                    ),
                    onTap: () async {
                      var res =
                          await VideoHttp.coinVideo(bvid: bvid, multiply: e);
                      if (res['status']) {
                        SmartDialog.showToast('投币成功');
                        hasCoin.value = true;
                        videoDetail.value.stat!.coin =
                            videoDetail.value.stat!.coin! + e;
                      } else {
                        SmartDialog.showToast(res['msg']);
                      }
                      Get.back();
                    },
                  ),
                )
                .toList(),
          ),
        );
      },
    );
  }

  // 关注、取关up
  Future actionRelationMod() async {
    final int currentStatus = followStatus['attribute'];
    int actionStatus = 0;
    switch (currentStatus) {
      case 0:
        actionStatus = 1;
        break;
      case 2:
        actionStatus = 2;
        break;
      default:
        actionStatus = 0;
        break;
    }
    var result = await VideoHttp.relationMod(
      mid: videoDetail.value.owner!.mid,
      act: actionStatus,
      reSrc: 14,
    );
    if (result['status']) {
      switch (currentStatus) {
        case 0:
          actionStatus = 2;
          break;
        case 2:
          actionStatus = 0;
          break;
        default:
          actionStatus = 0;
          break;
      }
      followStatus['attribute'] = actionStatus;
      followStatus.refresh();
      if (actionStatus == 2) {
        SmartDialog.showToast("操作成功");
      }
    }
    SmartDialog.showToast(result['msg']);
  }

  // 收藏
  Future actionFavVideo({type = 'choose'}) async {
    await queryVideoInFolder();
    int defaultFolderId = favFolderData.value.list!.first.id!;
    int favStatus = favFolderData.value.list!.first.favState!;
    var result = await VideoHttp.favVideo(
      aid: IdUtils.bv2av(bvid),
      addIds: favStatus == 0 ? '$defaultFolderId' : '',
      delIds: favStatus == 1 ? '$defaultFolderId' : '',
    );
    if (result['status']) {
      await queryHasFavVideo();
      SmartDialog.showToast("操作成功");
    } else {
      SmartDialog.showToast(result['msg']);
    }
    return;
  }

  // 获取up信息
  Future queryUserInfo() async {
    var result = await VideoHttp.userInfo(mid: videoDetail.value.owner!.mid);
    if (result['status']) {
      userInfo.value = result['data'];
    }
  }
}
