import 'package:dilidili/common/constants.dart';
import 'package:dilidili/common/widgets/badge.dart';
import 'package:dilidili/common/widgets/network_img_layer.dart';
import 'package:dilidili/model/dynamics/result.dart';
import 'package:dilidili/pages/moments/controller.dart';
import 'package:dilidili/utils/num_utils.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

Widget dynamicVideoSeasonWidget(
  BuildContext context, {
  required dynamic item,
  required int floor,
  required ThemeData theme,
  required bool isDetail,
}) {
  final major = item.modules?.moduleDynamic?.major;
  final DynamicArchiveModel? video = switch (item.type) {
    'DYNAMIC_TYPE_AV' => major?.archive,
    'DYNAMIC_TYPE_UGC_SEASON' => major?.ugcSeason,
    'DYNAMIC_TYPE_PGC' || 'DYNAMIC_TYPE_PGC_UNION' => major?.pgc,
    'DYNAMIC_TYPE_COURSES_SEASON' => major?.coursesInfo,
    _ => null,
  };
  if (video == null) {
    return const SizedBox.shrink();
  }

  final controller = Get.isRegistered<MomentsController>()
      ? Get.find<MomentsController>()
      : Get.put(MomentsController());

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
          final cardHeight = coverHeight < 88 ? 88.0 : coverHeight;
          return SizedBox(
            height: cardHeight,
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
                        NetworkImgLayer(
                          type: floor == 1 ? 'emote' : null,
                          width: coverWidth,
                          height: coverHeight,
                          src: video.cover,
                          quality: 40,
                        ),
                        if (video.durationText?.isNotEmpty == true)
                          PBadge(
                            text: video.durationText,
                            type: 'gray',
                            right: 8,
                            bottom: 6,
                          ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(0, 0, 6, 0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        RichText(
                          maxLines: isDetail ? 3 : 2,
                          overflow: TextOverflow.ellipsis,
                          text: TextSpan(
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.bold,
                              color: theme.colorScheme.onSurface,
                            ),
                            children: [
                              if (video.badge?['text'] != null)
                                WidgetSpan(
                                  alignment: PlaceholderAlignment.middle,
                                  child: Padding(
                                    padding: const EdgeInsets.only(right: 3),
                                    child: PBadge(
                                      text: video.badge?['text'],
                                      stack: 'normal',
                                      type: 'line',
                                    ),
                                  ),
                                ),
                              TextSpan(text: video.title ?? ''),
                            ],
                          ),
                        ),
                        const SizedBox(height: 6),
                        Wrap(
                          spacing: 10,
                          runSpacing: 4,
                          children: [
                            if (video.stat?.play != null)
                              Text(
                                '${NumUtils.int2Num(video.stat?.play)}播放',
                                style: TextStyle(
                                  fontSize:
                                      theme.textTheme.labelMedium?.fontSize,
                                  color: theme.colorScheme.outline,
                                ),
                              ),
                            if (video.stat?.danmaku != null)
                              Text(
                                '${NumUtils.int2Num(video.stat?.danmaku)}弹幕',
                                style: TextStyle(
                                  fontSize:
                                      theme.textTheme.labelMedium?.fontSize,
                                  color: theme.colorScheme.outline,
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
  );
}
