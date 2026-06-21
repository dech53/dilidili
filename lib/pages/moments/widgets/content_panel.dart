import 'package:dilidili/pages/moments/widgets/dynamic_image_grid.dart';
import 'package:dilidili/pages/moments/widgets/rich_node_panel.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class Content extends StatelessWidget {
  const Content({
    super.key,
    this.item,
    this.source,
  });

  final dynamic item;
  final String? source;

  @override
  Widget build(BuildContext context) {
    return dynamicContent(
      context,
      theme: Theme.of(context),
      item: item,
      floor: 1,
      isDetail: source == 'detail',
    );
  }
}

Widget dynamicContent(
  BuildContext context, {
  required int floor,
  required ThemeData theme,
  required dynamic item,
  required bool isDetail,
}) {
  final moduleDynamic = item.modules?.moduleDynamic;
  final topic = moduleDynamic?.topic;
  final opusPics = moduleDynamic?.major?.opus?.pics ?? const [];
  final drawPics = moduleDynamic?.major?.draw?.items ?? const [];
  final pics = opusPics.isNotEmpty ? opusPics : drawPics;
  final hasText = _hasVisibleText(moduleDynamic?.desc?.text) ||
      _hasVisibleText(moduleDynamic?.major?.opus?.title) ||
      _hasVisibleText(moduleDynamic?.major?.opus?.summary?.text) ||
      (moduleDynamic?.desc?.richTextNodes?.isNotEmpty == true) ||
      (moduleDynamic?.major?.opus?.summary?.richTextNodes?.isNotEmpty == true);

  if (topic == null && !hasText && pics.isEmpty) {
    return const SizedBox.shrink();
  }

  return Padding(
    padding: floor == 1
        ? const EdgeInsets.fromLTRB(12, 0, 12, 6)
        : const EdgeInsets.only(bottom: 6),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (topic != null)
          GestureDetector(
            onTap: () => Get.toNamed(
              '/searchResult',
              parameters: {'keyword': topic.name ?? ''},
            ),
            child: Text.rich(
              TextSpan(
                children: [
                  WidgetSpan(
                    alignment: PlaceholderAlignment.middle,
                    child: Padding(
                      padding: const EdgeInsets.only(right: 4),
                      child: Icon(
                        Icons.tag_rounded,
                        size: 18,
                        color: theme.colorScheme.primary,
                      ),
                    ),
                  ),
                  TextSpan(text: topic.name),
                ],
              ),
              style: TextStyle(
                fontSize: floor == 1 ? 15 : 14,
                color: theme.colorScheme.primary,
              ),
            ),
          ),
        if (hasText)
          Text.rich(
            richNode(item, context),
            style: TextStyle(fontSize: isDetail && floor == 1 ? 16 : 15),
            maxLines: isDetail ? null : 6,
            overflow: isDetail ? TextOverflow.visible : TextOverflow.ellipsis,
          ),
        if (pics.isNotEmpty) DynamicImageGrid(pictures: pics),
      ],
    ),
  );
}

bool _hasVisibleText(dynamic text) {
  return text is String && text.trim().isNotEmpty;
}
