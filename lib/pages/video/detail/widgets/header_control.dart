import 'package:dilidili/component/common_btn.dart';
import 'package:dilidili/model/search_type.dart';
import 'package:dilidili/model/video/quality.dart';
import 'package:dilidili/model/video/url.dart';
import 'package:dilidili/pages/dplayer/controller.dart';
import 'package:dilidili/pages/video/detail/controller.dart';
import 'package:dilidili/pages/video/introduction/controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';

class HeaderControl extends StatefulWidget implements PreferredSizeWidget {
  const HeaderControl({
    this.controller,
    this.videoDetailCtr,
    this.bvid,
    this.videoType,
    this.showSubtitleBtn,
    super.key,
  });
  final DPlayerController? controller;
  final VideoDetailController? videoDetailCtr;
  final String? bvid;
  final SearchType? videoType;
  final bool? showSubtitleBtn;

  @override
  State<HeaderControl> createState() => _HeaderControlState();

  @override
  Size get preferredSize => throw UnimplementedError();
}

class _HeaderControlState extends State<HeaderControl> {
  late PlayUrlModel videoInfo;
  late String heroTag;
  static const TextStyle titleStyle = TextStyle(fontSize: 14);
  static const TextStyle subTitleStyle = TextStyle(fontSize: 12);
  late VideoIntroController videoIntroController;
  RxBool isFullScreen = false.obs;
  @override
  void initState() {
    super.initState();
    videoInfo = widget.videoDetailCtr!.data;
    fullScreenStatusListener();
    heroTag = Get.arguments['heroTag'];
    videoIntroController =
        Get.put(VideoIntroController(bvid: widget.bvid!), tag: heroTag);
  }

