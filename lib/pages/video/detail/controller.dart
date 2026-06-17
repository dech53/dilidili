import 'package:dilidili/common/reply_type.dart';
import 'package:dilidili/http/danmaku.dart';
import 'package:dilidili/http/static/api_string.dart';
import 'package:dilidili/http/video.dart';
import 'package:dilidili/model/bottom_control_type.dart';
import 'package:dilidili/model/reply/item.dart';
import 'package:dilidili/model/search_type.dart';
import 'package:dilidili/model/video/quality.dart';
import 'package:dilidili/model/video/url.dart';
import 'package:dilidili/pages/dplayer/controller.dart';
import 'package:dilidili/pages/dplayer/models/data_source.dart';
import 'package:dilidili/pages/dplayer/services/ios_now_playing.dart';
import 'package:dilidili/pages/video/detail/widgets/header_control.dart';
import 'package:dilidili/pages/video/reply_reply/view.dart';
import 'package:dilidili/utils/id_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:get/get.dart';
import 'package:ns_danmaku/ns_danmaku.dart';

class VideoDetailController extends GetxController
    with GetSingleTickerProviderStateMixin {
  // 评论id 请求楼中楼评论使用
  int fRpid = 0;
  ReplyItemModel? firstFloor;
  PersistentBottomSheetController? replyReplyBottomSheetCtr;
  final scaffoldKey = GlobalKey<ScaffoldState>();
  DPlayerController dPlayerController = DPlayerController();
  // 路由传参
  String bvid = Get.arguments['bvid']!;
  late VideoQuality currentVideoQa;
  RxString archiveSourceType = 'dash'.obs;
  AudioQuality? currentAudioQa;
  VideoDecodeFormats? currentDecodeFormats;
  RxBool enableHA = false.obs;
  RxBool isShowCover = true.obs;
  RxString cover = ''.obs;
  String _nowPlayingTitle = '';
  String? _nowPlayingArtist;
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
  // 视频详情
  Map videoItem = {};
  RxInt cid = int.parse(Get.arguments['cid']!).obs;
  RxInt danmakuCid = 0.obs;
  RxInt oid = 0.obs;
  late PlayUrlModel data;
  late TabController tabCtr;
  RxInt selectedTabIndex = 0.obs;
  RxList<String> tabs = <String>['简介', '评论'].obs;
  late String videoUrl;
  late String audioUrl;
  // 视频类型 默认投稿视频
  SearchType videoType = Get.arguments['videoType'] ?? SearchType.video;
  @override
  void onInit() {
    super.onInit();
    final Map argMap = Get.arguments;
    if (argMap.containsKey('videoItem')) {
      var args = argMap['videoItem'];
      updateCover(args.pic);
    } else if (argMap.containsKey('pic')) {
      updateCover(argMap['pic']);
    }
    tabCtr = TabController(length: 2, vsync: this);
    tabCtr.animation?.addListener(() {
      final int index = tabCtr.indexIsChanging
          ? tabCtr.index
          : tabCtr.animation!.value.round().clamp(0, tabCtr.length - 1);
      if (selectedTabIndex.value != index) {
        selectedTabIndex.value = index;
      }
    });
    danmakuCid.value = cid.value;
    oid.value = IdUtils.bv2av(Get.arguments['bvid']!);
    headerControl = HeaderControl(
      controller: dPlayerController,
      videoDetailCtr: this,
      bvid: bvid,
      videoType: videoType,
    );
  }

  void updateCover(String? pic) {
    if (pic != null) {
      cover.value = videoItem['pic'] = pic;
    }
  }

  void updateNowPlayingMetadata({
    String? title,
    String? artist,
    String? coverUrl,
  }) {
    if (title != null && title.isNotEmpty) {
      _nowPlayingTitle = title;
    }
    if (artist != null && artist.isNotEmpty) {
      _nowPlayingArtist = artist;
    }
    if (coverUrl != null && coverUrl.isNotEmpty) {
      updateCover(coverUrl);
    }

    dPlayerController.setNowPlayingMetadata(
      IosNowPlayingMetadata(
        id: '$bvid:${cid.value}',
        title: _nowPlayingTitle.isNotEmpty ? _nowPlayingTitle : bvid,
        artist: _nowPlayingArtist,
        artworkUrl: cover.value.isNotEmpty ? cover.value : null,
        duration: _nowPlayingDuration,
        position: dPlayerController.position.value,
        status: dPlayerController.playerStatus.status.value,
        playbackRate: dPlayerController.playbackSpeed,
      ),
    );
  }

  Duration get _nowPlayingDuration {
    try {
      return Duration(milliseconds: data.timeLength ?? 0);
    } catch (_) {
      return dPlayerController.duration.value;
    }
  }

  showReplyReplyPanel(oid, fRpid, firstFloor, currentReply, loadMore) {
    replyReplyBottomSheetCtr =
        scaffoldKey.currentState?.showBottomSheet((BuildContext context) {
      return VideoReplyReplyPanel(
        oid: oid,
        rpid: fRpid,
        closePanel: () => {
          fRpid = 0,
        },
        firstFloor: firstFloor,
        replyType: ReplyType.video,
        source: 'videoDetail',
        sheetHeight: sheetHeight.value,
        currentReply: currentReply,
        loadMore: loadMore,
      );
    });
    replyReplyBottomSheetCtr?.closed.then((value) {
      fRpid = 0;
    });
  }

  updatePlayer() {
    defaultST = dPlayerController.position.value;
    dPlayerController.removeListeners();
    dPlayerController.isBuffering.value = false;
    dPlayerController.buffered.value = Duration.zero;

    /// 根据currentVideoQa和currentDecodeFormats 重新设置videoUrl
    List<VideoItem> videoList =
        data.dash!.video!.where((i) => i.id == currentVideoQa.code).toList();
    try {
      firstVideo = videoList
          .firstWhere((i) => i.codecs!.startsWith(currentDecodeFormats?.code));
    } catch (_) {
      if (currentVideoQa == VideoQuality.dolbyVision) {
        firstVideo = videoList.first;
        currentDecodeFormats =
            VideoDecodeFormatsCode.fromString(videoList.first.codecs!)!;
      } else {
        // 当前格式不可用
        currentDecodeFormats = VideoDecodeFormatsCode.fromString(
            VideoDecodeFormats.values.last.code)!;
        firstVideo = videoList.firstWhere(
            (i) => i.codecs!.startsWith(currentDecodeFormats?.code));
      }
    }
    videoUrl = firstVideo.baseUrl!;

    /// 根据currentAudioQa 重新设置audioUrl
    if (currentAudioQa != null) {
      final AudioItem firstAudio = data.dash!.audio!.firstWhere(
        (AudioItem i) => i.id == currentAudioQa!.code,
        orElse: () => data.dash!.audio!.first,
      );
      audioUrl = firstAudio.baseUrl ?? '';
    }
    playerInit();
  }

  void onControllerCreated(ScrollController controller) {
    replyScrollController = controller;
  }

  void onTapTabbar(int index) {
    if (selectedTabIndex.value == index && index == 1) {
      replyScrollController?.animateTo(0,
          duration: const Duration(milliseconds: 300), curve: Curves.ease);
      return;
    }
    selectedTabIndex.value = index;
    if (tabCtr.index != index) {
      tabCtr.animateTo(index);
    }
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
      currentVideoQa = VideoQualityCode.fromCode(currentHighVideoQa)!;
      final List<VideoItem> videosList = allVideosList
          .where((e) => e.quality!.code == currentHighVideoQa)
          .toList();
      currentDecodeFormats = VideoDecodeFormatsCode.fromString(
          VideoDecodeFormats.values.last.code);
      firstVideo = videosList.first;
      videoUrl = firstVideo.baseUrl!;
      final List<AudioItem> audiosList = data.dash!.audio!;
      firstAudio = audiosList.first;
      audioUrl = firstAudio.baseUrl!;
      if (firstAudio.id != null) {
        currentAudioQa = AudioQualityCode.fromCode(firstAudio.id!)!;
      }
      defaultST = Duration(milliseconds: data.lastPlayTime!);
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
    seekToTime,
    duration,
    bool autoPlay = true,
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
      seekTo: seekToTime ?? defaultST,
      duration: duration ?? Duration(milliseconds: data.timeLength ?? 0),
      bvid: bvid,
      cid: cid.value,
      autoPlay: autoPlay,
    );
    dPlayerController.headerControl = headerControl;
    updateNowPlayingMetadata();
  }

  /// 发送弹幕
  void showShootDanmakuSheet() {
    final TextEditingController textController = TextEditingController();
    bool isSending = false;
    showDialog(
        context: Get.context!,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('发送弹幕'),
            content: StatefulBuilder(
                builder: (BuildContext context, StateSetter setState) {
              return TextField(
                controller: textController,
              );
            }),
            actions: [
              TextButton(
                onPressed: () => Get.back(),
                child: Text(
                  '取消',
                  style:
                      TextStyle(color: Theme.of(context).colorScheme.outline),
                ),
              ),
              StatefulBuilder(
                  builder: (BuildContext context, StateSetter setState) {
                return TextButton(
                  onPressed: isSending
                      ? null
                      : () async {
                          final String msg = textController.text;
                          if (msg.isEmpty) {
                            SmartDialog.showToast('弹幕内容不能为空');
                            return;
                          } else if (msg.length > 100) {
                            SmartDialog.showToast('弹幕内容不能超过100个字符');
                            return;
                          }
                          setState(() {
                            isSending = true; // 开始发送，更新状态
                          });
                          //修改按钮文字
                          // SmartDialog.showToast('弹幕发送中,\n$msg');
                          final dynamic res = await DanmakaHttp.shootDanmaku(
                            oid: cid.value,
                            msg: textController.text,
                            bvid: bvid,
                            progress:
                                dPlayerController.position.value.inMilliseconds,
                            type: 1,
                          );
                          setState(() {
                            isSending = false; // 发送结束，更新状态
                          });
                          if (res['status']) {
                            SmartDialog.showToast('发送成功');
                            // 发送成功，自动预览该弹幕，避免重新请求
                            // TODO: 暂停状态下预览弹幕仍会移动与计时，可考虑添加到dmSegList或其他方式实现
                            dPlayerController.danmakuController?.addItems([
                              DanmakuItem(
                                msg,
                                color: Colors.white,
                                time: dPlayerController
                                    .position.value.inMilliseconds,
                                type: DanmakuItemType.scroll,
                                isSend: true,
                              )
                            ]);
                            Get.back();
                          } else {
                            SmartDialog.showToast('发送失败，错误信息为${res['msg']}');
                          }
                        },
                  child: Text(isSending ? '发送中...' : '发送'),
                );
              })
            ],
          );
        });
  }

  @override
  void onClose() {
    tabCtr.dispose();
    super.onClose();
    dPlayerController.dispose();
  }
}
