import 'package:dilidili/component/common_btn.dart';
import 'package:dilidili/http/static/api_string.dart';
import 'package:dilidili/http/video.dart';
import 'package:dilidili/model/bottom_control_type.dart';
import 'package:dilidili/model/play_status.dart';
import 'package:dilidili/model/video/quality.dart';
import 'package:dilidili/model/video/url.dart';
import 'package:dilidili/pages/dplayer/controller.dart';
import 'package:dilidili/pages/dplayer/models/data_source.dart';
import 'package:dilidili/utils/id_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';

class VideoDetailController extends GetxController
    with GetSingleTickerProviderStateMixin {
  DPlayerController dPlayerController = DPlayerController();
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

    headerControl = AppBar(
      backgroundColor: Colors.transparent,
      foregroundColor: Colors.white,
      elevation: 0,
      scrolledUnderElevation: 0,
      primary: false,
      centerTitle: false,
      automaticallyImplyLeading: false,
      titleSpacing: 14,
      title: Row(
        children: [
          ComBtn(
            icon: const Icon(
              FontAwesomeIcons.arrowLeft,
              size: 15,
              color: Colors.white,
            ),
            fuc: () => Get.back(),
          ),
          const Spacer(),
          ComBtn(
            icon: const Icon(
              Icons.cast,
              size: 19,
              color: Colors.white,
            ),
            fuc: () async {},
          ),
          ComBtn(
            icon: const Icon(
              Icons.closed_caption_off,
              size: 22,
              color: Colors.white,
            ),
            fuc: () {},
          ),
          const SizedBox(width: 8),
          
        ],
      ),
    );
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
    } else {
      SmartDialog.showToast(result['msg'].toString());
    }

    return result;
  }

  Future playerInit() async {
    await dPlayerController.setDataSource(
      DataSource(
        videoSource: videoUrl,
        audioSource: audioUrl,
        type: DataSourceType.network,
        httpHeaders: {
          'user-agent':
              'Mozilla/5.0 (Macintosh; Intel Mac OS X 13_3_1) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/16.4 Safari/605.1.15',
          'referer': ApiString.mainUrl
        },
      ),
    );
    dPlayerController.headerControl = headerControl;
  }

  @override
  void onClose() {
    super.onClose();
    dPlayerController.dispose();
  }
}
