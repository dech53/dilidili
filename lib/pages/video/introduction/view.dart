import 'package:dilidili/common/skeleton/video_info_skeleton.dart';
import 'package:dilidili/common/widgets/action_item.dart';
import 'package:dilidili/common/widgets/badge.dart';
import 'package:dilidili/common/widgets/http_error.dart';
import 'package:dilidili/common/widgets/network_img_layer.dart';
import 'package:dilidili/common/widgets/page_panel.dart';
import 'package:dilidili/model/nav_user_info.dart';
import 'package:dilidili/model/video/video_basic_info.dart';
import 'package:dilidili/model/video/video_tag.dart';
import 'package:dilidili/pages/video/detail/controller.dart';
import 'package:dilidili/pages/video/introduction/controller.dart';
import 'package:dilidili/pages/video/introduction/widgets/intro_detail.dart';
import 'package:dilidili/pages/video/introduction/widgets/season_panel.dart';
import 'package:dilidili/utils/num_utils.dart';
import 'package:expandable/expandable.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class VideoIntroPanel extends StatefulWidget {
  final String bvid;
  final String? cid;

  const VideoIntroPanel({super.key, required this.bvid, this.cid});

  @override
  State<VideoIntroPanel> createState() => _VideoIntroPanelState();
}

class _VideoIntroPanelState extends State<VideoIntroPanel>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  late VideoIntroController videoIntroController;
  late String heroTag;
  late Future? _futureBuilderFuture;
  VideoDetailData? videoDetail;

  @override
  void dispose() {
    super.dispose();
    videoIntroController.onClose();
  }

  @override
  void initState() {
    super.initState();
    heroTag = Get.arguments['heroTag'];
    videoIntroController =
        Get.put(VideoIntroController(bvid: widget.bvid), tag: heroTag);
    _futureBuilderFuture = videoIntroController.queryVideoIntro();
    videoIntroController.videoDetail.listen((value) {
      videoDetail = value;
      if (videoDetail!.pages != null && videoDetail!.pages!.length > 1) {
        print('视频分集信息${videoDetail!.pages!.map((e) => e.cid)}');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return FutureBuilder(
      future: _futureBuilderFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          if (snapshot.data == null) {
            return const SliverToBoxAdapter(child: SizedBox());
          }
          if (snapshot.data['status']) {
            // 请求成功
            return Obx(
              () => VideoInfo(
                bvid: widget.bvid,
                videoDetail: videoIntroController.videoDetail.value,
                videoTags: videoIntroController.videoTags.value,
                userInfo: videoIntroController.userInfo.value,
                heroTag: heroTag,
              ),
            );
          } else {
            // 请求错误
            return HttpError(
              errMsg: snapshot.data['msg'],
              btnText: snapshot.data['code'] == -404 ||
                      snapshot.data['code'] == 62002
                  ? '返回上一页'
                  : null,
              fn: () => Get.back(),
            );
          }
        } else {
          return VideoInfoSkeleton();
        }
      },
    );
  }
}

class VideoInfo extends StatefulWidget {
  final VideoDetailData? videoDetail;
  final List<VideoTag>? videoTags;
  final String bvid;
  final String? heroTag;
  final UserCardInfo? userInfo;
  const VideoInfo({
    Key? key,
    this.videoDetail,
    this.heroTag,
    this.videoTags,
    required this.bvid,
    this.userInfo,
  }) : super(key: key);

  @override
  State<VideoInfo> createState() => _VideoInfoState();
}

class _VideoInfoState extends State<VideoInfo> with TickerProviderStateMixin {
  RxBool isExpanded = false.obs;
  late String heroTag;
  late final VideoDetailController videoDetailCtr;
  late final VideoIntroController videoIntroController;
  late ExpandableController _expandableController;
  @override
  void initState() {
    super.initState();
    heroTag = widget.heroTag!;
    videoIntroController =
        Get.put(VideoIntroController(bvid: widget.bvid), tag: heroTag);
    videoDetailCtr = Get.find<VideoDetailController>(tag: heroTag);
    _expandableController = ExpandableController(initialExpanded: false);
  }

  @override
  void dispose() {
    _expandableController.dispose();
    super.dispose();
  }

  showIntroDetail() {
    isExpanded.value = !(isExpanded.value);
    _expandableController.toggle();
  }

