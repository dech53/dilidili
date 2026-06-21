import 'package:dilidili/model/dynamics/result.dart';
import 'package:dilidili/pages/moments/widgets/blocked_item.dart';
import 'package:dilidili/pages/moments/widgets/content_panel.dart';
import 'package:dilidili/pages/moments/widgets/dynamic_additional_panel.dart';
import 'package:dilidili/pages/moments/widgets/module_panel.dart';
import 'package:flutter/material.dart';

List<Widget> dynContent(
  BuildContext context, {
  required int floor,
  required ThemeData theme,
  required dynamic item,
  required bool isDetail,
}) {
  final ModuleDynamicModel? moduleDynamic = item.modules?.moduleDynamic;
  final children = <Widget>[
    if (item.type != 'DYNAMIC_TYPE_NONE')
      dynamicContent(
        context,
        theme: theme,
        isDetail: isDetail,
        item: item,
        floor: floor,
      ),
    modulePanel(
      context,
      theme: theme,
      isDetail: isDetail,
      item: item,
      floor: floor,
    ),
  ];

  final additional = moduleDynamic?.additional;
  if (additional != null) {
    final widget = dynamicAdditionalWidget(
      context,
      theme: theme,
      idStr: item.idStr,
      additional: additional,
      floor: floor,
    );
    if (widget != null) {
      children.add(widget);
    }
  }

  final blocked = moduleDynamic?.major?.blocked;
  if (blocked != null) {
    children.add(blockedItem(context, theme: theme, blocked: blocked));
  }

  return children;
}
