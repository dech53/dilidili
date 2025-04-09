import 'package:cached_network_image/cached_network_image.dart';
import 'package:dilidili/model/nav_user_info.dart';
import 'package:dilidili/model/rcmd_video.dart';
import 'package:dilidili/pages/video/detail/video_page_vm.dart';
import 'package:dilidili/utils/num_utils.dart';
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
  final PageController _controller = PageController(initialPage: 0);
  int _currentPage = 0;
  @override
  void dispose() {
    super.dispose();
    _viewmodel.player.dispose();
    _viewmodel.main_controller = null;
  }

  @override
  void initState() {
    super.initState();
    _viewmodel.video = widget.video;
    _viewmodel.fetchVideoPlayurl(widget.video.cid, widget.video.bvid);
    _viewmodel.fetchUpInfo();
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
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Selector<VideoPageViewModel,
                    ({UserCardInfo? upInfo, VideoItem? video})>(
                  builder: (context, data, child) {
                    return (data.upInfo != null)
                        ? Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  CircleAvatar(
                                    backgroundImage: CachedNetworkImageProvider(
                                        data.upInfo!.card.face),
                                  ),
                                  10.horizontalSpace,
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        data.upInfo!.card.name,
                                        style: TextStyle(
                                          fontSize: 12.sp,
                                          color: Theme.of(context)
                                              .colorScheme
                                              .outline,
                                        ),
                                      ),
                                      2.verticalSpace,
                                      Row(
                                        children: [
                                          Text(
                                            "${NumUtils.int2Num(data.upInfo!.follower)}粉丝",
                                            style: TextStyle(
                                              fontSize: 8.sp,
                                              color: Theme.of(context)
                                                  .colorScheme
                                                  .outline,
                                            ),
                                          ),
                                          5.horizontalSpace,
                                          Text(
                                            "${NumUtils.int2Num(data.upInfo!.archiveCount)}视频",
                                            style: TextStyle(
                                              fontSize: 8.sp,
                                              color: Theme.of(context)
                                                  .colorScheme
                                                  .outline,
                                            ),
                                          ),
                                        ],
                                      )
                                    ],
                                  ),
                                ],
                              ),
                              TextButton(
                                onPressed: () {},
                                style: TextButton.styleFrom(
                                  padding:
                                      const EdgeInsets.fromLTRB(15, 0, 15, 0),
                                  foregroundColor:
                                      Theme.of(context).colorScheme.outline,
                                  backgroundColor: Theme.of(context)
                                      .colorScheme
                                      .onInverseSurface,
                                ),
                                child: data.upInfo!.following
                                    ? const Text("已关注")
                                    : const Text("关注"),
                              ),
                            ],
                          )
                        : const Text("加载中");
                  },
                  selector: (_, viewModel) =>
                      (upInfo: viewModel.upInfo, video: viewModel.video),
                ),
                3.verticalSpace,
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.play_circle_outline_rounded,
                      size: 13,
                      color: Colors.grey,
                    ),
                    const SizedBox(width: 2),
                    Text(
                      NumUtils.int2Num(widget.video.stat.view),
                      style: const TextStyle(
                        fontSize: 12,
                        color: Colors.grey,
                      ),
                    ),
                    const SizedBox(width: 6),
                    const Icon(
                      Icons.subtitles_outlined,
                      size: 13,
                      color: Colors.grey,
                    ),
                    2.horizontalSpace,
                    Text(
                      NumUtils.int2Num(widget.video.stat.danmaku),
                      style: const TextStyle(
                        fontSize: 12,
                        color: Colors.grey,
                      ),
                    ),
                    6.horizontalSpace,
                    Text(
                      NumUtils.dateFormat(widget.video.pubdate,
                          formatType: 'detail'),
                      style: const TextStyle(fontSize: 12, color: Colors.grey),
                    ),
                  ],
                ),
                Expanded(
                  child: PageView.builder(
                    scrollDirection: Axis.horizontal,
                    controller: _controller,
                    onPageChanged: (value) {
                      setState(
                        () {
                          _currentPage = value;
                        },
                      );
                    },
                    itemCount: 2,
                    itemBuilder: (context, index) {
                      return Center(
                        child: Text(
                          '页面${(index + 1).toString()}',
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
