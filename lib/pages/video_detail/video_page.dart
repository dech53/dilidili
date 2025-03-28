import 'package:cached_network_image/cached_network_image.dart';
import 'package:dilidili/model/rcmd_video.dart';
import 'package:dilidili/utils/wbi_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class VideoPage extends ConsumerStatefulWidget {
  final VideoItem video;
  const VideoPage({super.key, required this.video});
  @override
  ConsumerState<VideoPage> createState() => _VideoPageState();
}

class _VideoPageState extends ConsumerState<VideoPage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: _getVideoUI(widget.video),
    );
  }

  Widget _getVideoUI(VideoItem video) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AspectRatio(
            aspectRatio: 16 / 9,
            child: CachedNetworkImage(
              fit: BoxFit.cover,
              imageUrl: video.pic.replaceFirst("http://", "https://"),
            ),
          ),
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
                          backgroundImage:
                              CachedNetworkImageProvider(video.owner.face),
                        ),
                        5.horizontalSpace,
                        Column(
                          children: [
                            Text(video.owner.name),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
                Text(video.title),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
