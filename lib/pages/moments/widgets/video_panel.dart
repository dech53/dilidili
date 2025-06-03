// 视频or合集
import 'package:dilidili/common/constants.dart';
import 'package:dilidili/common/widgets/badge.dart';
import 'package:dilidili/common/widgets/network_img_layer.dart';
import 'package:dilidili/utils/num_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import 'rich_node_panel.dart';

Widget videoSeasonWidget(item, context, type, {floor = 1}) {
  TextStyle authorStyle =
      TextStyle(color: Theme.of(context).colorScheme.primary);
  Map<dynamic, dynamic> dynamicProperty = {
    'ugcSeason': item.modules.moduleDynamic.major.ugcSeason,
    'archive': item.modules.moduleDynamic.major.archive,
    'pgc': item.modules.moduleDynamic.major.pgc
  };
  dynamic content = dynamicProperty[type];

  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    mainAxisAlignment: MainAxisAlignment.start,
    children: [
      if (floor == 2) ...[
        Row(
          children: [
            GestureDetector(
              onTap: () => Get.toNamed(
                  '/member?mid=${item.modules.moduleAuthor.mid}',
                  arguments: {'face': item.modules.moduleAuthor.face}),
              child: Text(
                item.modules.moduleAuthor.type == null
                    ? '@${item.modules.moduleAuthor.name}'
                    : item.modules.moduleAuthor.name,
                style: authorStyle,
              ),
            ),
            const SizedBox(width: 6),
            Text(
              item.modules.moduleAuthor.pubTs != null
                  ? NumUtils.dateFormat(item.modules.moduleAuthor.pubTs)
                  : item.modules.moduleAuthor.pubTime,
              style: TextStyle(
                  color: Theme.of(context).colorScheme.outline,
                  fontSize: Theme.of(context).textTheme.labelSmall!.fontSize),
            ),
          ],
        ),
        const SizedBox(height: 6),
      ],
      if (floor == 2 && item.modules.moduleDynamic.desc != null) ...[
        Text.rich(richNode(item, context)),
        const SizedBox(height: 6),
      ],
      Padding(
        padding: floor == 1
            ? const EdgeInsets.only(left: 12, right: 12)
            : EdgeInsets.zero,
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
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8.r),
                    child: AspectRatio(
                      aspectRatio: StyleString.aspectRatio,
                      child: LayoutBuilder(
                        builder: (BuildContext context,
                            BoxConstraints boxConstraints) {
                          return Stack(
                            children: [
                              NetworkImgLayer(
                                type: floor == 1 ? 'emote' : null,
                                width: width,
                                height: width / StyleString.aspectRatio,
                                src: content.cover,
                              ),
                              if (content.badge != null &&
                                  content.badge['text'] != null)
                                PBadge(
                                  text: content.badge['text'],
                                  top: 8.0,
                                  right: 10.0,
                                  bottom: null,
                                  left: null,
                                ),
                              if (content.durationText != null)
                                PBadge(
                                  text: content.durationText,
                                  top: null,
                                  type: 'gray',
                                  right: 10.0,
                                  bottom: 8.0,
                                  left: null,
                                ),
                            ],
                          );
                        },
                      ),
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(10, 0, 6, 0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            content.title,
                            maxLines: 3,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(fontSize: 13.sp),
                          ),
                          6.verticalSpace,
                          Row(
                            children: [
                              Text(
                                content.stat.play + '次围观',
                                style: TextStyle(
                                  fontSize: Theme.of(context)
                                      .textTheme
                                      .labelMedium!
                                      .fontSize,
                                  color: Theme.of(context).colorScheme.outline,
                                ),
                              ),
                              const SizedBox(width: 10),
                              Text(
                                content.stat.danmaku + '条弹幕',
                                style: TextStyle(
                                  fontSize: Theme.of(context)
                                      .textTheme
                                      .labelMedium!
                                      .fontSize,
                                  color: Theme.of(context).colorScheme.outline,
                                ),
                              )
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      )
    ],
  );
}
