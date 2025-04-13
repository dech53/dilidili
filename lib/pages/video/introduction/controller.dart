import 'dart:async';

import 'package:dilidili/http/video.dart';
import 'package:dilidili/model/nav_user_info.dart';
import 'package:dilidili/model/video/video_basic_info.dart';
import 'package:dilidili/utils/id_utils.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:get/get.dart';

class VideoIntroController extends GetxController {
  VideoIntroController({required this.bvid});
  String bvid;
  //在线人数
  RxString total = '1'.obs;
  Timer? timer;
  //是否关注
  RxMap followStatus = {}.obs;
  //up mid
  int mid = int.parse(Get.parameters['mid']!);
  Rx<UserCardInfo> userInfo = UserCardInfo().obs;
  Rx<VideoDetailData> videoDetail = VideoDetailData().obs;
  //最近播放集数
  RxInt lastPlayCid = 0.obs;
  @override
  void onInit() {
    super.onInit();
    //定时器更新在线人数
    queryOnlineTotal();
    startTimer();
    lastPlayCid.value = int.parse(Get.parameters['cid']!);
  }

  //启动计时器
  void startTimer() {
    const duration = Duration(seconds: 30);
    timer = Timer.periodic(duration, (Timer timer) {
      queryOnlineTotal();
    });
  }

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
    var result = await VideoHttp.videoIntro(bvid: bvid);
    if (result['status']) {
      videoDetail.value = result['data'];
    }
    await queryUserInfo();
    queryFollowStatus();
    return result;
  }

  // 查询关注状态
  Future queryFollowStatus() async {
    if (videoDetail.value.owner == null) {
      return;
    }
    var result = await VideoHttp.hasFollow(mid);
    if (result['status']) {
      followStatus.value = result['data'];
    }
    return result;
  }

  //关注、取关up
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
      mid: mid,
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

  //获取up信息
  Future queryUserInfo() async {
    var result = await VideoHttp.userInfo(mid: mid);
    if (result['status']) {
      userInfo.value = result['data'];
    }
  }
}
