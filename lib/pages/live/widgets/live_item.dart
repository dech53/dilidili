import 'package:cached_network_image/cached_network_image.dart';
import 'package:dilidili/common/constants.dart';
import 'package:dilidili/common/widgets/badge.dart';
import 'package:dilidili/model/live/rcmd_item.dart';
import 'package:dilidili/utils/string_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

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
    String heroTag = StringUtils.makeHeroTag(liveItem.roomid);
    return InkWell(
      borderRadius: BorderRadius.circular(16),
      onTap: () async {
        Get.toNamed('/liveRoom?roomid=${liveItem.roomid}',
            arguments: {'liveItem': liveItem, 'heroTag': heroTag});
      },
      child: Column(
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.all(StyleString.imgRadius),
            child: AspectRatio(
              aspectRatio: StyleString.aspectRatio,
              child: LayoutBuilder(
                builder: (context, boxConstraints) {
                  return Stack(
                    children: [
                      if (liveItem.cover != "" && liveItem.cover != null)
                        AspectRatio(
                          aspectRatio: 16 / 9,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(5.r),
                            child: CachedNetworkImage(
                              fit: BoxFit.cover,
                              imageUrl: liveItem.cover!
                                  .replaceFirst("http://", "https://"),
                            ),
                          ),
                        ),
                      if (crossAxisCount != 1) ...[
                        PBadge(
                          top: 6,
                          right: null,
                          bottom: null,
                          left: 6,
                          text: liveItem.areaV2Name,
                        ),
                        PBadge(
                          top: 6,
                          right: 6,
                          bottom: null,
                          left: null,
                          type: 'gray',
                          text: "${liveItem.watchedShow!.textSmall} 观看",
                        )
                      ]
                    ],
                  );
                },
              ),
            ),
          ),
          LiveContent(liveItem: liveItem, crossAxisCount: crossAxisCount),
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
    return Padding(
      padding: crossAxisCount == 1
          ? const EdgeInsets.fromLTRB(9, 0, 9, 0)
          : const EdgeInsets.fromLTRB(5, 0, 5, 0),
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
                    fontSize: Theme.of(context).textTheme.labelMedium!.fontSize,
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
                    fontSize: Theme.of(context).textTheme.labelMedium!.fontSize,
                    color: Theme.of(context).colorScheme.outline,
                  ),
                ),
                Text(
                  ' • ${liveItem!.watchedShow!.textSmall!}人观看',
                  style: TextStyle(
                    fontSize: Theme.of(context).textTheme.labelMedium!.fontSize,
                    color: Theme.of(context).colorScheme.outline,
                  ),
                ),
              ]
            ],
          ),
        ],
      ),
    );
  }
}
