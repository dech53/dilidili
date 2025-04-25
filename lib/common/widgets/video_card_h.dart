import 'package:cached_network_image/cached_network_image.dart';
import 'package:dilidili/common/constants.dart';
import 'package:dilidili/http/search.dart';
import 'package:dilidili/utils/string_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../utils/num_utils.dart';

class VideoCardH extends StatelessWidget {
  const VideoCardH({
    required this.enableTap,
    super.key,
    required this.videoItem,
  });
  final videoItem;
  final bool enableTap;
  @override
  Widget build(BuildContext context) {
    final int aid = videoItem.aid;
    final String bvid = videoItem.bvid;
    return InkWell(
      onTap: () async {
        if (enableTap) {
          final int cid =
              videoItem.cid ?? await SearchHttp.ab2c(aid: aid, bvid: bvid);
          Get.toNamed(
              '/video?bvid=${videoItem.bvid}&cid=${cid}&mid=${videoItem.owner.mid}',
              arguments: {'heroTag': StringUtils.makeHeroTag(videoItem.aid)});
        }
      },
      child: Padding(
        padding: const EdgeInsets.fromLTRB(10, 5, 10, 5),
        child: LayoutBuilder(
          builder: (BuildContext context, BoxConstraints boxConstraints) {
            final double width = (boxConstraints.maxWidth -
                    StyleString.cardSpace *
                        6 /
                        MediaQuery.textScalerOf(context).scale(1.0)) /
                2;
            return Container(
              constraints: const BoxConstraints(minHeight: 88),
              height: width / StyleString.aspectRatio,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Stack(
                    children: [
                      AspectRatio(
                        aspectRatio: 16 / 9,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(5.r),
                          child: CachedNetworkImage(
                            fit: BoxFit.cover,
                            imageUrl: videoItem.pic!
                                .replaceFirst("http://", "https://"),
                            httpHeaders: const {},
                          ),
                        ),
                      ),
                      Positioned(
                        right: 3.0,
                        bottom: 3.0,
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(3.r),
                            color: Colors.black.withValues(alpha: 0.3),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(1.5),
                            child: Text(
                              NumUtils.int2time(videoItem.duration!),
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
                  VideoContent(videoItem: videoItem),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}

class VideoContent extends StatelessWidget {
  const VideoContent({super.key, required this.videoItem});
  final videoItem;
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(10, 0, 6, 0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              videoItem.title as String,
              textAlign: TextAlign.start,
              style: const TextStyle(
                fontWeight: FontWeight.w500,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            const Spacer(),
            Text(
              NumUtils.dateFormat(videoItem.pubdate!),
              style: TextStyle(
                  fontSize: 11, color: Theme.of(context).colorScheme.outline),
            ),
            Row(
              children: [
                Text(
                  videoItem.owner.name as String,
                  style: TextStyle(
                    fontSize: Theme.of(context).textTheme.labelMedium!.fontSize,
                    color: Theme.of(context).colorScheme.outline,
                  ),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Icon(
                  Icons.play_circle_outline_rounded,
                  size: 13,
                ),
                1.horizontalSpace,
                Text(
                  NumUtils.int2Num(videoItem.stat.view as int),
                  style: const TextStyle(fontSize: 9, color: Colors.black),
                ),
                8.horizontalSpace,
                const Icon(
                  Icons.subtitles_outlined,
                  size: 13,
                ),
                1.horizontalSpace,
                Text(
                  NumUtils.int2Num(videoItem.stat.danmaku as int),
                  style: const TextStyle(fontSize: 9, color: Colors.black),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
