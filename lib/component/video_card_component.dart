import 'package:cached_network_image/cached_network_image.dart';
import 'package:dilidili/common/constants.dart';
import 'package:dilidili/common/widgets/network_img_layer.dart';
import 'package:dilidili/http/user.dart';
import 'package:dilidili/http/video.dart';
import 'package:dilidili/model/rcmd_video.dart';
import 'package:dilidili/utils/log_utils.dart';
import 'package:dilidili/utils/num_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:dilidili/common/widgets/badge.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:get/get.dart';

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
    return _getVideoCardUI(context);
  }

  Widget _buildBadge(String text, String type, [double fs = 12]) {
    return PBadge(
      text: text,
      stack: 'normal',
      size: 'small',
      type: type,
      fs: fs,
    );
  }

  Widget _getVideoCardUI(context) {
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
                        bottom: 8,
                        right: 8,
                        text: NumUtils.int2time(video.duration),
                        type: 'gray',
                      )
                    ],
                    if (video.rcmd_reason != null &&
                        video.rcmd_reason!.content != null)
                      PBadge(
                        top: 8,
                        left: 8,
                        text: video.rcmd_reason!.content!,
                      )
                  ],
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(0.3),
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
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    if (video.goto == 'picture') _buildBadge('动态', 'line', 9),
                    if (video.is_followed == 1) _buildBadge('已关注', 'color'),
                    Expanded(
                      flex: 1,
                      child: Text(
                        video.owner.name,
                        style: TextStyle(fontSize: 10.sp, color: Colors.black),
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