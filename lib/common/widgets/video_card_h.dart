import 'package:dilidili/common/constants.dart';
import 'package:dilidili/common/widgets/badge.dart';
import 'package:dilidili/common/widgets/network_img_layer.dart';
import 'package:dilidili/http/search.dart';
import 'package:dilidili/utils/string_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
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
    String type = 'video';
    try {
      type = videoItem.type;
    } catch (_) {}
    return InkWell(
      onTap: () async {
        if (type == 'ketang') {
          SmartDialog.showToast('课堂视频暂不支持播放');
          return;
        }
        if (enableTap) {
          final int cid =
              videoItem.cid ?? await SearchHttp.ab2c(aid: aid, bvid: bvid);
          Get.toNamed(
            '/video/bvid=${videoItem.bvid}',
            arguments: {
              'heroTag': StringUtils.makeHeroTag(videoItem.aid),
              'bvid': videoItem.bvid,
              'cid': cid.toString(),
            },
          );
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
                  AspectRatio(
                    aspectRatio: StyleString.aspectRatio,
                    child: LayoutBuilder(builder:
                        (BuildContext context, BoxConstraints boxConstraints) {
                      final double maxWidth = boxConstraints.maxWidth;
                      final double maxHeight = boxConstraints.maxHeight;
                      return Stack(
                        children: [
                          NetworkImgLayer(
                            src: videoItem.pic as String,
                            width: maxWidth,
                            height: maxHeight,
                          ),
                          if (videoItem.duration != 0)
                            PBadge(
                              text: NumUtils.int2time(videoItem.duration!),
                              right: 6.0,
                              bottom: 6.0,
                              type: 'gray',
                            ),
                          if (type != 'video')
                            PBadge(
                              text: type,
                              left: 6.0,
                              bottom: 6.0,
                              type: 'primary',
                            ),
                        ],
                      );
                    }),
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
                Icon(
                  Icons.play_circle_outline_rounded,
                  size: 13,
                  color: Theme.of(context).colorScheme.outline,
                ),
                1.horizontalSpace,
                Text(
                  NumUtils.int2Num(videoItem.stat.view as int),
                  style: TextStyle(
                    fontSize: 9,
                    color: Theme.of(context).colorScheme.outline,
                  ),
                ),
                8.horizontalSpace,
                Icon(
                  Icons.subtitles_outlined,
                  size: 13,
                  color: Theme.of(context).colorScheme.outline,
                ),
                1.horizontalSpace,
                Text(
                  NumUtils.int2Num(videoItem.stat.danmaku as int),
                  style: TextStyle(
                    fontSize: 9,
                    color: Theme.of(context).colorScheme.outline,
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
