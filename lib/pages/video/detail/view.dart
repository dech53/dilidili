import 'dart:async';
import 'package:adaptive_platform_ui/adaptive_platform_ui.dart';
import 'package:dilidili/model/search_type.dart';
import 'package:dilidili/pages/bangumi/introduction/view.dart';
import 'package:dilidili/pages/damuku/view.dart';
import 'package:dilidili/pages/dplayer/controller.dart';
import 'package:dilidili/pages/dplayer/models/play_status.dart';
import 'package:dilidili/pages/dplayer/utils/fullscreen.dart';
import 'package:dilidili/pages/dplayer/view.dart';
import 'package:dilidili/pages/video/detail/controller.dart';
import 'package:dilidili/pages/video/detail/widgets/app_bar.dart';
import 'package:dilidili/pages/video/introduction/controller.dart';
import 'package:dilidili/pages/video/introduction/view.dart';
import 'package:dilidili/pages/video/related/view.dart';
import 'package:dilidili/pages/video/reply/view.dart';
import 'package:dilidili/utils/storage.dart';
import 'package:extended_nested_scroll_view/extended_nested_scroll_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:liquid_glass_widgets/liquid_glass_widgets.dart';
import 'package:lottie/lottie.dart';

class VideoPage extends StatefulWidget {
  const VideoPage({super.key});
  @override
  State<VideoPage> createState() => _VideoPageState();
  static final RouteObserver<PageRoute> routeObserver =
      RouteObserver<PageRoute>();
}

