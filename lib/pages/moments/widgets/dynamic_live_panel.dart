import 'package:dilidili/common/constants.dart';
import 'package:dilidili/common/widgets/badge.dart';
import 'package:dilidili/common/widgets/network_img_layer.dart';
import 'package:dilidili/model/dynamics/result.dart';
import 'package:dilidili/pages/moments/controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

Widget dynamicLivePanel(
  BuildContext context, {
  required dynamic item,
  required int floor,
  required ThemeData theme,
  required bool isDetail,
}) {
  final DynamicLive2Model? live = item.modules?.moduleDynamic?.major?.live;
  if (live == null) {
    return const SizedBox.shrink();
  }
  final controller = Get.isRegistered<MomentsController>()
      ? Get.find<MomentsController>()
      : Get.put(MomentsController());
  final badgeText = live.badge?['text'] ?? live.badgeInfo?.text;

  return Padding(
    padding: floor == 1
        ? const EdgeInsets.symmetric(horizontal: 12)
        : EdgeInsets.zero,
    child: GestureDetector(
      onTap: () => controller.pushDetail(item, floor),
      behavior: HitTestBehavior.translucent,
      child: LayoutBuilder(
        builder: (context, constraints) {
          final coverWidth = (constraints.maxWidth - 10) * 0.42;
          final coverHeight = coverWidth / StyleString.aspectRatio;
          return ConstrainedBox(
            constraints: const BoxConstraints(minHeight: 88),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                NetworkImgLayer(
                  width: coverWidth,
                  height: coverHeight,
                  src: live.cover,
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        live.title ?? '',
                        maxLines: isDetail ? null : 2,
                        overflow: isDetail ? null : TextOverflow.ellipsis,
                      ),
                      if (live.descFirst?.isNotEmpty == true) ...[
                        const SizedBox(height: 4),
                        Text(
                          live.descFirst!,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            color: theme.colorScheme.outline,
                            fontSize: theme.textTheme.labelMedium?.fontSize,
                          ),
                        ),
                      ],
                      if (badgeText != null) ...[
                        const SizedBox(height: 4),
                        Text(
                          badgeText,
                          style: TextStyle(
                            fontSize: theme.textTheme.labelMedium?.fontSize,
                            color: live.liveState == 1
                                ? theme.colorScheme.primary
                                : theme.colorScheme.outline,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    ),
  );
}

Widget dynamicLiveRcmdPanel(
  BuildContext context, {
  required dynamic item,
  required int floor,
  required ThemeData theme,
  required bool isDetail,
}) {
  final DynamicLiveModel? live = item.modules?.moduleDynamic?.major?.liveRcmd;
  if (live == null) {
    return const SizedBox.shrink();
  }
  final controller = Get.isRegistered<MomentsController>()
      ? Get.find<MomentsController>()
      : Get.put(MomentsController());
  final watchedText = live.watchedShow?['text_large']?.toString();

  return Padding(
    padding: floor == 1
        ? const EdgeInsets.symmetric(horizontal: 12)
        : EdgeInsets.zero,
    child: GestureDetector(
      onTap: () => controller.pushDetail(item, floor),
      behavior: HitTestBehavior.translucent,
      child: LayoutBuilder(
        builder: (context, constraints) {
          final coverWidth =
              (constraints.maxWidth - StyleString.cardSpace * 2) / 2;
          final coverHeight = coverWidth / StyleString.aspectRatio;
          return ConstrainedBox(
            constraints: const BoxConstraints(minHeight: 88),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: SizedBox(
                    width: coverWidth,
                    height: coverHeight,
                    child: Stack(
                      children: [
                        Hero(
                          tag: live.roomId?.toString() ?? live.cover ?? '',
                          child: NetworkImgLayer(
                            type: floor == 1 ? 'emote' : null,
                            width: coverWidth,
                            height: coverHeight,
                            src: live.cover,
                            quality: 40,
                          ),
                        ),
                        Positioned(
                          top: 6,
                          right: 6,
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              if (watchedText?.isNotEmpty == true)
                                PBadge(
                                  text: watchedText,
                                  stack: 'normal',
                                  type: 'gray',
                                ),
                              PBadge(
                                text: live.liveStatus == 1 ? '直播中' : '直播结束',
                                stack: 'normal',
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        live.title ?? '',
                        maxLines: isDetail ? null : 2,
                        overflow: isDetail ? null : TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 6),
                      Wrap(
                        spacing: 10,
                        runSpacing: 4,
                        children: [
                          if (live.areaName?.isNotEmpty == true)
                            Text(
                              live.areaName!,
                              style: TextStyle(
                                fontSize: theme.textTheme.labelMedium?.fontSize,
                                color: theme.colorScheme.outline,
                              ),
                            ),
                          if (watchedText?.isNotEmpty == true)
                            Text(
                              watchedText!,
                              style: TextStyle(
                                fontSize: theme.textTheme.labelMedium?.fontSize,
                                color: theme.colorScheme.outline,
                              ),
                            ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    ),
  );
}
