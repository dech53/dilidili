import 'package:dilidili/common/constants.dart';
import 'package:dilidili/common/widgets/badge.dart';
import 'package:dilidili/common/widgets/network_img_layer.dart';
import 'package:dilidili/model/bangumi/list.dart';
import 'package:dilidili/utils/string_utils.dart';
import 'package:flutter/material.dart';

class BangumiCardV extends StatelessWidget {
  const BangumiCardV({
    super.key,
    required this.bangumiItem,
  });

  final BangumiListItemModel bangumiItem;

  @override
  Widget build(BuildContext context) {
    String heroTag = StringUtils.makeHeroTag(bangumiItem.mediaId);
    return InkWell(
      borderRadius: const BorderRadius.all(
        StyleString.imgRadius,
      ),
      onTap: () {},
      onLongPress: () {},
      child: Column(
        children: [
          AspectRatio(
            aspectRatio: 0.75,
            child: LayoutBuilder(builder: (context, boxConstraints) {
              final double maxWidth = boxConstraints.maxWidth;
              final double maxHeight = boxConstraints.maxHeight;
              return Stack(
                children: [
                  Hero(
                    tag: heroTag,
                    child: NetworkImgLayer(
                      src: bangumiItem.cover,
                      width: maxWidth,
                      height: maxHeight,
                    ),
                  ),
                  if (bangumiItem.badge != null)
                    PBadge(
                        text: bangumiItem.badge,
                        top: 6,
                        right: 6,
                        bottom: null,
                        left: null),
                  if (bangumiItem.order != null)
                    PBadge(
                      text: bangumiItem.order,
                      top: null,
                      right: null,
                      bottom: 6,
                      left: 6,
                      type: 'gray',
                    ),
                ],
              );
            }),
          ),
          BangumiContent(bangumiItem: bangumiItem)
        ],
      ),
    );
  }
}

class BangumiContent extends StatelessWidget {
  const BangumiContent({super.key, required this.bangumiItem});
  // ignore: prefer_typing_uninitialized_variables
  final bangumiItem;
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(4, 5, 0, 3),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                    child: Text(
                  bangumiItem.title,
                  textAlign: TextAlign.start,
                  style: TextStyle(
                    fontSize: Theme.of(context).textTheme.labelMedium!.fontSize,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 0.3,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                )),
              ],
            ),
            const SizedBox(height: 1),
            if (bangumiItem.indexShow != null)
              Text(
                bangumiItem.indexShow,
                maxLines: 1,
                style: TextStyle(
                  fontSize: Theme.of(context).textTheme.labelMedium!.fontSize,
                  color: Theme.of(context).colorScheme.outline,
                ),
              ),
            if (bangumiItem.progress != null)
              Text(
                bangumiItem.progress,
                maxLines: 1,
                style: TextStyle(
                  fontSize: Theme.of(context).textTheme.labelMedium!.fontSize,
                  color: Theme.of(context).colorScheme.outline,
                ),
              ),
          ],
        ),
      ),
    );
  }
}
