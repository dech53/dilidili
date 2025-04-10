import 'dart:async';
import 'package:dilidili/model/nav_user_info.dart';
import 'package:dilidili/model/video/related_video.dart';
import 'package:dilidili/model/video/video_basic_info.dart';
import 'package:dilidili/model/video_play_url.dart';
import 'package:dilidili/pages/video/detail/video_page_vm.dart';
import 'package:dilidili/pages/video/panel/video_info_panel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:media_kit_video/media_kit_video.dart';
import 'package:provider/provider.dart';

class VideoPage extends StatefulWidget {
  final String bvid;
  final int cid;
  final int mid;
  const VideoPage(
      {super.key, required this.bvid, required this.cid, required this.mid});

  @override
  State<VideoPage> createState() => _VideoPageState();
}

class _VideoPageState extends State<VideoPage>
    with SingleTickerProviderStateMixin {
  final VideoPageViewModel _viewmodel = VideoPageViewModel();
  Timer? _peopleCountTimer;
  late PageController _pageController;
  late TabController _tabController;

  List tabs = ["简介", "评论"];
  @override
  void dispose() {
    super.dispose();
    _viewmodel.player.dispose();
    _viewmodel.main_controller = null;
    _peopleCountTimer?.cancel();
    _peopleCountTimer = null;
  }

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: tabs.length, vsync: this);
    _pageController = PageController();
    _viewmodel.fetchVideoPlayurl(widget.cid, widget.bvid);
    _viewmodel.fetchUpInfo(widget.mid);
    _viewmodel.fetchOnlinePeople(widget.cid, widget.bvid);
    _viewmodel.fetchBasicVideoInfo(widget.cid, widget.bvid);
    _viewmodel.fetchRelatedVideo(widget.bvid);
    _peopleCountTimer = Timer.periodic(
      const Duration(seconds: 30),
      (timer) => _viewmodel.fetchOnlinePeople(widget.cid, widget.bvid),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: _viewmodel,
      child: Scaffold(
        extendBody: true,
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(0),
          child: AppBar(
            backgroundColor: Colors.black,
            elevation: 0,
          ),
        ),
        backgroundColor: Theme.of(context).colorScheme.surface,
        body: _getBodyUI(),
      ),
    );
  }

  Widget _getBodyUI() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.max,
      children: [
        Selector<VideoPageViewModel, VideoController?>(
            builder: (context, controller, child) {
              return (controller != null)
                  ? AspectRatio(
                      aspectRatio: 16 / 9,
                      child: Video(
                        controller: controller,
                      ),
                    )
                  : AspectRatio(
                      aspectRatio: 16 / 9,
                      child: Container(
                        color: Colors.black,
                        child: const Center(
                          child: CircularProgressIndicator(
                            valueColor:
                                AlwaysStoppedAnimation<Color>(Colors.black),
                            backgroundColor: Colors.white,
                          ),
                        ),
                      ),
                    );
            },
            selector: (_, viewModel) => viewModel.main_controller),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SizedBox(
                    width: ScreenUtil().screenWidth / 2,
                    child: TabBar(
                      dividerHeight: 0.2,
                      splashFactory: NoSplash.splashFactory,
                      padding: EdgeInsets.zero,
                      isScrollable: true,
                      labelStyle: const TextStyle(fontSize: 13),
                      labelPadding:
                          const EdgeInsets.symmetric(horizontal: 25.0),
                      controller: _tabController,
                      dividerColor: Colors.transparent,
                      tabs: tabs
                          .map((e) => Tab(
                                text: e,
                              ))
                          .toList(),
                      onTap: (index) {
                        _pageController.animateToPage(
                          index,
                          duration: const Duration(milliseconds: 300),
                          curve: Curves.ease,
                        );
                      },
                    ),
                  ),
                ],
              ),
              Expanded(
                child: PageView(
                  controller: _pageController,
                  onPageChanged: (value) {
                    setState(() {
                      _tabController.animateTo(
                        value,
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.ease,
                      );
                    });
                  },
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.all(7.w),
                      child: Selector<
                          VideoPageViewModel,
                          ({
                            UserCardInfo? user,
                            VideoOnlinePeople? onlinePeople,
                            VideoDetailData? videoDetailData,
                            List<RelatedVideoItem>? relatedVideo,
                          })>(
                        builder: (context, data, child) {
                          return (data.user != null &&
                                  data.onlinePeople != null &&
                                  data.videoDetailData != null &&
                                  data.relatedVideo != null)
                              ? VideoInfoPanel(
                                  user: data.user!,
                                  count: data.onlinePeople!,
                                  videoDetailData: data.videoDetailData!,
                                  relatedVideo: data.relatedVideo!,
                                  itemTap: (bvid, cid, mid) {
                                    _viewmodel.fetchVideoPlayurl(cid, bvid);
                                    _viewmodel.fetchUpInfo(mid);
                                    _viewmodel.fetchOnlinePeople(cid, bvid);
                                    _viewmodel.fetchBasicVideoInfo(cid, bvid);
                                    _viewmodel.fetchRelatedVideo(bvid);
                                  },
                                )
                              : const Text("加载中");
                        },
                        selector: (_, viewModel) => (
                          user: viewModel.upInfo,
                          onlinePeople: viewModel.onlinePeople,
                          videoDetailData: viewModel.videoData,
                          relatedVideo: viewModel.relatedVideo,
                        ),
                      ),
                    ),
                    const Center(
                      child: Text("2"),
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
