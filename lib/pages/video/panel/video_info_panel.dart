import 'package:cached_network_image/cached_network_image.dart';
import 'package:dilidili/model/nav_user_info.dart';
import 'package:dilidili/model/video/related_video.dart';
import 'package:dilidili/model/video/video_basic_info.dart';
import 'package:dilidili/model/video_play_url.dart';
import 'package:dilidili/utils/num_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:line_icons/line_icons.dart';

class VideoInfoPanel extends StatelessWidget {
  final UserCardInfo user;
  final VideoOnlinePeople count;
  final VideoDetailData videoDetailData;
  final List<RelatedVideoItem> relatedVideo;
  final Function(String bvid, int cid, int mid)? itemTap;
  const VideoInfoPanel({
    super.key,
    required this.user,
    required this.count,
    required this.videoDetailData,
    required this.relatedVideo,
    required this.itemTap,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        mainAxisSize: MainAxisSize.max,
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
                  backgroundColor:
                      Theme.of(context).colorScheme.onInverseSurface,
                ),
                child: user.following ? const Text("已关注") : const Text("关注"),
              ),
            ],
          ),
          5.verticalSpace,
          //视频标题
          Text(
            videoDetailData.title!,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          5.verticalSpace,
          //视频简介、分区...
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Icon(
                Icons.play_circle_outline_rounded,
                color: Colors.grey,
                size: 14,
              ),
              const SizedBox(
                width: 3,
              ),
              Text(
                NumUtils.int2Num(videoDetailData.stat!.view),
                style: const TextStyle(fontSize: 11, color: Colors.grey),
              ),
              const SizedBox(
                width: 8,
              ),
              const Icon(
                Icons.subtitles_outlined,
                color: Colors.grey,
                size: 14,
              ),
              const SizedBox(
                width: 3,
              ),
              Text(
                NumUtils.int2Num(videoDetailData.stat!.danmaku),
                style: const TextStyle(fontSize: 11, color: Colors.grey),
              ),
              const SizedBox(
                width: 8,
              ),
              Text(
                NumUtils.dateFormat(videoDetailData.pubdate,
                    formatType: 'detail'),
                style: const TextStyle(fontSize: 11, color: Colors.grey),
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
                style: const TextStyle(fontSize: 11, color: Colors.grey),
              ),
            ],
          ),
          if (videoDetailData.argueInfo != null &&
              videoDetailData.argueInfo?.argue_msg != "")
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                2.verticalSpace,
                Row(
                  children: [
                    const Icon(
                      LineIcons.exclamationCircle,
                      color: Colors.grey,
                      size: 15,
                    ),
                    2.horizontalSpace,
                    Text(
                      videoDetailData.argueInfo!.argue_msg!,
                      style: const TextStyle(fontSize: 11, color: Colors.grey),
                    ),
                  ],
                ),
              ],
            ),
          2.verticalSpace,
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                videoDetailData.bvid!,
                style: const TextStyle(fontSize: 11, color: Colors.grey),
              ),
              if (videoDetailData.desc != null)
                Text(
                  videoDetailData.desc!.trim(),
                  style: const TextStyle(fontSize: 11, color: Colors.grey),
                ),
            ],
          ),
          //单视频推荐相关视频
          3.verticalSpace,
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: relatedVideo.length,
            itemBuilder: (context, index) {
              return GestureDetector(
                onTap: () {
                  itemTap?.call(
                    relatedVideo[index].bvid!,
                    relatedVideo[index].cid!,
                    relatedVideo[index].owner!.mid!,
                  );
                },
                child: SizedBox(
                  width: ScreenUtil().screenWidth,
                  child: Column(
                    children: [
                      10.verticalSpace,
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Container(
                            width: 160.w,
                            height: 90.w,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(4.r),
                            ),
                            child: Stack(
                              children: [
                                AspectRatio(
                                  aspectRatio: 16 / 9,
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(5.r),
                                    child: CachedNetworkImage(
                                      fit: BoxFit.cover,
                                      imageUrl: relatedVideo[index]
                                          .pic!
                                          .replaceFirst("http://", "https://"),
                                      httpHeaders: const {},
                                    ),
                                  ),
                                ),
                                Positioned(
                                  right: 1.0,
                                  bottom: 1.0,
                                  child: Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(3.r),
                                      color:
                                          Colors.black.withValues(alpha: 0.3),
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.all(1.5),
                                      child: Text(
                                        NumUtils.int2time(
                                            relatedVideo[index].duration!),
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
                          ),
                          7.horizontalSpace,
                          Expanded(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  relatedVideo[index].title!,
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                2.verticalSpace,
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    const Icon(
                                      LineIcons.user,
                                      size: 16,
                                      color: Colors.grey,
                                    ),
                                    2.horizontalSpace,
                                    Text(
                                      relatedVideo[index].owner!.name!,
                                      style: const TextStyle(
                                          fontSize: 11, color: Colors.grey),
                                    ),
                                  ],
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    const Icon(
                                      Icons.play_circle_outline_rounded,
                                      color: Colors.grey,
                                      size: 14,
                                    ),
                                    const SizedBox(
                                      width: 3,
                                    ),
                                    Text(
                                      NumUtils.int2Num(
                                        relatedVideo[index].stat!['view']!,
                                      ),
                                      style: const TextStyle(
                                          fontSize: 11, color: Colors.grey),
                                    ),
                                    const SizedBox(
                                      width: 8,
                                    ),
                                    const Icon(
                                      Icons.subtitles_outlined,
                                      color: Colors.grey,
                                      size: 14,
                                    ),
                                    const SizedBox(
                                      width: 3,
                                    ),
                                    Text(
                                      NumUtils.int2Num(
                                        relatedVideo[index].stat!['danmaku']!,
                                      ),
                                      style: const TextStyle(
                                          fontSize: 11, color: Colors.grey),
                                    ),
                                  ],
                                )
                              ],
                            ),
                          )
                        ],
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