  /// 选择画质
  void showSetVideoQa() {
    final List<FormatItem> videoFormat = videoInfo.supportFormats!;
    final VideoQuality currentVideoQa = widget.videoDetailCtr!.currentVideoQa;
    //总质量分类
    final int totalQaSam = videoFormat.length;

    /// 可用的质量分类
    int userfulQaSam = 0;
    if (videoInfo.dash != null) {
      // dash格式视频一次请求会返回所有可播放的清晰度video
      final List<VideoItem> video = videoInfo.dash!.video!;
      final Set<int> idSet = {};
      for (final VideoItem item in video) {
        final int id = item.id!;
        if (!idSet.contains(id)) {
          idSet.add(id);
          userfulQaSam++;
        }
      }
    }
    showModalBottomSheet(
      context: context,
      elevation: 0,
      backgroundColor: Colors.transparent,
      builder: (BuildContext context) {
        return Container(
          width: double.infinity,
          height: 310,
          clipBehavior: Clip.hardEdge,
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surface,
            borderRadius: const BorderRadius.all(Radius.circular(12)),
          ),
          margin: const EdgeInsets.all(12),
          child: Column(
            children: <Widget>[
              SizedBox(
                height: 45,
                child: GestureDetector(
                  onTap: () {
                    SmartDialog.showToast('标灰画质可能需要bilibili会员');
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text('选择画质', style: titleStyle),
                      const SizedBox(width: 8),
                      Icon(
                        Icons.info_outline,
                        size: 16,
                        color: Theme.of(context).colorScheme.outline,
                      )
                    ],
                  ),
                ),
              ),
              Expanded(
                child: Material(
                  child: Scrollbar(
                    child: ListView(
                      children: [
                        for (int i = 0; i < totalQaSam; i++) ...[
                          ListTile(
                            onTap: () {
                              if (currentVideoQa.code ==
                                  videoFormat[i].quality) {
                                return;
                              }
                              widget.videoDetailCtr!.currentVideoQa =
                                  VideoQualityCode.fromCode(videoFormat[i].quality!)!;
                              widget.videoDetailCtr!.updatePlayer();
                              Get.back();
                            },
                            dense: true,
                            // 可能包含会员解锁画质
                            enabled: i >= totalQaSam - userfulQaSam,
                            contentPadding:
                                const EdgeInsets.only(left: 20, right: 20),
                            title: Text(videoFormat[i].newDesc!),
                            subtitle: Text(
                              videoFormat[i].format!,
                              style: subTitleStyle,
                            ),
                            trailing: currentVideoQa.code ==
                                    videoFormat[i].quality
                                ? Icon(
                                    Icons.done,
                                    color:
                                        Theme.of(context).colorScheme.primary,
                                  )
                                : const SizedBox(),
                          ),
                        ]
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  /// 设置面板
  void showSettingSheet() {
    showModalBottomSheet(
      elevation: 0,
      context: context,
      backgroundColor: Colors.transparent,
      builder: (_) {
        return Container(
          width: double.infinity,
          height: 460,
          clipBehavior: Clip.hardEdge,
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surface,
            borderRadius: const BorderRadius.all(Radius.circular(12)),
          ),
          margin: const EdgeInsets.all(12),
          child: Column(
            children: <Widget>[
              SizedBox(
                height: 35,
                child: Center(
                  child: Container(
                    width: 32,
                    height: 3,
                    decoration: BoxDecoration(
                        color: Theme.of(context)
                            .colorScheme
                            .onSecondaryContainer
                            .withOpacity(0.5),
                        borderRadius:
                            const BorderRadius.all(Radius.circular(3))),
                  ),
                ),
              ),
              Expanded(
                  child: Material(
                child: ListView(
                  children: [
                    ListTile(
                      onTap: () async {
                        // final res = await UserHttp.toViewLater(
                        //     bvid: widget.videoDetailCtr!.bvid);
                        // SmartDialog.showToast(res['msg']);
                        Get.back();
                      },
                      dense: true,
                      leading: const Icon(Icons.watch_later_outlined, size: 20),
                      title: const Text('添加至「稍后再看」', style: titleStyle),
                    ),
                    ListTile(
                      onTap: () => {Get.back()},
                      dense: true,
                      leading:
                          const Icon(Icons.hourglass_top_outlined, size: 20),
                      title: const Text('定时关闭', style: titleStyle),
                    ),
                    ListTile(
                      onTap: () => {Get.back(), showSetVideoQa()},
                      dense: true,
                      leading: const Icon(Icons.play_circle_outline, size: 20),
                      title: const Text('选择画质', style: titleStyle),
                      subtitle: Text(
                          '当前画质 ${widget.videoDetailCtr!.currentVideoQa.description}',
                          style: subTitleStyle),
                    ),
                    if (widget.videoDetailCtr!.currentAudioQa != null)
                      ListTile(
                        onTap: () => {Get.back()},
                        dense: true,
                        leading: const Icon(Icons.album_outlined, size: 20),
                        title: const Text('选择音质', style: titleStyle),
                        subtitle: Text(
                            '当前音质 ${widget.videoDetailCtr!.currentAudioQa!.description}',
                            style: subTitleStyle),
                      ),
                    if (widget.videoDetailCtr!.currentDecodeFormats != null)
                      ListTile(
                        onTap: () => {Get.back()},
                        dense: true,
                        leading: const Icon(Icons.av_timer_outlined, size: 20),
                        title: const Text('解码格式', style: titleStyle),
                        subtitle: Text(
                            '当前解码格式 ${widget.videoDetailCtr!.currentDecodeFormats!.description}',
                            style: subTitleStyle),
                      ),
                    ListTile(
                      onTap: () => {Get.back()},
                      dense: true,
                      leading: const Icon(Icons.subtitles_outlined, size: 20),
                      title: const Text('弹幕设置', style: titleStyle),
                    ),
                  ],
                ),
              ))
            ],
          ),
        );
      },
      clipBehavior: Clip.hardEdge,
      isScrollControlled: true,
    );
  }

  void fullScreenStatusListener() {
    widget.videoDetailCtr!.dPlayerController.isFullScreen.listen((bool val) {
      isFullScreen.value = val;
      if (mounted) {
        setState(() {});
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final _ = widget.controller!;
    const TextStyle textStyle = TextStyle(
      color: Colors.white,
      fontSize: 12,
    );
    final bool isLandscape =
        MediaQuery.of(context).orientation == Orientation.landscape;
    return AppBar(
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
            fuc: () => <Set<void>>{
              if (widget.controller!.isFullScreen.value)
                <void>{widget.controller!.triggerFullScreen(status: false)}
              else
                <void>{
                  if (MediaQuery.of(context).orientation ==
                      Orientation.landscape)
                    {
                      SystemChrome.setPreferredOrientations([
                        DeviceOrientation.portraitUp,
                      ])
                    },
                  Get.back()
                }
            },
          ),
          const Spacer(),
          if (isFullScreen.value) ...[
            SizedBox(
              width: 34,
              height: 34,
              child: Obx(
                () => IconButton(
                  style: ButtonStyle(
                    padding: MaterialStateProperty.all(EdgeInsets.zero),
                  ),
                  onPressed: () {
                    _.isOpenDanmu.value = !_.isOpenDanmu.value;
                  },
                  icon: Icon(
                    _.isOpenDanmu.value
                        ? Icons.subtitles_outlined
                        : Icons.subtitles_off_outlined,
                    size: 19,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
          const SizedBox(width: 8),
          ComBtn(
            icon: const Icon(
              Icons.more_vert_outlined,
              size: 18,
              color: Colors.white,
            ),
            fuc: () => showSettingSheet(),
          ),
        ],
      ),
    );
  }
}
