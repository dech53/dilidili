// 转发
import 'package:dilidili/common/widgets/network_img_layer.dart';
import 'package:dilidili/pages/moments/widgets/additional_panel.dart';
import 'package:dilidili/pages/moments/widgets/article_panel.dart';
import 'package:dilidili/pages/moments/widgets/live_panel.dart';
import 'package:dilidili/pages/moments/widgets/live_rcmd_panel.dart';
import 'package:dilidili/pages/moments/widgets/pic_panel.dart';
import 'package:dilidili/pages/moments/widgets/rich_node_panel.dart';
import 'package:dilidili/pages/moments/widgets/video_panel.dart';
import 'package:dilidili/utils/num_utils.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';

Widget forWard(item, context, ctr, source, {floor = 1}) {
  TextStyle authorStyle =
      TextStyle(color: Theme.of(context).colorScheme.primary);
  switch (item.type) {
    case 'DYNAMIC_TYPE_DRAW':
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
                      fontSize:
                          Theme.of(context).textTheme.labelSmall!.fontSize),
                ),
              ],
            ),
            const SizedBox(height: 2),
            Text.rich(
              richNode(item, context),
              maxLines: source == 'detail' && floor != 2 ? 999 : 4,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 4),
          ],
          Padding(
            padding: floor == 2
                ? EdgeInsets.zero
                : const EdgeInsets.only(left: 12, right: 12),
            child: picWidget(item, context, floor),
          ),
        ],
      );
    case 'DYNAMIC_TYPE_AV':
      return videoSeasonWidget(item, context, 'archive', floor: floor);
    case 'DYNAMIC_TYPE_ARTICLE':
      return articlePanel(item, context, floor: floor);
    case 'DYNAMIC_TYPE_FORWARD':
      return InkWell(
        onTap: () => ctr.pushDetail(item.orig, floor + 1),
        child: Container(
          padding:
              const EdgeInsets.only(left: 15, top: 10, right: 15, bottom: 8),
          color: Theme.of(context).dividerColor.withOpacity(0.08),
          child: forWard(item.orig, context, ctr, source, floor: floor + 1),
        ),
      );
    case 'DYNAMIC_TYPE_LIVE_RCMD':
      return liveRcmdPanel(item, context, floor: floor);
    case 'DYNAMIC_TYPE_LIVE':
      return livePanel(item, context, floor: floor);
    case 'DYNAMIC_TYPE_UGC_SEASON':
      return videoSeasonWidget(item, context, 'ugcSeason');
    case 'DYNAMIC_TYPE_WORD':
      return floor == 2
          ? Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
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
                          fontSize:
                              Theme.of(context).textTheme.labelSmall!.fontSize),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text.rich(
                  richNode(item, context),
                  maxLines: source == 'detail' && floor != 2 ? 999 : 4,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            )
          : item.modules.moduleDynamic.additional != null
              ? addWidget(
                  item,
                  context,
                  item.modules.moduleDynamic.additional.type,
                  floor: floor,
                )
              : const SizedBox(height: 0);
    case 'DYNAMIC_TYPE_PGC':
      return videoSeasonWidget(item, context, 'pgc', floor: floor);
    case 'DYNAMIC_TYPE_PGC_UNION':
      return videoSeasonWidget(item, context, 'pgc', floor: floor);
    case 'DYNAMIC_TYPE_NONE':
      return Row(
        children: [
          const Icon(
            FontAwesomeIcons.ghost,
            size: 14,
          ),
          const SizedBox(width: 4),
          Text(item.modules.moduleDynamic.major.none.tips)
        ],
      );
    case 'DYNAMIC_TYPE_COURSES_SEASON':
      return Row(
        children: [
          Expanded(
            child: Text(
              "课堂💪：${item.modules.moduleDynamic.major.courses['title']}",
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          )
        ],
      );
    case 'DYNAMIC_TYPE_COMMON_SQUARE':
      return Padding(
        padding: const EdgeInsets.only(top: 8),
        child: InkWell(
          onTap: () {
            Get.toNamed('/webview', parameters: {
              'url': item.modules.moduleDynamic.major.common['jump_url'],
              'type': 'url',
              'pageTitle': item.modules.moduleDynamic.major.common['title']
            });
          },
          child: Container(
            width: double.infinity,
            padding:
                const EdgeInsets.only(left: 12, top: 10, right: 12, bottom: 10),
            color: Theme.of(context).dividerColor.withOpacity(0.08),
            child: Row(
              children: [
                NetworkImgLayer(
                  width: 45,
                  height: 45,
                  src: item.modules.moduleDynamic.major.common['cover'],
                ),
                const SizedBox(width: 10),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item.modules.moduleDynamic.major.common['title'],
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.primary,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 2),
                    Text(
                      item.modules.moduleDynamic.major.common['desc'],
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.outline,
                        fontSize:
                            Theme.of(context).textTheme.labelMedium!.fontSize,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                )
              ],
            ),
            // TextButton(onPressed: () {}, child: Text('123'))
          ),
        ),
      );
    case 'DYNAMIC_TYPE_MUSIC':
      final Map music = item.modules.moduleDynamic.major.music;
      return Padding(
        padding: const EdgeInsets.only(top: 8),
        child: InkWell(
          onTap: () {
            Get.toNamed('/webview', parameters: {
              'url': "https:${music['jump_url']}",
              'type': 'url',
              'pageTitle': music['title']
            });
          },
          child: Container(
            width: double.infinity,
            padding:
                const EdgeInsets.only(left: 12, top: 10, right: 12, bottom: 10),
            color: Theme.of(context).dividerColor.withOpacity(0.08),
            child: Row(
              children: [
                NetworkImgLayer(
                  width: 45,
                  height: 45,
                  src: music['cover'],
                ),
                const SizedBox(width: 10),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      music['title'],
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.primary,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 2),
                    Text(
                      music['label'],
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.outline,
                        fontSize:
                            Theme.of(context).textTheme.labelMedium!.fontSize,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                )
              ],
            ),
            // TextButton(onPressed: () {}, child: Text('123'))
          ),
        ),
      );
    default:
      return const SizedBox(
        width: double.infinity,
        child: Text('🙏 暂未支持的类型，请联系开发者反馈 '),
      );
  }
}
