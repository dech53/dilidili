import 'package:dilidili/component/common_btn.dart';
import 'package:dilidili/model/download.dart';
import 'package:dilidili/model/search_type.dart';
import 'package:dilidili/model/video/quality.dart';
import 'package:dilidili/model/video/url.dart';
import 'package:dilidili/pages/download/controller.dart';
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
                                  VideoQualityCode.fromCode(
                                      videoFormat[i].quality!)!;
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

  void showDownloadQualitySheet() {
    final VideoDetailController videoDetailCtr = widget.videoDetailCtr!;
    final PlayUrlModel playUrl = videoDetailCtr.data;
    final List<_DownloadQualityOption> options =
        _buildDownloadQualityOptions(playUrl);

    if (options.isEmpty) {
      SmartDialog.showToast('当前视频暂无可缓存资源');
      return;
    }

    showModalBottomSheet(
      elevation: 0,
      context: context,
      backgroundColor: Colors.transparent,
      builder: (_) {
        return Container(
          width: double.infinity,
          constraints: const BoxConstraints(maxHeight: 430),
          clipBehavior: Clip.hardEdge,
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surface,
            borderRadius: const BorderRadius.all(Radius.circular(12)),
          ),
          margin: const EdgeInsets.all(12),
          child: Column(
            children: [
              const SizedBox(
                height: 45,
                child: Center(
                  child: Text('选择缓存画质', style: titleStyle),
                ),
              ),
              Expanded(
                child: Material(
                  child: ListView.builder(
                    itemCount: options.length,
                    itemBuilder: (context, index) {
                      final _DownloadQualityOption option = options[index];
                      return ListTile(
                        dense: true,
                        leading: const Icon(Icons.download_outlined, size: 20),
                        title: Text(option.qualityDescription),
                        subtitle: Text(
                          option.subtitle,
                          style: subTitleStyle,
                        ),
                        onTap: () {
                          Get.back();
                          addCurrentVideoToDownload(option);
                        },
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
        );
      },
      clipBehavior: Clip.hardEdge,
      isScrollControlled: true,
    );
  }

  List<_DownloadQualityOption> _buildDownloadQualityOptions(
    PlayUrlModel playUrl,
  ) {
    if (playUrl.dash?.video?.isNotEmpty == true) {
      final List<VideoItem> videos = [...playUrl.dash!.video!];
      videos.sort((a, b) => (b.id ?? 0).compareTo(a.id ?? 0));
      final Set<int> qualitySet = <int>{};
      final List<_DownloadQualityOption> options = [];
      for (final VideoItem video in videos) {
        final int? quality = video.id;
        if (quality == null || qualitySet.contains(quality)) {
          continue;
        }
        qualitySet.add(quality);
        final VideoDecodeFormats? decodeFormat = video.codecs == null
            ? null
            : VideoDecodeFormatsCode.fromString(video.codecs!);
        final AudioItem? audio = _pickDefaultAudio(playUrl);
        final int? audioId = audio?.id;
        final AudioQuality? audioQuality =
            audioId == null ? null : AudioQualityCode.fromCode(audioId);
        options.add(
          _DownloadQualityOption(
            sourceType: 'dash',
            qualityCode: quality,
            qualityDescription: _qualityDescription(playUrl, quality),
            videoItem: video,
            audioItem: audio,
            codecDescription: decodeFormat?.description ?? video.codecs,
            audioDescription: audioQuality?.description,
          ),
        );
      }
      return options;
    }

    if (playUrl.durl?.isNotEmpty == true) {
      final int quality = playUrl.quality ?? 0;
      return [
        _DownloadQualityOption(
          sourceType: 'durl',
          qualityCode: quality,
          qualityDescription: _qualityDescription(playUrl, quality),
        ),
      ];
    }

    return [];
  }

  void addCurrentVideoToDownload(_DownloadQualityOption option) {
    final VideoDetailController videoDetailCtr = widget.videoDetailCtr!;
    final PlayUrlModel playUrl = videoDetailCtr.data;
    final VideoItem? videoItem = option.videoItem;
    final AudioItem? audioItem = option.audioItem;
    final int qualityCode = option.qualityCode;
    final VideoQuality? videoQuality = VideoQualityCode.fromCode(qualityCode);
    final String? codec = videoItem?.codecs;
    final VideoDecodeFormats? decodeFormat =
        codec == null ? null : VideoDecodeFormatsCode.fromString(codec);
    final int? audioQualityCode = audioItem?.id;
    final AudioQuality? audioQuality = audioQualityCode == null
        ? null
        : AudioQualityCode.fromCode(audioQualityCode);
    final videoDetail = videoIntroController.videoDetail.value;
    final part = _findCurrentPart(videoDetailCtr.cid.value);

    final DownloadTask task = DownloadTask(
      id: _buildDownloadId(
        bvid: videoDetailCtr.bvid,
        cid: videoDetailCtr.cid.value,
        sourceType: option.sourceType,
        quality: qualityCode,
        codec: decodeFormat?.code ?? codec,
        audioQuality: audioQualityCode,
      ),
      bvid: videoDetailCtr.bvid,
      cid: videoDetailCtr.cid.value,
      aid: videoDetail.aid ?? videoDetailCtr.oid.value,
      title: videoDetail.title,
      cover: videoDetail.pic ?? videoDetailCtr.cover.value,
      partTitle: part?.pagePart,
      quality: qualityCode,
      qualityDescription:
          videoQuality?.description ?? option.qualityDescription,
      videoCodec: decodeFormat?.code ?? codec,
      videoCodecDescription: decodeFormat?.description ?? codec,
      audioQuality: audioQualityCode,
      audioQualityDescription: audioQuality?.description,
      sourceType: option.sourceType,
      duration: playUrl.timeLength,
      videoType: widget.videoType?.type,
      createdAt: DateTime.now(),
    );

    final bool added = DownloadController.to.addTask(task);
    SmartDialog.showToast(added ? '已添加到离线缓存' : '该清晰度已在缓存列表中');
  }

  AudioItem? _pickDefaultAudio(PlayUrlModel playUrl) {
    final List<AudioItem> audios = [...?playUrl.dash?.audio];
    if (audios.isEmpty) {
      return null;
    }
    return audios.first;
  }

  String _qualityDescription(PlayUrlModel playUrl, int qualityCode) {
    final FormatItem? formatItem = _findFormatItem(playUrl, qualityCode);
    final VideoQuality? videoQuality = VideoQualityCode.fromCode(qualityCode);
    return formatItem?.newDesc ??
        formatItem?.displayDesc ??
        videoQuality?.description ??
        '画质 $qualityCode';
  }

  FormatItem? _findFormatItem(PlayUrlModel playUrl, int qualityCode) {
    final List<FormatItem> formats = [...?playUrl.supportFormats];
    for (final FormatItem item in formats) {
      if (item.quality == qualityCode) {
        return item;
      }
    }
    return null;
  }

  dynamic _findCurrentPart(int cid) {
    final pages = videoIntroController.videoDetail.value.pages;
    if (pages == null) {
      return null;
    }
    for (final item in pages) {
      if (item.cid == cid) {
        return item;
      }
    }
    return null;
  }

  String _buildDownloadId({
    required String bvid,
    required int cid,
    required String sourceType,
    required int quality,
    String? codec,
    int? audioQuality,
  }) {
    return [
      bvid,
      cid,
      sourceType,
      quality,
      codec ?? 'default',
      audioQuality ?? 'noaudio',
    ].join('_');
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
                      onTap: () {
                        Get.back();
                        Future.delayed(const Duration(milliseconds: 160), () {
                          if (mounted) {
                            showDownloadQualitySheet();
                          }
                        });
                      },
                      dense: true,
                      leading: const Icon(Icons.download_outlined, size: 20),
                      title: const Text('缓存视频', style: titleStyle),
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

class _DownloadQualityOption {
  const _DownloadQualityOption({
    required this.sourceType,
    required this.qualityCode,
    required this.qualityDescription,
    this.videoItem,
    this.audioItem,
    this.codecDescription,
    this.audioDescription,
  });

  final String sourceType;
  final int qualityCode;
  final String qualityDescription;
  final VideoItem? videoItem;
  final AudioItem? audioItem;
  final String? codecDescription;
  final String? audioDescription;

  String get subtitle {
    final List<String> parts = [
      sourceType == 'dash' ? 'DASH' : '单文件',
      if (codecDescription != null && codecDescription!.isNotEmpty)
        codecDescription!,
      if (audioDescription != null && audioDescription!.isNotEmpty)
        audioDescription!,
    ];
    return parts.join(' · ');
  }
}
