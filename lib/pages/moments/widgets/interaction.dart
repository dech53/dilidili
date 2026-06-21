import 'package:dilidili/model/dynamics/result.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';

Widget dynInteraction({
  required ThemeData theme,
  required List<ModuleInteractionItem> items,
}) {
  if (items.isEmpty) {
    return const SizedBox.shrink();
  }
  final children = items.map((item) => _interactionItem(theme, item)).toList();
  return Container(
    margin: const EdgeInsets.fromLTRB(12, 6, 12, 0),
    padding: const EdgeInsets.only(left: 8),
    decoration: BoxDecoration(
      border: Border(
        left: BorderSide(
          width: 1.5,
          color: theme.colorScheme.outline.withOpacity(0.3),
        ),
      ),
    ),
    child: children.length == 1
        ? children.single
        : Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: children,
          ),
  );
}

Widget _interactionItem(ThemeData theme, ModuleInteractionItem item) {
  final nodes = item.desc?.richTextNodes ?? const <RichTextNodeItem>[];
  return Text.rich(
    TextSpan(
      children: [
        WidgetSpan(
          alignment: PlaceholderAlignment.middle,
          child: Padding(
            padding: const EdgeInsets.only(right: 6),
            child: Icon(
              item.type == 1
                  ? FontAwesomeIcons.comment
                  : FontAwesomeIcons.thumbsUp,
              size: 13,
              color: theme.colorScheme.outline,
            ),
          ),
        ),
        ...nodes.map((node) {
          final isAt = node.type == 'RICH_TEXT_NODE_TYPE_AT';
          return TextSpan(
            text: node.origText ?? node.text ?? '',
            style: TextStyle(
              color: isAt
                  ? theme.colorScheme.primary
                  : theme.colorScheme.onSurfaceVariant,
            ),
            recognizer: isAt && node.rid != null
                ? (TapGestureRecognizer()
                  ..onTap = () => Get.toNamed('/member/mid=${node.rid}'))
                : null,
          );
        }),
      ],
    ),
    style: const TextStyle(fontSize: 13, height: 1.3),
  );
}
