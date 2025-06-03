import 'package:dilidili/common/constants.dart';
import 'package:dilidili/common/widgets/badge.dart';
import 'package:dilidili/common/widgets/network_img_layer.dart';
import 'package:dilidili/model/dynamics/result.dart';
import 'package:dilidili/pages/moments/controller.dart';
import 'package:dilidili/utils/num_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import 'rich_node_panel.dart';

final MomentsController _momentsController = Get.put(MomentsController());
Widget liveRcmdPanel(item, context, {floor = 1}) {
  TextStyle authorStyle =
      TextStyle(color: Theme.of(context).colorScheme.primary);
  DynamicLiveModel liveRcmd = item.modules.moduleDynamic.major.liveRcmd;
  int liveStatus = liveRcmd.liveStatus!;
  Map watchedShow = liveRcmd.watchedShow!;
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      if (floor == 2) ...[
        Row(
          children: [
            GestureDetector(
              onTap: () => Get.toNamed(
                  '/member?mid=${item.modules.moduleAuthor.mid}',
                  arguments: {'face': item.modules.moduleAuthor.face}),
              child: Text(
                '@${item.modules.moduleAuthor.name}',
                style: authorStyle,
              ),
            ),
            const SizedBox(width: 6),
            Text(
              NumUtils.dateFormat(item.modules.moduleAuthor.pubTs),
              style: TextStyle(
                  color: Theme.of(context).colorScheme.outline,
                  fontSize: Theme.of(context).textTheme.labelSmall!.fontSize),
            ),
          ],
        ),
      ],
      const SizedBox(height: 4),
      if (item.modules.moduleDynamic.topic != null) ...[
        Padding(
          padding: floor == 2
              ? EdgeInsets.zero
              : const EdgeInsets.only(left: 12, right: 12),
          child: GestureDetector(
            child: Text(
              '#${item.modules.moduleDynamic.topic.name}',
              style: authorStyle,
            ),
          ),
        ),
        const SizedBox(height: 6),
      ],
      if (floor == 2 && item.modules.moduleDynamic.desc != null) ...[
        Text.rich(richNode(item, context)),
        const SizedBox(height: 6),
      ],
      GestureDetector(
        onTap: () {},
        child: Padding(
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
                                Hero(
                                  tag: liveRcmd.roomId.toString(),
                                  child: NetworkImgLayer(
                                    type: floor == 1 ? 'emote' : null,
                                    width: width,
                                    height: width / StyleString.aspectRatio,
                                    src: item.modules.moduleDynamic.major
                                        .liveRcmd.cover,
                                  ),
                                ),
                                PBadge(
                                  text: watchedShow['text_large'],
                                  top: 6,
                                  right: 56,
                                  bottom: null,
                                  left: null,
                                  type: 'gray',
                                ),
                                PBadge(
                                  text: liveStatus == 1 ? '直播中' : '直播结束',
                                  top: 6,
                                  right: 6,
                                  bottom: null,
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
                              item.modules.moduleDynamic.major.liveRcmd.title,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            6.verticalSpace,
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text(
                                  item.modules.moduleDynamic.major.liveRcmd
                                      .areaName,
                                  style: TextStyle(
                                    fontSize: Theme.of(context)
                                        .textTheme
                                        .labelMedium!
                                        .fontSize,
                                    color:
                                        Theme.of(context).colorScheme.outline,
                                  ),
                                ),
                                const SizedBox(width: 10),
                                Text(
                                  watchedShow['text_large'],
                                  style: TextStyle(
                                    fontSize: Theme.of(context)
                                        .textTheme
                                        .labelMedium!
                                        .fontSize,
                                    color:
                                        Theme.of(context).colorScheme.outline,
                                  ),
                                ),
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
        ),
      )
    ],
  );
}
