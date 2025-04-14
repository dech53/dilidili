import 'package:cached_network_image/cached_network_image.dart';
import 'package:dilidili/common/constants.dart';
import 'package:dilidili/model/live/rcmd_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

// 视频卡片 - 垂直布局
class LiveCardV extends StatelessWidget {
  final RecommendLiveItem liveItem;
  final int crossAxisCount;

  const LiveCardV({
    Key? key,
    required this.liveItem,
    required this.crossAxisCount,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(16),
      onTap: () async {},
      child: Column(
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.all(StyleString.imgRadius),
            child: AspectRatio(
              aspectRatio: StyleString.aspectRatio,
              child: LayoutBuilder(builder: (context, boxConstraints) {
                return Stack(
                  children: [
                    AspectRatio(
                      aspectRatio: 16 / 9,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(5.r),
                        child: CachedNetworkImage(
                          fit: BoxFit.cover,
                          imageUrl: liveItem.cover!
                              .replaceFirst("http://", "https://"),
                          httpHeaders: const {},
                        ),
                      ),
                    ),
                    if (crossAxisCount != 1)
                      Positioned(
                        left: 0,
                        right: 0,
                        bottom: 0,
                        child: AnimatedOpacity(
                          opacity: 1,
                          duration: const Duration(milliseconds: 200),
                          child: VideoStat(
                            liveItem: liveItem,
                          ),
                        ),
                      ),
                  ],
                );
              }),
            ),
          ),
          LiveContent(liveItem: liveItem, crossAxisCount: crossAxisCount)
        ],
      ),
    );
  }
}

class LiveContent extends StatelessWidget {
  final dynamic liveItem;
  final int crossAxisCount;
  const LiveContent(
      {Key? key, required this.liveItem, required this.crossAxisCount})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: crossAxisCount == 1 ? 0 : 1,
      child: Padding(
        padding: crossAxisCount == 1
            ? const EdgeInsets.fromLTRB(9, 9, 9, 4)
            : const EdgeInsets.fromLTRB(5, 8, 5, 4),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              liveItem.title,
              textAlign: TextAlign.start,
              style: const TextStyle(
                fontWeight: FontWeight.w500,
                letterSpacing: 0.3,
              ),
              maxLines: crossAxisCount == 1 ? 1 : 2,
              overflow: TextOverflow.ellipsis,
            ),
            if (crossAxisCount == 1) const SizedBox(height: 4),
            Row(
              children: [
                Expanded(
                  child: Text(
                    liveItem.uname,
                    textAlign: TextAlign.start,
                    style: TextStyle(
                      fontSize:
                          Theme.of(context).textTheme.labelMedium!.fontSize,
                      color: Theme.of(context).colorScheme.outline,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                if (crossAxisCount == 1) ...[
                  Text(
                    ' • ${liveItem!.areaV2Name!}',
                    style: TextStyle(
                      fontSize:
                          Theme.of(context).textTheme.labelMedium!.fontSize,
                      color: Theme.of(context).colorScheme.outline,
                    ),
                  ),
                  Text(
                    ' • ${liveItem!.watchedShow!.textSmall!}人观看',
                    style: TextStyle(
                      fontSize:
                          Theme.of(context).textTheme.labelMedium!.fontSize,
                      color: Theme.of(context).colorScheme.outline,
                    ),
                  ),
                ]
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class VideoStat extends StatelessWidget {
  final RecommendLiveItem? liveItem;

  const VideoStat({
    Key? key,
    required this.liveItem,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      padding: const EdgeInsets.only(top: 26, left: 10, right: 10),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Colors.transparent,
            Colors.black54,
          ],
          tileMode: TileMode.mirror,
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            liveItem!.areaV2Name!,
            style: const TextStyle(fontSize: 11, color: Colors.white),
          ),
          Text(
            liveItem!.watchedShow!.textSmall!,
            style: const TextStyle(fontSize: 11, color: Colors.white),
          ),
        ],
      ),

      // child: RichText(
      //   maxLines: 1,
      //   textAlign: TextAlign.justify,
      //   softWrap: false,
      //   text: TextSpan(
      //     style: const TextStyle(fontSize: 11, color: Colors.white),
      //     children: [
      //       TextSpan(text: liveItem!.areaName!),
      //       TextSpan(text: liveItem!.watchedShow!['text_small']),
      //     ],
      //   ),
      // ),
    );
  }
}
