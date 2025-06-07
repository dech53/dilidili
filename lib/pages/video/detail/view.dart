import 'dart:async';
import 'package:dilidili/pages/damuku/view.dart';
import 'package:dilidili/pages/dplayer/controller.dart';
import 'package:dilidili/pages/dplayer/models/play_status.dart';
import 'package:dilidili/pages/dplayer/view.dart';
import 'package:dilidili/pages/video/detail/controller.dart';
import 'package:dilidili/pages/video/detail/widgets/app_bar.dart';
import 'package:dilidili/pages/video/introduction/view.dart';
import 'package:dilidili/pages/video/related/view.dart';
import 'package:dilidili/utils/storage.dart';
import 'package:extended_nested_scroll_view/extended_nested_scroll_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
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
  DPlayerController? dPlayerController;
  late StreamController<double> appbarStream;
  final ScrollController _extendNestCtr = ScrollController();
  final double videoHeight = Get.size.width * 9 / 16;
  late String bvid;
  // late int cid;
  late String heroTag;
  late int mid;
  late Future _futureBuilderFuture;

  @override
  void dispose() {
    if (dPlayerController != null) {}
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didPushNext() async {
    if (dPlayerController != null) {
      vdCtr.defaultST = dPlayerController!.position.value;
      dPlayerController!.removeStatusLister(playerListener);
      dPlayerController!.pause();
    }
    super.didPushNext();
  }

  @override
  void didPopNext() async {
    vdCtr.playerInit();
    await Future.delayed(const Duration(milliseconds: 300));
    dPlayerController?.seekTo(vdCtr.defaultST);
    dPlayerController?.play();
    dPlayerController?.addStatusLister(playerListener);
    appbarStream.add(0);
    super.didPopNext();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    VideoPage.routeObserver
        .subscribe(this, ModalRoute.of(context)! as PageRoute);
  }

  @override
  void initState() {
    super.initState();
    heroTag = Get.arguments['heroTag'];
    bvid = Get.parameters['bvid']!;
    // cid = int.parse(Get.parameters['cid']!);
    mid = int.parse(Get.parameters['mid']!);
    vdCtr = Get.put(VideoDetailController(), tag: heroTag);
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
    _extendNestCtr.addListener(
      () {
        final double offset = _extendNestCtr.position.pixels;
        vdCtr.sheetHeight.value =
            Get.size.height - videoHeight - statusBarHeight + offset;
        appbarStream.add(offset);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final sizeContext = MediaQuery.sizeOf(context);
    late double defaultVideoHeight = sizeContext.width * 9 / 16;
    late RxDouble videoHeight = defaultVideoHeight.obs;
    final double pinnedHeaderHeight =
        statusBarHeight + kToolbarHeight + videoHeight.value;
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
              color: Theme.of(context).dividerColor.withOpacity(0.1),
            ),
          ),
        ),
        child: Material(
          child: Row(
            children: [
              Expanded(
                child: Obx(
                  () => TabBar(
                    padding: EdgeInsets.zero,
                    controller: vdCtr.tabCtr,
                    labelStyle: const TextStyle(fontSize: 13),
                    labelPadding: const EdgeInsets.symmetric(horizontal: 10.0),
                    dividerColor: Colors.transparent,
                    tabs: vdCtr.tabs
                        .map((String name) => Tab(text: name))
                        .toList(),
                    onTap: (index) {},
                  ),
                ),
              ),
              Flexible(
                flex: 1,
                child: Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      const SizedBox(width: 8),
                      SizedBox(
                        height: 32,
                        child: TextButton(
                          style: ButtonStyle(
                            padding: MaterialStateProperty.all(EdgeInsets.zero),
                          ),
                          onPressed: () {},
                          child:
                              const Text('发弹幕', style: TextStyle(fontSize: 12)),
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
                                        !(dPlayerController
                                                ?.isOpenDanmu.value ??
                                            false);
                                  },
                                  icon:
                                      !(dPlayerController?.isOpenDanmu.value ??
                                              false)
                                          ? SvgPicture.asset(
                                              'assets/images/video/danmu_close.svg',
                                              // ignore: deprecated_member_use
                                              color: Theme.of(context)
                                                  .colorScheme
                                                  .outline,
                                            )
                                          : SvgPicture.asset(
                                              'assets/images/video/danmu_open.svg',
                                              // ignore: deprecated_member_use
                                              color: Theme.of(context)
                                                  .colorScheme
                                                  .primary,
                                            ),
                                )
                              : IconButton(
                                  icon: SvgPicture.asset(
                                    'assets/images/video/danmu_close.svg',
                                    // ignore: deprecated_member_use
                                    color:
                                        Theme.of(context).colorScheme.outline,
                                  ),
                                  onPressed: () {},
                                ),
                        ),
                      ),
                      const SizedBox(width: 18),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    }

    return SafeArea(
      top: false,
      bottom: false,
      left: false,
      right: false,
      child: Stack(
        children: [
          Scaffold(
            resizeToAvoidBottomInset: false,
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
                  SliverAppBar(
                    automaticallyImplyLeading: false,
                    pinned: true,
                    elevation: 0,
                    scrolledUnderElevation: 0,
                    forceElevated: innerBoxIsScrolled,
                    expandedHeight: videoHeight.value,
                    backgroundColor: Colors.black,
                    flexibleSpace: FlexibleSpaceBar(
                      background: PopScope(
                        child: LayoutBuilder(
                          builder: (BuildContext context,
                              BoxConstraints constraints) {
                            return Stack(
                              children: <Widget>[
                                buildVideoPlayerPanel(),
                              ],
                            );
                          },
                        ),
                      ),
                    ),
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
                                VideoIntroPanel(bvid: bvid),
                                const RelatedVideoPanel(),
                              ],
                            );
                          },
                        ),
                        const Center(child: Text('评论功能待实现')),
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
