import 'package:dilidili/component/common_btn.dart';
import 'package:dilidili/http/static/api_string.dart';
import 'package:dilidili/http/video.dart';
import 'package:dilidili/model/bottom_control_type.dart';
import 'package:dilidili/model/search_type.dart';
import 'package:dilidili/model/video/quality.dart';
import 'package:dilidili/model/video/url.dart';
import 'package:dilidili/pages/dplayer/controller.dart';
import 'package:dilidili/pages/dplayer/models/data_source.dart';
import 'package:dilidili/pages/video/detail/widgets/header_control.dart';
import 'package:dilidili/utils/id_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:get/get.dart';

class VideoDetailController extends GetxController
    with GetSingleTickerProviderStateMixin {
  DPlayerController dPlayerController = DPlayerController();
  // 路由传参
  String bvid = Get.arguments['bvid']!;
  late VideoQuality currentVideoQa;
  RxString archiveSourceType = 'dash'.obs;
  RxBool enableHA = false.obs;
  RxBool isShowCover = true.obs;
  RxDouble sheetHeight = 0.0.obs;
  ScrollController? replyScrollController;
  late VideoItem firstVideo;
  late AudioItem firstAudio;
  late Duration defaultST;
  late PreferredSizeWidget headerControl;
  RxList<BottomControlType> bottomList = [
    BottomControlType.playOrPause,
    BottomControlType.time,
    BottomControlType.space,
    BottomControlType.fullscreen,
  ].obs;
  RxInt cid = int.parse(Get.arguments['cid']!).obs;
  RxInt danmakuCid = 0.obs;
  RxInt oid = 0.obs;
  late PlayUrlModel data;
  late TabController tabCtr;
  RxList<String> tabs = <String>['简介', '评论'].obs;
  late String videoUrl;
  late String audioUrl;
  // 视频类型 默认投稿视频
  SearchType videoType = Get.arguments['videoType'] ?? SearchType.video;
  @override
  void onInit() {
    super.onInit();
    tabCtr = TabController(length: 2, vsync: this);
    danmakuCid.value = cid.value;
    oid.value = IdUtils.bv2av(Get.arguments['bvid']!);

    headerControl = HeaderControl(
      controller: dPlayerController,
      videoDetailCtr: this,
      bvid: bvid,
      videoType: videoType,
    );
  }

  void onControllerCreated(ScrollController controller) {
    replyScrollController = controller;
  }

// 视频链接
  Future queryVideoUrl() async {
    var result = await VideoHttp.videoUrl(cid: cid.value, bvid: bvid);
    if (result['status']) {
      data = result['data'];
      if (data.acceptDesc!.isNotEmpty && data.acceptDesc!.contains('试看')) {
        SmartDialog.showToast(
          '该视频为专属视频，仅提供试看',
          displayTime: const Duration(seconds: 3),
        );
        videoUrl = data.durl!.first.url!;
        audioUrl = '';
        defaultST = Duration.zero;
        firstVideo = VideoItem();
        await playerInit();
        isShowCover.value = false;
        return result;
      }
      if (data.durl != null) {
        archiveSourceType.value = 'durl';
        videoUrl = data.durl!.first.url!;
        audioUrl = '';
        defaultST = Duration.zero;
        firstVideo = VideoItem();
        currentVideoQa = VideoQualityCode.fromCode(data.quality!)!;
        await playerInit();
        isShowCover.value = false;
        return result;
      }
      final List<VideoItem> allVideosList = data.dash!.video!;
      int currentHighVideoQa = allVideosList.first.quality!.code;
      final List<VideoItem> videosList = allVideosList
          .where((e) => e.quality!.code == currentHighVideoQa)
          .toList();
      firstVideo = videosList.first;
      videoUrl = firstVideo.baseUrl!;
      final List<AudioItem> audiosList = data.dash!.audio!;
      firstAudio = audiosList.first;
      audioUrl = firstAudio.baseUrl!;
      await playerInit();
      isShowCover.value = false;
    } else {
      if (result['code'] == -404) {
        isShowCover.value = false;
      }
      SmartDialog.showToast(result['msg'].toString());
    }
    return result;
  }

  Future playerInit({
    video,
    audio,
    duration,
  }) async {
    await dPlayerController.setDataSource(
      DataSource(
        videoSource: video ?? videoUrl,
        audioSource: audio ?? audioUrl,
        type: DataSourceType.network,
        httpHeaders: {
          'user-agent':
              'Mozilla/5.0 (Macintosh; Intel Mac OS X 13_3_1) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/16.4 Safari/605.1.15',
          'referer': ApiString.mainUrl
        },
      ),
      duration: duration ?? Duration(milliseconds: data.timeLength ?? 0),
    );
    dPlayerController.headerControl = headerControl;
  }

  @override
  void onClose() {
    super.onClose();
    dPlayerController.dispose();
    // print("控制器内部实例数量${dPlayerController!.playerCount.value.toString()}");
  }
}