  @override
  Widget build(BuildContext context) {
    return SliverPadding(
      padding: const EdgeInsets.only(
        left: 10,
        right: 10,
        top: 4,
      ),
      sliver: SliverToBoxAdapter(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 4),
              child: GestureDetector(
                onTap: () {
                  Get.toNamed(
                    '/member?mid=${widget.videoDetail!.owner!.mid}',
                    arguments: {
                      'face': widget.videoDetail!.owner!.face,
                      'heroTag': widget.heroTag,
                    },
                  );
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        NetworkImgLayer(
                          type: 'avatar',
                          src: widget.videoDetail!.owner!.face,
                          width: 38,
                          height: 38,
                        ),
                        10.horizontalSpace,
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              widget.videoDetail!.owner!.name,
                              style: TextStyle(
                                fontSize: 12.sp,
                              ),
                            ),
                            2.verticalSpace,
                            Row(
                              children: [
                                Text(
                                  "${NumUtils.int2Num(widget.userInfo!.follower!)}粉丝",
                                  style: TextStyle(
                                    fontSize: 8.sp,
                                    color:
                                        Theme.of(context).colorScheme.outline,
                                  ),
                                ),
                                5.horizontalSpace,
                                Text(
                                  "${NumUtils.int2Num(widget.userInfo!.archiveCount!)}视频",
                                  style: TextStyle(
                                    fontSize: 8.sp,
                                    color:
                                        Theme.of(context).colorScheme.outline,
                                  ),
                                ),
                              ],
                            )
                          ],
                        )
                      ],
                    ),
                    Obx(
                      () {
                        final bool isFollowed =
                            videoIntroController.followStatus['attribute'] != 0;
                        return SizedBox(
                          height: 32,
                          child: TextButton(
                            onPressed: videoIntroController.actionRelationMod,
                            style: TextButton.styleFrom(
                              padding: const EdgeInsets.only(
                                left: 8,
                                right: 8,
                              ),
                              foregroundColor: isFollowed
                                  ? Theme.of(context).colorScheme.outline
                                  : Theme.of(context).colorScheme.onPrimary,
                              backgroundColor: isFollowed
                                  ? Theme.of(context)
                                      .colorScheme
                                      .onInverseSurface
                                  : Theme.of(context).colorScheme.primary,
                            ),
                            child: Text(
                              isFollowed ? '已关注' : '关注',
                              style: TextStyle(
                                fontSize: Theme.of(context)
                                    .textTheme
                                    .labelMedium!
                                    .fontSize,
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
            //标题
            GestureDetector(
              behavior: HitTestBehavior.translucent,
              onTap: () => showIntroDetail(),
              onLongPress: () async {
                await Clipboard.setData(
                    ClipboardData(text: widget.videoDetail!.title!));
                SmartDialog.showToast('标题已复制');
              },
              child: ExpandablePanel(
                controller: _expandableController,
                collapsed: RichText(
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  text: TextSpan(
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Colors.black, // 按你主题调整
                    ),
                    children: [
                      // 徽章作为行内 widget
                      if (widget.videoDetail!.copyright == 2)
                        const WidgetSpan(
                          alignment: PlaceholderAlignment.middle,
                          child: Padding(
                            padding: const EdgeInsets.only(right: 4),
                            child: PBadge(
                              text: '转载',
                              stack: 'normal',
                              size: 'medium',
                              type: 'color',
                              fs: 11,
                            ),
                          ),
                        ),
                      // 标题文字
                      TextSpan(text: widget.videoDetail!.title),
                    ],
                  ),
                ),
                expanded: RichText(
                  maxLines: 10,
                  overflow: TextOverflow.ellipsis,
                  text: TextSpan(
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Colors.black, // 按你主题调整
                    ),
                    children: [
                      // 徽章作为行内 widget
                      if (widget.videoDetail!.copyright == 2)
                        const WidgetSpan(
                          alignment: PlaceholderAlignment.middle,
                          child: Padding(
                            padding: const EdgeInsets.only(right: 4),
                            child: PBadge(
                              text: '转载',
                              stack: 'normal',
                              size: 'medium',
                              type: 'color',
                              fs: 11,
                            ),
                          ),
                        ),
                      // 标题文字
                      TextSpan(text: widget.videoDetail!.title),
                    ],
                  ),
                ),
                theme: const ExpandableThemeData(
                  animationDuration: Duration(milliseconds: 300),
                  scrollAnimationDuration: Duration(milliseconds: 300),
                  crossFadePoint: 0,
                  fadeCurve: Curves.ease,
                  sizeCurve: Curves.linear,
                ),
              ),
            ),
            2.verticalSpace,
            //浏览量、弹幕数、发布日期、在线人数
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Icon(
                  Icons.play_circle_outline_rounded,
                  size: 14,
                  color: Colors.grey,
                ),
                1.horizontalSpace,
                Text(
                  NumUtils.int2Num(widget.videoDetail!.stat!.view!),
                  style: const TextStyle(fontSize: 12, color: Colors.grey),
                ),
                8.horizontalSpace,
                const Icon(
                  Icons.subtitles_outlined,
                  size: 14,
                  color: Colors.grey,
                ),
                1.horizontalSpace,
                Text(
                  NumUtils.int2Num(widget.videoDetail!.stat!.danmaku!),
                  style: const TextStyle(fontSize: 12, color: Colors.grey),
                ),
                10.horizontalSpace,
                Text(
                  NumUtils.dateFormat(widget.videoDetail!.pubdate!,
                      formatType: 'detail'),
                  style: const TextStyle(fontSize: 12, color: Colors.grey),
                ),
                10.horizontalSpace,
                Obx(
                  () => Text(
                    '${videoIntroController.total.value}人在看',
                    style: TextStyle(
                      fontSize: 12,
                      color: Theme.of(context).colorScheme.outline,
                    ),
                  ),
                )
              ],
            ),
            //简介
            ExpandablePanel(
              controller: _expandableController,
              collapsed: const SizedBox(height: 0),
              expanded: IntroDetail(
                videoDetail: widget.videoDetail,
                videoTags: widget.videoTags,
              ),
              theme: const ExpandableThemeData(
                animationDuration: Duration(milliseconds: 300),
                scrollAnimationDuration: Duration(milliseconds: 300),
                crossFadePoint: 0,
                fadeCurve: Curves.ease,
                sizeCurve: Curves.linear,
              ),
            ),
            if (widget.videoDetail!.ugcSeason != null) ...[
              Obx(
                () => SeasonPanel(
                  ugcSeason: widget.videoDetail!.ugcSeason!,
                  cid: videoIntroController.lastPlaySCid.value != 0
                      ? videoIntroController.lastPlaySCid.value
                      : widget.videoDetail!.pages!.first.cid,
                  sheetHeight: videoDetailCtr.sheetHeight.value,
                  changeFuc: (bvid, cid, aid, cover) =>
                      videoIntroController.changeSeasonOrbangu(
                    bvid,
                    cid,
                    aid,
                    cover,
                    'season',
                  ),
                  videoIntroController: videoIntroController,
                ),
              )
            ],
            // 合集 videoEpisode
            if (widget.videoDetail!.pages != null &&
                widget.videoDetail!.pages!.length > 1) ...[
              Obx(
                () => PagesPanel(
                  pages: widget.videoDetail!.pages!,
                  cid: videoIntroController.lastPlayCid.value,
                  sheetHeight: videoDetailCtr.sheetHeight.value,
                  changeFuc: (cid, cover) {
                    print("切换后的cid: $cid, cover: $cover");
                    videoIntroController.changeSeasonOrbangu(
                      videoIntroController.bvid,
                      cid,
                      null,
                      cover,
                      'page',
                    );
                  },
                  videoIntroCtr: videoIntroController,
                ),
              )
            ],
            //点赞、投币、收藏、转发
            Material(child: actionGrid(context, videoIntroController)),
          ],
        ),
      ),
    );
  }

  Widget actionGrid(BuildContext context, videoIntroController) {
    Map<String, Widget> menuListWidgets = {
      'like': Obx(
        () => ActionItem(
          icon: const Icon(FontAwesomeIcons.thumbsUp),
          selectIcon: const Icon(FontAwesomeIcons.solidThumbsUp),
          onTap: videoIntroController.actionLikeVideo,
          selectStatus: videoIntroController.hasLike.value,
          text: NumUtils.int2Num(widget.videoDetail!.stat!.like!),
        ),
      ),
      'coin': Obx(
        () => ActionItem(
          icon: const Icon(FontAwesomeIcons.b),
          selectIcon: const Icon(FontAwesomeIcons.b),
          onTap: videoIntroController.actionCoinVideo,
          selectStatus: videoIntroController.hasCoin.value,
          text: NumUtils.int2Num(widget.videoDetail!.stat!.coin!),
        ),
      ),
      'collect': Obx(
        () => ActionItem(
          icon: const Icon(FontAwesomeIcons.star),
          selectIcon: const Icon(FontAwesomeIcons.solidStar),
          onTap: videoIntroController.actionFavVideo,
          onLongPress: () {},
          selectStatus: videoIntroController.hasFav.value,
          text: NumUtils.int2Num(widget.videoDetail!.stat!.favorite!),
        ),
      ),
      'share': ActionItem(
        icon: const Icon(FontAwesomeIcons.share),
        onTap: () => videoIntroController.actionShareVideo(),
        selectStatus: false,
        text: NumUtils.int2Num(widget.videoDetail!.stat!.share!),
      ),
    };
    final List<Widget> list = [];
    list.addAll(menuListWidgets.values);
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        return Container(
          margin: const EdgeInsets.only(top: 6, bottom: 4),
          height: constraints.maxWidth / 11,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: list.length,
            separatorBuilder: (_, __) => const SizedBox(width: 8),
            itemBuilder: (_, index) => list[index],
          ),
        );
      },
    );
  }
}