class _VideoPageState extends State<VideoPage>
    with SingleTickerProviderStateMixin, RouteAware, WidgetsBindingObserver {
  late VideoDetailController vdCtr;
  late double statusBarHeight;
  Rx<DPlayerStatus> playerStatus = DPlayerStatus.playing.obs;
  final Box<dynamic> localCache = SPStorage.localCache;
  late VideoIntroController videoIntroCtr;
  DPlayerController? dPlayerController;
  late StreamController<double> appbarStream;
  final ScrollController _extendNestCtr = ScrollController();
  final double videoHeight = Get.size.width * 9 / 16;
  bool _resumePlaybackOnReturn = false;
  double _lastAppbarOffset = 0;
  late String bvid;
  // late int cid;
  late String heroTag;
  RxBool isShowing = true.obs;
  // late int mid;
  late Future _futureBuilderFuture;
  PageRoute<dynamic>? _route;

  @override
  void dispose() {
    dPlayerController?.removeStatusLister(playerListener);
    VideoPage.routeObserver.unsubscribe(this);
    WidgetsBinding.instance.removeObserver(this);
    _extendNestCtr.removeListener(_onExtendedNestedScroll);
    _extendNestCtr.dispose();
    appbarStream.close();
    super.dispose();
  }

  void _onExtendedNestedScroll() {
    final double offset = _extendNestCtr.position.pixels;
    _lastAppbarOffset = offset;
    vdCtr.sheetHeight.value =
        Get.size.height - videoHeight - statusBarHeight + offset;
    if (!appbarStream.isClosed) {
      appbarStream.add(offset);
    }
  }

  @override
  void didPushNext() async {
    if (dPlayerController != null) {
      _resumePlaybackOnReturn = playerStatus.value == DPlayerStatus.playing;
      vdCtr.defaultST = dPlayerController!.position.value;
      videoIntroCtr.isPaused = true;
      dPlayerController!.removeStatusLister(playerListener);
      dPlayerController!.pause();
    }
    isShowing.value = false;
    super.didPushNext();
  }

  @override
  void didPopNext() async {
    isShowing.value = true;
    await vdCtr.playerInit(autoPlay: _resumePlaybackOnReturn);
    videoIntroCtr.isPaused = false;
    await Future.delayed(const Duration(milliseconds: 300));
    dPlayerController?.seekTo(vdCtr.defaultST);
    if (_resumePlaybackOnReturn) {
      dPlayerController?.play();
    } else {
      playerStatus.value = DPlayerStatus.paused;
    }
    dPlayerController?.addStatusLister(playerListener);
    if (!appbarStream.isClosed) {
      appbarStream.add(_lastAppbarOffset);
    }
    super.didPopNext();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.inactive ||
        state == AppLifecycleState.paused ||
        state == AppLifecycleState.hidden ||
        state == AppLifecycleState.resumed) {
      vdCtr.updateNowPlayingMetadata();
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final ModalRoute<dynamic>? route = ModalRoute.of(context);
    if (route is PageRoute<dynamic> && route != _route) {
      VideoPage.routeObserver.unsubscribe(this);
      _route = route;
      VideoPage.routeObserver.subscribe(this, route);
    }
  }

  @override
  void initState() {
    super.initState();
    heroTag = Get.arguments['heroTag'];
    bvid = Get.arguments['bvid']!;
    // cid = int.parse(Get.parameters['cid']!);
    // mid = int.parse(Get.arguments['mid']!);
    vdCtr = Get.put(VideoDetailController(), tag: heroTag);
    vdCtr.sheetHeight.value = localCache.get('sheetHeight');
    videoIntroCtr = Get.put(VideoIntroController(bvid: Get.arguments['bvid']!),
        tag: heroTag);
    _futureBuilderFuture = vdCtr.queryVideoUrl();
    dPlayerController = vdCtr.dPlayerController;
    dPlayerController!.addStatusLister(playerListener);
    statusBarHeight = SPStorage.statusBarHeight;
    appbarStreamListen();
    WidgetsBinding.instance.addObserver(this);
  }

  void playerListener(DPlayerStatus status) async {
    playerStatus.value = status;
  }

  appbarStreamListen() {
    appbarStream = StreamController<double>.broadcast();
    _extendNestCtr.addListener(_onExtendedNestedScroll);
  }

  @override
  Widget build(BuildContext context) {
    final sizeContext = MediaQuery.sizeOf(context);
    final mediaQuery = MediaQuery.of(context);
    late double defaultVideoHeight = sizeContext.width * 9 / 16;
    late RxDouble videoHeight = defaultVideoHeight.obs;
    final double pinnedHeaderHeight =
        statusBarHeight + kToolbarHeight + videoHeight.value;

    // 横屏
    final bool isLandscape = mediaQuery.orientation == Orientation.landscape;
    final Rx<bool> isFullScreen = dPlayerController?.isFullScreen ?? false.obs;
    // 全屏时高度撑满
    if (isLandscape || isFullScreen.value == true) {
      videoHeight.value = Get.size.height;
      enterFullScreen();
    } else {
      videoHeight.value = defaultVideoHeight;
      exitFullScreen();
    }

    Widget buildLoadingWidget() {
      return Center(child: Lottie.asset('assets/loading.json', width: 200));
    }

    Widget buildErrorWidget(dynamic error) {
      return Obx(
        () => SizedBox(
          height: videoHeight.value,
          width: Get.size.width,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Text('加载失败', style: TextStyle(color: Colors.white)),
              Text('$error', style: const TextStyle(color: Colors.white)),
              const SizedBox(height: 10),
              IconButton.filled(
                onPressed: () {
                  setState(() {
                    _futureBuilderFuture = vdCtr.queryVideoUrl();
                  });
                },
                icon: const Icon(Icons.refresh),
              )
            ],
          ),
        ),
      );
    }

    Widget buildVideoPlayerWidget(AsyncSnapshot snapshot) {
      return Obx(
        () => DPlayer(
          controller: dPlayerController!,
          headerControl: vdCtr.headerControl,
          bottomList: vdCtr.bottomList,
          danmuWidget: Danmuku(
            key: Key(vdCtr.danmakuCid.value.toString()),
            cid: vdCtr.danmakuCid.value,
            playerController: dPlayerController!,
          ),
          fullScreenCb: (bool status) {
            videoHeight.value = status ? Get.size.height : defaultVideoHeight;
          },
        ),
      );
    }

    Widget buildVideoPlayerPanel() {
      return FutureBuilder(
        future: _futureBuilderFuture,
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return buildLoadingWidget();
          } else if (snapshot.connectionState == ConnectionState.done) {
            if (snapshot.hasData && snapshot.data['status']) {
              return buildVideoPlayerWidget(snapshot);
            } else {
              return buildErrorWidget(snapshot.error);
            }
          } else {
            return buildErrorWidget('未知错误');
          }
        },
      );
    }

    Widget tabbarBuild() {
      return Container(
        width: double.infinity,
        height: 45,
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(
              width: 1,
              color: Theme.of(context).dividerColor.withValues(alpha: 0.1),
            ),
          ),
        ),
        child: Material(
          color: Colors.transparent,
          child: Row(
            children: [
              Expanded(
                child: Padding(
                  padding: EdgeInsets.only(left: 12.w, right: 8.w),
                  child: Obx(
                    () => _VideoDetailSegmentedTabs(
                      tabs: vdCtr.tabs.toList(),
                      selectedIndex: vdCtr.selectedTabIndex.value,
                      onSelected: vdCtr.onTapTabbar,
                    ),
                  ),
                ),
              ),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(
                    height: 32,
                    child: TextButton(
                      style: ButtonStyle(
                        padding: WidgetStateProperty.all(EdgeInsets.zero),
                      ),
                      onPressed: () => vdCtr.showShootDanmakuSheet(),
                      child: const Text('发弹幕', style: TextStyle(fontSize: 12)),
                    ),
                  ),
                  SizedBox(
                    width: 38,
                    height: 38,
                    child: Obx(
                      () => !vdCtr.isShowCover.value
                          ? IconButton(
                              onPressed: () {
                                dPlayerController?.isOpenDanmu.value =
                                    !(dPlayerController?.isOpenDanmu.value ??
                                        false);
                              },
                              icon: !(dPlayerController?.isOpenDanmu.value ??
                                      false)
                                  ? SvgPicture.asset(
                                      'assets/images/video/danmu_close.svg',
                                      // ignore: deprecated_member_use
                                      color:
                                          Theme.of(context).colorScheme.outline,
                                    )
                                  : SvgPicture.asset(
                                      'assets/images/video/danmu_open.svg',
                                      // ignore: deprecated_member_use
                                      color:
                                          Theme.of(context).colorScheme.primary,
                                    ),
                            )
                          : IconButton(
                              icon: SvgPicture.asset(
                                'assets/images/video/danmu_close.svg',
                                // ignore: deprecated_member_use
                                color: Theme.of(context).colorScheme.outline,
                              ),
                              onPressed: () {},
                            ),
                    ),
                  ),
                  SizedBox(width: 12.w),
                ],
              ),
            ],
          ),
        ),
      );
    }

    return SafeArea(
      top: MediaQuery.of(context).orientation == Orientation.portrait &&
          dPlayerController?.isFullScreen.value == true,
      bottom: MediaQuery.of(context).orientation == Orientation.portrait &&
          dPlayerController?.isFullScreen.value == true,
      left: false,
      right: false,
      child: Stack(
        children: [
          Scaffold(
            resizeToAvoidBottomInset: false,
            key: vdCtr.scaffoldKey,
            appBar: PreferredSize(
              preferredSize: const Size.fromHeight(0),
              child: StreamBuilder(
                stream: appbarStream.stream.distinct(),
                initialData: 0,
                builder: ((context, snapshot) {
                  return AppBar(
                    backgroundColor: Colors.black,
                    elevation: 0,
                    scrolledUnderElevation: 0,
                    systemOverlayStyle: Get.isDarkMode
                        ? SystemUiOverlayStyle.light
                        : snapshot.data!.toDouble() > kToolbarHeight
                            ? SystemUiOverlayStyle.dark
                            : SystemUiOverlayStyle.light,
                  );
                }),
              ),
            ),
            body: ExtendedNestedScrollView(
              controller: _extendNestCtr,
              headerSliverBuilder:
                  (BuildContext context2, bool innerBoxIsScrolled) {
                return <Widget>[
                  Obx(
                    () {
                      final Orientation orientation =
                          MediaQuery.of(context).orientation;
                      final bool isFullScreen =
                          dPlayerController?.isFullScreen.value == true;
                      final double expandedHeight =
                          orientation == Orientation.landscape || isFullScreen
                              ? (MediaQuery.sizeOf(context).height -
                                  (orientation == Orientation.landscape
                                      ? 0
                                      : MediaQuery.of(context).padding.top))
                              : videoHeight.value;
                      if (orientation == Orientation.landscape ||
                          isFullScreen) {
                        enterFullScreen();
                      } else {
                        exitFullScreen();
                      }
                      return SliverAppBar(
                        automaticallyImplyLeading: false,
                        pinned: true,
                        elevation: 0,
                        scrolledUnderElevation: 0,
                        forceElevated: innerBoxIsScrolled,
                        expandedHeight: expandedHeight,
                        backgroundColor: Colors.black,
                        flexibleSpace: FlexibleSpaceBar(
                          background: PopScope(
                            canPop:
                                dPlayerController?.isFullScreen.value != true,
                            onPopInvokedWithResult: (didPop, result) {
                              if (dPlayerController?.isFullScreen.value ==
                                  true) {
                                dPlayerController!
                                    .triggerFullScreen(status: false);
                              }
                              if (MediaQuery.of(context).orientation ==
                                  Orientation.landscape) {
                                verticalScreen();
                              }
                            },
                            child: LayoutBuilder(
                              builder: (BuildContext context,
                                  BoxConstraints constraints) {
                                return Stack(
                                  children: <Widget>[
                                    Obx(
                                      () => isShowing.value
                                          ? buildVideoPlayerPanel()
                                          : const SizedBox(),
                                    ),
                                  ],
                                );
                              },
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ];
              },
              pinnedHeaderSliverHeightBuilder: () {
                return playerStatus.value != DPlayerStatus.playing
                    ? kToolbarHeight
                    : pinnedHeaderHeight;
              },
              onlyOneScrollInBody: true,
              body: Column(
                children: [
                  tabbarBuild(),
                  Expanded(
                    child: TabBarView(
                      controller: vdCtr.tabCtr,
                      children: <Widget>[
                        Builder(
                          builder: (BuildContext context) {
                            return CustomScrollView(
                              slivers: <Widget>[
                                if (vdCtr.videoType == SearchType.video) ...[
                                  VideoIntroPanel(bvid: vdCtr.bvid),
                                ] else if (vdCtr.videoType ==
                                    SearchType.media_bangumi) ...[
                                  Obx(() =>
                                      BangumiIntroPanel(cid: vdCtr.cid.value)),
                                ],
                                SliverToBoxAdapter(
                                  child: Divider(
                                    indent: 12,
                                    endIndent: 12,
                                    color: Theme.of(context)
                                        .dividerColor
                                        .withValues(alpha: 0.06),
                                  ),
                                ),
                                if (vdCtr.videoType == SearchType.video)
                                  const RelatedVideoPanel(),
                              ],
                            );
                          },
                        ),
                        Obx(
                          () => VideoReplyPanel(
                            bvid: vdCtr.bvid,
                            oid: vdCtr.oid.value,
                            onControllerCreated: vdCtr.onControllerCreated,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          StreamBuilder(
            stream: appbarStream.stream.distinct(),
            initialData: 0,
            builder: ((context, snapshot) {
              return ScrollAppBar(
                snapshot.data!.toDouble(),
                () => continuePlay(),
                playerStatus.value,
                null,
              );
            }),
          ),
        ],
      ),
    );
  }

  void continuePlay() async {
    await _extendNestCtr.animateTo(0,
        duration: const Duration(milliseconds: 500), curve: Curves.easeInOut);
    dPlayerController!.play();
  }
}

class _VideoDetailSegmentedTabs extends StatelessWidget {
  const _VideoDetailSegmentedTabs({
    required this.tabs,
    required this.selectedIndex,
    required this.onSelected,
  });

  final List<String> tabs;
  final int selectedIndex;
  final ValueChanged<int> onSelected;

  static const double _height = 32;
  static const double _padding = 3;
  static const LiquidGlassSettings _bottomNavigationGlassSettings =
      LiquidGlassSettings(
    thickness: 30,
    blur: 3,
    chromaticAberration: 0.3,
    lightIntensity: 0.6,
    refractiveIndex: 1.59,
    saturation: 0.7,
    ambientStrength: 1,
    lightAngle: 0.7853981633974483,
    glassColor: Color(0x3DFFFFFF),
  );

  @override
  Widget build(BuildContext context) {
    final ColorScheme colorScheme = Theme.of(context).colorScheme;
    final int safeIndex = selectedIndex.clamp(0, tabs.length - 1);
    final Color selectedColor = colorScheme.primary;
    final Color unselectedColor = colorScheme.onSurface.withValues(alpha: 0.68);
    final Color indicatorColor = colorScheme.primary.withValues(alpha: 0.32);
    final LiquidShape capsuleShape =
        LiquidRoundedSuperellipse(borderRadius: _height.r / 2);

    if (PlatformInfo.isIOS26OrHigher()) {
      return SizedBox(
        height: _height.h,
        child: AdaptiveSegmentedControl(
          labels: tabs,
          selectedIndex: safeIndex,
          onValueChanged: onSelected,
          color: selectedColor,
          height: _height.h,
          textColor: unselectedColor,
          selectedTextColor: Colors.white,
        ),
      );
    }

    return AdaptiveLiquidGlassLayer(
      settings: _bottomNavigationGlassSettings,
      quality: GlassQuality.standard,
      shape: capsuleShape,
      child: SizedBox(
        height: _height.h,
        child: AdaptiveGlass.grouped(
          quality: GlassQuality.standard,
          shape: capsuleShape,
          child: GlassSegmentedControl(
            segments: tabs,
            selectedIndex: safeIndex,
            onSegmentSelected: onSelected,
            height: _height.h,
            borderRadius: _height.r / 2,
            padding: EdgeInsets.all(_padding.r),
            backgroundColor: Colors.transparent,
            indicatorColor: indicatorColor,
            indicatorSettings: const LiquidGlassSettings(
              glassColor: Colors.transparent,
              lightIntensity: 0,
              chromaticAberration: 0,
              blur: 0,
            ),
            useOwnLayer: false,
            quality: GlassQuality.standard,
            selectedTextStyle: TextStyle(
              color: selectedColor,
              fontSize: 12.sp,
              fontWeight: FontWeight.w700,
            ),
            unselectedTextStyle: TextStyle(
              color: unselectedColor,
              fontSize: 12.sp,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ),
    );
  }
}
