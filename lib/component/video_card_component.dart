import 'package:cached_network_image/cached_network_image.dart';
import 'package:dilidili/model/rcmd_video.dart';
import 'package:dilidili/utils/log_utils.dart';
import 'package:dilidili/utils/num_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class VideoCardComponent extends StatelessWidget {
  final VideoItem video;
  final Function(VideoItem video)? itemTap;
  const VideoCardComponent({
    required this.video,
    super.key,
    this.itemTap,
  });

  @override
  Widget build(BuildContext context) {
    return _getVideoCardUI();
  }

  Widget _getVideoCardUI() {
    return GestureDetector(
      onTap: () {
        itemTap?.call(video);
      },
      child: Column(
        children: [
          Stack(
            children: [
              AspectRatio(
                aspectRatio: 16 / 9,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(5.r),
                  child: CachedNetworkImage(
                    fit: BoxFit.cover,
                    imageUrl: video.pic.replaceFirst("http://", "https://"),
                    httpHeaders: const {},
                  ),
                ),
              ),
              Positioned(
                right: 1.0,
                bottom: 1.0,
                child: Card(
                  elevation: 0.0,
                  color: Colors.black.withValues(alpha: 0.3),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(3.r),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(1.5),
                    child: Text(
                      NumUtils.int2time(video.duration),
                      style: TextStyle(
                        fontSize: 10.sp,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
          Padding(
            padding: EdgeInsets.all(1.r),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(
                  video.title,
                  style: TextStyle(
                    fontSize: 12.sp,
                    color: Colors.black,
                  ),
                  overflow: TextOverflow.ellipsis,
                  maxLines: 2,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.play_circle_outline_rounded,
                          size: 13.r,
                        ),
                        1.horizontalSpace,
                        Text(
                          NumUtils.int2Num(video.stat.view),
                          style:
                              TextStyle(fontSize: 9.sp, color: Colors.black),
                        ),
                        8.horizontalSpace,
                        Icon(
                          Icons.subtitles_outlined,
                          size: 13.r,
                        ),
                        1.horizontalSpace,
                        Text(
                          NumUtils.int2Num(video.stat.danmaku),
                          style:
                              TextStyle(fontSize: 9.sp, color: Colors.black),
                        ),
                      ],
                    ),
                    Text(
                      NumUtils.int2Date(video.pubdate),
                      style: TextStyle(fontSize: 9.sp, color: Colors.black),
                    ),
                  ],
                ),
                1.verticalSpace,
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      video.owner.name,
                      style: TextStyle(fontSize: 10.sp, color: Colors.black),
                    ),
                    GestureDetector(
                      onTap: () {
                        Logutils.println("点击了${video.title}");
                      },
                      child: Icon(
                        Icons.more_vert,
                        size: 13.r,
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
