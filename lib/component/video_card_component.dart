import 'package:cached_network_image/cached_network_image.dart';
import 'package:dilidili/common/constants.dart';
import 'package:dilidili/common/widgets/network_img_layer.dart';
import 'package:dilidili/model/rcmd_video.dart';
import 'package:dilidili/utils/log_utils.dart';
import 'package:dilidili/utils/num_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:dilidili/common/widgets/badge.dart';

class VideoCardComponent extends StatelessWidget {
  final RcmdVideoItem video;
  final Function(RcmdVideoItem video)? itemTap;
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
          AspectRatio(
              aspectRatio: StyleString.aspectRatio,
              child: LayoutBuilder(
                builder: (context, boxConstraints) {
                  double maxWidth = boxConstraints.maxWidth;
                  double maxHeight = boxConstraints.maxHeight;
                  return Stack(
                    children: [
                      NetworkImgLayer(
                        src: video.pic,
                        width: maxWidth,
                        height: maxHeight,
                      ),
                      if (video.duration > 0) ...[
                        PBadge(
                          bottom: 10,
                          right: 10,
                          text: NumUtils.int2time(video.duration),
                          type: 'gray',
                        )
                      ]
                    ],
                  );
                },
              )),
          Padding(
            padding: EdgeInsets.all(0.3),
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
                        const Icon(
                          Icons.play_circle_outline_rounded,
                          size: 13,
                        ),
                        1.horizontalSpace,
                        Text(
                          NumUtils.int2Num(video.stat.view),
                          style:
                              const TextStyle(fontSize: 9, color: Colors.black),
                        ),
                        8.horizontalSpace,
                        const Icon(
                          Icons.subtitles_outlined,
                          size: 13,
                        ),
                        1.horizontalSpace,
                        Text(
                          NumUtils.int2Num(video.stat.danmaku),
                          style:
                              const TextStyle(fontSize: 9, color: Colors.black),
                        ),
                      ],
                    ),
                    Text(
                      NumUtils.int2Date(video.pubdate),
                      style: const TextStyle(fontSize: 9, color: Colors.black),
                    ),
                  ],
                ),
                1.verticalSpace,
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        if (video.rcmd_reason != null &&
                            video.rcmd_reason!.content != null)
                          Row(
                            children: [
                              Container(
                                decoration: BoxDecoration(
                                    color: Colors.grey.shade300,
                                    borderRadius: BorderRadius.circular(4)),
                                child: Padding(
                                  padding: const EdgeInsets.all(1.5),
                                  child: Text(
                                    video.rcmd_reason!.content!,
                                    style: TextStyle(
                                        fontSize: 10.sp, color: Colors.black),
                                  ),
                                ),
                              ),
                              3.horizontalSpace,
                            ],
                          ),
                        Text(
                          video.owner.name,
                          style:
                              TextStyle(fontSize: 10.sp, color: Colors.black),
                        ),
                      ],
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
