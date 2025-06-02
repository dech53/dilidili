import 'package:cached_network_image/cached_network_image.dart';
import 'package:dilidili/common/constants.dart';
import 'package:dilidili/common/widgets/badge.dart';
import 'package:dilidili/utils/num_utils.dart';
import 'package:dilidili/utils/string_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

Widget searchLivePanel(BuildContext context, ctr, list) {
  return Padding(
    padding: const EdgeInsets.only(
        left: StyleString.safeSpace, right: StyleString.safeSpace),
    child: GridView.builder(
      primary: false,
      controller: ctr!.scrollController,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: StyleString.cardSpace + 2,
          mainAxisSpacing: StyleString.cardSpace + 3,
          mainAxisExtent:
              MediaQuery.sizeOf(context).width / 2 / StyleString.aspectRatio +
                  MediaQuery.textScalerOf(context).scale(66.0)),
      itemCount: list.length,
      itemBuilder: (context, index) {
        return LiveItem(liveItem: list![index]);
      },
    ),
  );
}

class LiveItem extends StatelessWidget {
  final dynamic liveItem;
  const LiveItem({Key? key, required this.liveItem}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    String heroTag = StringUtils.makeHeroTag(liveItem.roomid);
    return InkWell(
      onTap: () async {
        Get.toNamed('/liveRoom?roomid=${liveItem.roomid}',
            arguments: {'liveItem': liveItem, 'heroTag': heroTag});
      },
      onLongPress: () => {},
      child: Column(
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.all(StyleString.imgRadius),
            child: AspectRatio(
              aspectRatio: StyleString.aspectRatio,
              child: LayoutBuilder(builder: (context, boxConstraints) {
                double maxWidth = boxConstraints.maxWidth;
                double maxHeight = boxConstraints.maxHeight;
                return Stack(
                  children: [
                    ClipRRect(
                      clipBehavior: Clip.antiAlias,
                      borderRadius: BorderRadius.circular(5.r),
                      child: CachedNetworkImage(
                        fit: BoxFit.cover,
                        width: maxWidth,
                        height: maxHeight,
                        imageUrl: liveItem.cover.startsWith('//')
                            ? 'https:${liveItem.cover}'
                            : liveItem.cover,
                      ),
                    ),
                    PBadge(
                      left: 6,
                      right: null,
                      bottom: 6,
                      text: liveItem.cateName,
                    ),
                    PBadge(
                      type: 'gray',
                      left: null,
                      right: 6,
                      top: null,
                      bottom: 6,
                      text: "${NumUtils.int2Num(liveItem.online)} 围观",
                    ),
                  ],
                );
              }),
            ),
          ),
          LiveContent(liveItem: liveItem)
        ],
      ),
    );
  }
}

class LiveContent extends StatelessWidget {
  final dynamic liveItem;
  const LiveContent({Key? key, required this.liveItem}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(9, 8, 9, 6),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            RichText(
              text: TextSpan(
                children: [
                  for (var i in liveItem.titleList) ...[
                    TextSpan(
                      text: i['text'],
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                        letterSpacing: 0.3,
                        color: i['type'] == 'em'
                            ? Theme.of(context).colorScheme.primary
                            : Theme.of(context).colorScheme.onSurface,
                      ),
                    ),
                  ]
                ],
              ),
            ),
            SizedBox(
              width: double.infinity,
              child: Text(
                liveItem.uname,
                maxLines: 1,
                style: TextStyle(
                  fontSize: Theme.of(context).textTheme.labelMedium!.fontSize,
                  color: Theme.of(context).colorScheme.outline,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
