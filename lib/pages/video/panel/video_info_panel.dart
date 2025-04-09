import 'package:cached_network_image/cached_network_image.dart';
import 'package:dilidili/model/nav_user_info.dart';
import 'package:dilidili/model/rcmd_video.dart';
import 'package:dilidili/model/video_play_url.dart';
import 'package:dilidili/utils/num_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:readmore/readmore.dart';

class VideoInfoPanel extends StatelessWidget {
  final UserCardInfo user;
  final VideoItem video;
  final VideoOnlinePeople count;
  const VideoInfoPanel({
    super.key,
    required this.user,
    required this.video,
    required this.count,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        //up主相关信息
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                CircleAvatar(
                  backgroundImage: CachedNetworkImageProvider(user.card.face),
                ),
                10.horizontalSpace,
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      user.card.name,
                      style: TextStyle(
                        fontSize: 12.sp,
                        color: Theme.of(context).colorScheme.outline,
                      ),
                    ),
                    2.verticalSpace,
                    Row(
                      children: [
                        Text(
                          "${NumUtils.int2Num(user.follower)}粉丝",
                          style: TextStyle(
                            fontSize: 8.sp,
                            color: Theme.of(context).colorScheme.outline,
                          ),
                        ),
                        5.horizontalSpace,
                        Text(
                          "${NumUtils.int2Num(user.archiveCount)}视频",
                          style: TextStyle(
                            fontSize: 8.sp,
                            color: Theme.of(context).colorScheme.outline,
                          ),
                        ),
                      ],
                    )
                  ],
                )
              ],
            ),
            TextButton(
              onPressed: () {},
              style: TextButton.styleFrom(
                padding: const EdgeInsets.fromLTRB(15, 0, 15, 0),
                foregroundColor: Theme.of(context).colorScheme.outline,
                backgroundColor: Theme.of(context).colorScheme.onInverseSurface,
              ),
              child: user.following ? const Text("已关注") : const Text("关注"),
            ),
          ],
        ),
        3.verticalSpace,
        //视频标题
        ReadMoreText(
          video.title,
          trimLines: 2,
          trimLength: 50,
          trimCollapsedText: "展开",
          trimExpandedText: "收起",
          colorClickableText: Theme.of(context).colorScheme.primary,
        ),
        3.verticalSpace,
        //视频简介、分区...
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Icon(
              Icons.play_circle_outline_rounded,
              color: Colors.grey,
              size: 13,
            ),
            const SizedBox(
              width: 2,
            ),
            Text(
              NumUtils.int2Num(video.stat.view),
              style: const TextStyle(fontSize: 9, color: Colors.grey),
            ),
            const SizedBox(
              width: 7,
            ),
            const Icon(
              Icons.subtitles_outlined,
              color: Colors.grey,
              size: 13,
            ),
            const SizedBox(
              width: 2,
            ),
            Text(
              NumUtils.int2Num(video.stat.danmaku),
              style: const TextStyle(fontSize: 9, color: Colors.grey),
            ),
            const SizedBox(
              width: 5,
            ),
            Text(
              NumUtils.dateFormat(video.pubdate, formatType: 'detail'),
              style: const TextStyle(fontSize: 9, color: Colors.grey),
            ),
            const SizedBox(
              width: 10,
            ),
            const Icon(
              Icons.group_rounded,
              color: Colors.grey,
              size: 13,
            ),
            const SizedBox(
              width: 2,
            ),
            Text(
              "${count.count}人正在看",
              style: const TextStyle(fontSize: 9, color: Colors.grey),
            ),
          ],
        )
        //单视频推荐相关视频
      ],
    );
  }
}
