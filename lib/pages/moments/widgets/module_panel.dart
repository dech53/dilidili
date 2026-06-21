import 'package:dilidili/common/widgets/badge.dart';
import 'package:dilidili/common/widgets/network_img_layer.dart';
import 'package:dilidili/model/dynamics/result.dart';
import 'package:dilidili/pages/moments/widgets/dynamic_forward_panel.dart';
import 'package:dilidili/pages/moments/widgets/dynamic_live_panel.dart';
import 'package:dilidili/pages/moments/widgets/dynamic_video_panel.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

Widget noneWidget(ThemeData theme, String? tips) {
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 12),
    child: Row(
      children: [
        Icon(Icons.error_outline, size: 18, color: theme.colorScheme.outline),
        const SizedBox(width: 5),
        Text(
          tips ?? '已失效',
          style: TextStyle(color: theme.colorScheme.outline),
        ),
      ],
    ),
  );
}

Widget modulePanel(
  BuildContext context, {
  required int floor,
  required ThemeData theme,
  required dynamic item,
  required bool isDetail,
}) {
  final moduleDynamic = item.modules?.moduleDynamic;
  final DynamicMajorModel? major = moduleDynamic?.major;

  if (major?.type == 'MAJOR_TYPE_NONE') {
    return noneWidget(theme, major?.none?.tips);
  }

  switch (item.type) {
    case 'DYNAMIC_TYPE_NONE':
      return noneWidget(theme, major?.none?.tips);
    case 'DYNAMIC_TYPE_DRAW':
    case 'DYNAMIC_TYPE_ARTICLE':
    case 'DYNAMIC_TYPE_WORD':
      return const SizedBox.shrink();
    case 'DYNAMIC_TYPE_AV':
    case 'DYNAMIC_TYPE_UGC_SEASON':
    case 'DYNAMIC_TYPE_PGC':
    case 'DYNAMIC_TYPE_PGC_UNION':
    case 'DYNAMIC_TYPE_COURSES_SEASON':
      return dynamicVideoSeasonWidget(
        context,
        theme: theme,
        item: item,
        floor: floor,
        isDetail: isDetail,
      );
    case 'DYNAMIC_TYPE_FORWARD':
      if (item.orig == null) {
        return noneWidget(theme, '源动态已失效');
      }
      return dynamicForwardPanel(
        context,
        theme: theme,
        orig: item.orig,
        isDetail: isDetail,
        floor: floor + 1,
      );
    case 'DYNAMIC_TYPE_LIVE_RCMD':
      return dynamicLiveRcmdPanel(
        context,
        theme: theme,
        item: item,
        floor: floor,
        isDetail: isDetail,
      );
    case 'DYNAMIC_TYPE_LIVE':
      return dynamicLivePanel(
        context,
        theme: theme,
        item: item,
        floor: floor,
        isDetail: isDetail,
      );
    case 'DYNAMIC_TYPE_COMMON_SQUARE':
      final Common? common = major?.commonInfo ?? major?.upowerCommon;
      final Map? commonMap = major?.common;
      final title = common?.title ?? commonMap?['title'];
      final desc = common?.desc ?? commonMap?['desc'];
      final cover = common?.cover ?? commonMap?['cover'];
      final jumpUrl = common?.jumpUrl ?? commonMap?['jump_url'];
      if (title == null && cover == null) return const SizedBox.shrink();
      return _simpleCard(
        context,
        theme: theme,
        floor: floor,
        cover: cover,
        title: title,
        desc: desc,
        jumpUrl: jumpUrl,
      );
    case 'DYNAMIC_TYPE_MUSIC':
      final Music? music = major?.musicInfo;
      final Map? musicMap = major?.music;
      return _simpleCard(
        context,
        theme: theme,
        floor: floor,
        cover: music?.cover ?? musicMap?['cover'],
        title: music?.title ?? musicMap?['title'],
        desc: music?.label ?? musicMap?['label'],
        jumpUrl: music?.jumpUrl ?? musicMap?['jump_url'],
        icon: Icons.music_note_rounded,
      );
    case 'DYNAMIC_TYPE_MEDIALIST':
      final Medialist? media = major?.medialist;
      if (media == null) return const SizedBox.shrink();
      return Padding(
        padding: floor == 1
            ? const EdgeInsets.symmetric(horizontal: 12)
            : EdgeInsets.zero,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (media.cover?.isNotEmpty == true)
              Stack(
                children: [
                  NetworkImgLayer(width: 180, height: 110, src: media.cover),
                  if (media.badge?.text != null)
                    PBadge(text: media.badge!.text, top: 6, right: 6),
                ],
              ),
            const SizedBox(width: 14),
            Expanded(
              child: SizedBox(
                height: 110,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      media.title ?? '',
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    const Spacer(),
                    if (media.subTitle?.isNotEmpty == true)
                      Text(
                        media.subTitle!,
                        style: TextStyle(color: theme.colorScheme.outline),
                      ),
                  ],
                ),
              ),
            ),
          ],
        ),
      );
    case 'DYNAMIC_TYPE_SUBSCRIPTION_NEW':
      final liveInfo = major?.subscriptionNew?.liveRcmd?.content?.livePlayInfo;
      if (liveInfo == null) return const SizedBox.shrink();
      return _simpleCard(
        context,
        theme: theme,
        floor: floor,
        cover: liveInfo.cover,
        title: liveInfo.title,
        desc: liveInfo.areaName,
        jumpUrl: null,
      );
    default:
      return Padding(
        padding: floor == 1
            ? const EdgeInsets.symmetric(horizontal: 12)
            : EdgeInsets.zero,
        child: Text(
          '暂未支持的类型: ${item.type}',
          style: TextStyle(color: theme.colorScheme.outline),
        ),
      );
  }
}

Widget _simpleCard(
  BuildContext context, {
  required ThemeData theme,
  required int floor,
  required String? cover,
  required String? title,
  required String? desc,
  required String? jumpUrl,
  IconData? icon,
}) {
  final borderRadius = floor == 1 ? null : BorderRadius.circular(8);
  return Padding(
    padding: floor == 1
        ? const EdgeInsets.symmetric(horizontal: 12)
        : EdgeInsets.zero,
    child: Material(
      color: floor == 1
          ? theme.dividerColor.withOpacity(0.08)
          : theme.colorScheme.surface,
      borderRadius: borderRadius,
      child: InkWell(
        borderRadius: borderRadius,
        onTap: jumpUrl == null || jumpUrl.isEmpty
            ? null
            : () => Get.toNamed('/webview', parameters: {
                  'url': jumpUrl,
                  'type': 'url',
                  'pageTitle': title ?? '',
                }),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          child: Row(
            children: [
              if (cover?.isNotEmpty == true)
                NetworkImgLayer(width: 45, height: 45, src: cover)
              else
                Container(
                  width: 45,
                  height: 45,
                  decoration: BoxDecoration(
                    color: theme.colorScheme.surface,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(icon ?? Icons.link,
                      color: theme.colorScheme.primary),
                ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title ?? '',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(color: theme.colorScheme.primary),
                    ),
                    if (desc?.isNotEmpty == true) ...[
                      const SizedBox(height: 2),
                      Text(
                        desc!,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: theme.colorScheme.outline,
                          fontSize: theme.textTheme.labelMedium?.fontSize,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    ),
  );
}
