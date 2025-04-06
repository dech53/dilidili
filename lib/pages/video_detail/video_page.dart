import 'package:cached_network_image/cached_network_image.dart';
import 'package:dilidili/model/rcmd_video.dart';
import 'package:dilidili/pages/video_detail/video_page_vm.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

class VideoPage extends StatefulWidget {
  final VideoItem video;
  const VideoPage({super.key, required this.video});
  @override
  State<VideoPage> createState() => _VideoPageState();
}

class _VideoPageState extends State<VideoPage> {
  final VideoPageViewModel _viewmodel = VideoPageViewModel();
  @override
  void initState() {
    super.initState();
    _viewmodel.video = widget.video;
    _viewmodel.fetchVideoPlayurl(widget.video.cid, widget.video.bvid);
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: _viewmodel,
      child: Scaffold(
        appBar: AppBar(),
        backgroundColor: Theme.of(context).colorScheme.surface,
        body: _getBodyUI(),
      ),
    );
  }

  Widget _getBodyUI() {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Selector<VideoPageViewModel, VideoItem?>(
              builder: (context, video, child) {
                return AspectRatio(
                  aspectRatio: 16 / 9,
                  child: CachedNetworkImage(
                    fit: BoxFit.cover,
                    imageUrl: video?.pic??"",
                  ),
                );
              },
              selector: (_,viewModel)=>viewModel.video),
          Padding(
            padding: EdgeInsets.all(5.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        CircleAvatar(
                          backgroundImage: CachedNetworkImageProvider(
                              widget.video.owner.face),
                        ),
                        5.horizontalSpace,
                        Column(
                          children: [
                            Text(widget.video.owner.name),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
                Text(widget.video.title),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
