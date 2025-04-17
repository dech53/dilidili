import 'package:dilidili/http/video.dart';
import 'package:dilidili/model/bottom_control_type.dart';
import 'package:dilidili/model/play_status.dart';
import 'package:dilidili/model/video/quality.dart';
import 'package:dilidili/model/video/url.dart';
import 'package:dilidili/utils/id_utils.dart';
import 'package:dilidili/utils/log_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:get/get.dart';

class VideoDetailController extends GetxController
    with GetSingleTickerProviderStateMixin {
  // 路由传参
  String bvid = Get.parameters['bvid']!;
  late VideoQuality currentVideoQa;
  RxString archiveSourceType = 'dash'.obs;
  RxBool enableHA = false.obs;
  late VideoItem firstVideo;
  late AudioItem firstAudio;
  late Duration defaultST;
  late PreferredSizeWidget headerControl;
  RxList<BottomControlType> bottomList = [
    BottomControlType.playOrPause,
    BottomControlType.time,
    BottomControlType.space,
    BottomControlType.fit,
    BottomControlType.fullscreen,
  ].obs;
  RxInt cid = int.parse(Get.parameters['cid']!).obs;
  Rx<PlayerStatus> playerStatus = PlayerStatus.playing.obs;
  RxInt danmakuCid = 0.obs;
  RxInt oid = 0.obs;
  late PlayUrlModel data;
  late TabController tabCtr;
  RxList<String> tabs = <String>['简介', '评论'].obs;
  late String videoUrl;
  late String audioUrl;
  @override
  void onInit() {
    super.onInit();
    tabCtr = TabController(length: 2, vsync: this);
    danmakuCid.value = cid.value;
    oid.value = IdUtils.bv2av(Get.parameters['bvid']!);
  }

// 视频链接
  Future queryVideoUrl() async {
    var result = await VideoHttp.videoUrl(cid: cid.value, bvid: bvid);
    if (result['status']) {
      data = result['data'];
      Logutils.println(data.dash!.video!.first.baseUrl!);
      Logutils.println(data.dash!.audio!.first.baseUrl!);
    } else {
      SmartDialog.showToast(result['msg'].toString());
    }
    return result;
  }
}
