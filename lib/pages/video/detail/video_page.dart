import 'dart:async';
import 'package:dilidili/model/nav_user_info.dart';
import 'package:dilidili/model/rcmd_video.dart';
import 'package:dilidili/model/video_play_url.dart';
import 'package:dilidili/pages/video/detail/video_page_vm.dart';
import 'package:dilidili/pages/video/panel/video_info_panel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:media_kit_video/media_kit_video.dart';
import 'package:provider/provider.dart';

class VideoPage extends StatefulWidget {
  final VideoItem video;

  const VideoPage({super.key, required this.video});

  @override
  State<VideoPage> createState() => _VideoPageState();
}

class _VideoPageState extends State<VideoPage> {
  final VideoPageViewModel _viewmodel = VideoPageViewModel();
  Timer? _peopleCountTimer;
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
    _viewmodel.video = widget.video;
    _viewmodel.fetchVideoPlayurl(widget.video.cid, widget.video.bvid);
    _viewmodel.fetchUpInfo();
    _viewmodel.fetchOnlinePeople(widget.video.cid, widget.video.bvid);
    _viewmodel.fetchBasicVideoInfo(widget.video.cid, widget.video.bvid);
    _peopleCountTimer = Timer.periodic(
      const Duration(seconds: 30),
      (timer) =>
          _viewmodel.fetchOnlinePeople(widget.video.cid, widget.video.bvid),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: _viewmodel,
      child: Scaffold(
        extendBody: true,
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(0),
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
          child: Padding(
              padding: EdgeInsets.all(7.w),
              child: Expanded(
                  child: PageView(
                children: [
                  Selector<
                      VideoPageViewModel,
                      ({
                        UserCardInfo? user,
                        VideoItem? video,
                        VideoOnlinePeople? onlinePeople
                      })>(
                    builder: (context, data, child) {
                      return (data.user != null &&
                              data.video != null &&
                              data.onlinePeople != null)
                          ? VideoInfoPanel(
                              user: data.user!,
                              video: data.video!,
                              count: data.onlinePeople!,
                            )
                          : const Text("加载中");
                    },
                    selector: (_, viewModel) => (
                      user: viewModel.upInfo,
                      video: viewModel.video,
                      onlinePeople: viewModel.onlinePeople
                    ),
                  ),
                  const Center(
                    child: Text("2"),
                  )
                ],
              ))),
        ),
      ],
    );
  }
}
