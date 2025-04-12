import 'dart:async';
import 'package:dilidili/pages/video/detail/video_page_vm.dart';
import 'package:dilidili/pages/video/introduction/view.dart';
import 'package:dilidili/pages/video/related/view.dart';
import 'package:dilidili/utils/log_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:media_kit_video/media_kit_video.dart';
import 'package:provider/provider.dart';

class VideoPage extends StatefulWidget {
  const VideoPage({super.key});
  @override
  State<VideoPage> createState() => _VideoPageState();
}

class _VideoPageState extends State<VideoPage>
    with SingleTickerProviderStateMixin, WidgetsBindingObserver {
  late String bvid;
  late int cid;
  late int mid;
  final VideoPageViewModel _viewmodel = VideoPageViewModel();
  Timer? _peopleCountTimer;
  late PageController _pageController;
  late TabController _tabController;
  final ScrollController _scrollController = ScrollController();

  List tabs = ["简介", "评论"];
  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();

    _viewmodel.player.dispose();
    _viewmodel.main_controller = null;
    _peopleCountTimer?.cancel();
    _peopleCountTimer = null;
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    if (state == AppLifecycleState.paused ||
        state == AppLifecycleState.inactive) {
      Logutils.println("应用暂停");
      _peopleCountTimer?.cancel();
    } else if (state == AppLifecycleState.resumed) {
      Logutils.println("应用暂停");
      _peopleCountTimer = Timer.periodic(
        const Duration(seconds: 30),
        (timer) => _viewmodel.fetchOnlinePeople(cid, bvid),
      );
    }
  }

  @override
  void initState() {
    WidgetsBinding.instance.addObserver(this);
    super.initState();
    bvid = Get.parameters['bvid']!;
    cid = int.parse(Get.parameters['cid']!);
    mid = int.parse(Get.parameters['mid']!);
    _tabController = TabController(length: tabs.length, vsync: this);
    _pageController = PageController();
    _viewmodel.fetchVideoPlayurl(cid, bvid);
    _viewmodel.fetchUpInfo(mid);
    _viewmodel.fetchOnlinePeople(cid, bvid);
    _viewmodel.fetchBasicVideoInfo(cid, bvid);
    _viewmodel.fetchRelatedVideo(bvid);
    _peopleCountTimer = Timer.periodic(
      const Duration(seconds: 30),
      (timer) => _viewmodel.fetchOnlinePeople(cid, bvid),
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
                      color: Theme.of(context).dividerColor.withOpacity(0.1),
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
                          labelPadding:
                              const EdgeInsets.symmetric(horizontal: 10.0),
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
                                  padding:
                                      WidgetStateProperty.all(EdgeInsets.zero),
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
      ],
    );
  }
}
