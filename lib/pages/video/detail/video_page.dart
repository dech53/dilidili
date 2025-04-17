import 'dart:async';
import 'package:dilidili/pages/dplayer/view.dart';
import 'package:dilidili/pages/video/detail/controller.dart';
import 'package:dilidili/pages/video/introduction/view.dart';
import 'package:dilidili/pages/video/related/view.dart';
import 'package:extended_nested_scroll_view/extended_nested_scroll_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:media_kit/media_kit.dart';
import 'package:media_kit_video/media_kit_video.dart';

class VideoPage extends StatefulWidget {
  const VideoPage({super.key});
  @override
  State<VideoPage> createState() => _VideoPageState();
}

class _VideoPageState extends State<VideoPage>
    with SingleTickerProviderStateMixin {
  late VideoDetailController vdCtr;
  final ScrollController _extendNestCtr = ScrollController();

  late String bvid;
  late int cid;
  late int mid;
  Timer? _peopleCountTimer;
  late TabController _tabController;
  late VideoController controller;
  late Future _futureBuilderFuture;

  List tabs = ["简介", "评论"];
  @override
  void dispose() {
    super.dispose();

    _peopleCountTimer?.cancel();
    _peopleCountTimer = null;
  }

  @override
  void initState() {
    super.initState();
    bvid = Get.parameters['bvid']!;
    cid = int.parse(Get.parameters['cid']!);
    mid = int.parse(Get.parameters['mid']!);
    vdCtr = Get.put(VideoDetailController());
    _futureBuilderFuture = vdCtr.queryVideoUrl();
    _tabController = TabController(length: tabs.length, vsync: this);
    controller = VideoController(Player());
  }

  @override
  Widget build(BuildContext context) {
    return _getBodyUI();
  }

  Widget buildLoadingWidget() {
    return Center(child: Lottie.asset('assets/loading.json', width: 200));
  }

  Widget buildErrorWidget(dynamic error) {
    return Obx(
      () => SizedBox(
        height: 200.0,
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
    return DPlayer(controller: controller);
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

  Widget _getBodyUI() {
    return SafeArea(
      left: false,
      right: false,
      child: Stack(
        children: [
          Scaffold(
            resizeToAvoidBottomInset: false,
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
                    expandedHeight: 200.0,
                    backgroundColor: Colors.black,
                    flexibleSpace: FlexibleSpaceBar(
                      background: PopScope(
                        child: LayoutBuilder(
                          builder: (BuildContext context,
                              BoxConstraints constraints) {
                            return Stack(
                              children: <Widget>[
                                //播放器界面
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
                return MediaQuery.sizeOf(context).height;
              },
              onlyOneScrollInBody: true,
              body: Expanded(
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: double.infinity,
                      height: 45,
                      decoration: BoxDecoration(
                        border: Border(
                          bottom: BorderSide(
                            width: 1,
                            color: Theme.of(context)
                                .dividerColor
                                // ignore: deprecated_member_use
                                .withOpacity(0.1),
                          ),
                        ),
                      ),
                      child: Material(
                        child: Row(
                          children: [
                            Expanded(
                              child: TabBar(
                                controller: _tabController,
                                padding: EdgeInsets.zero,
                                labelStyle: const TextStyle(fontSize: 13),
                                labelPadding: const EdgeInsets.symmetric(
                                    horizontal: 10.0),
                                dividerColor: Colors.transparent,
                                tabs: tabs
                                    .map((e) => Tab(
                                          text: e,
                                        ))
                                    .toList(),
                                onTap: (index) {},
                              ),
                            ),
                            Flexible(
                              flex: 1,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  const Icon(
                                    Icons.drag_handle_rounded,
                                    size: 20,
                                    color: Colors.grey,
                                  ),
                                  const SizedBox(width: 8),
                                  SizedBox(
                                    height: 32,
                                    child: TextButton(
                                      style: ButtonStyle(
                                        padding: WidgetStateProperty.all(
                                            EdgeInsets.zero),
                                      ),
                                      onPressed: () {},
                                      child: const Text('发弹幕',
                                          style: TextStyle(fontSize: 12)),
                                    ),
                                  ),
                                  SizedBox(
                                    width: 38,
                                    height: 38,
                                    child: IconButton(
                                      icon: SvgPicture.asset(
                                        'assets/images/video/danmu_close.svg',
                                        colorFilter: const ColorFilter.mode(
                                            Colors.grey, BlendMode.srcIn),
                                      ),
                                      onPressed: () {},
                                    ),
                                  ),
                                  const SizedBox(width: 18),
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                    Expanded(
                      child: TabBarView(
                        controller: _tabController,
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
          ),
        ],
      ),
    );
  }
}
