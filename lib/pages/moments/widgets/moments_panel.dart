import 'package:dilidili/model/dynamics/result.dart';
import 'package:dilidili/pages/moments/controller.dart';
import 'package:dilidili/pages/moments/widgets/action_panel.dart';
import 'package:dilidili/pages/moments/widgets/author_panel.dart';
import 'package:dilidili/pages/moments/widgets/dyn_content.dart';
import 'package:dilidili/pages/moments/widgets/interaction.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MomentsPanel extends StatelessWidget {
  MomentsPanel({super.key, required this.item, this.source, this.floor});

  final dynamic item;
  final int? floor;
  final String? source;

  final MomentsController _momentsController =
      Get.isRegistered<MomentsController>()
          ? Get.find<MomentsController>()
          : Get.put(MomentsController());

  bool get isDetail => source == 'detail';

  @override
  Widget build(BuildContext context) {
    if (item.visible == false) {
      return const SizedBox.shrink();
    }

    final theme = Theme.of(context);
    final child = Material(
      type: MaterialType.transparency,
      child: InkWell(
        onTap: isDetail ? null : () => _momentsController.pushDetail(item, 1),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(12, 12, 12, 6),
              child: AuthorPanel(item: item, isDetail: isDetail),
            ),
            if (item.modules?.moduleDispute != null)
              _buildDispute(theme, item.modules!.moduleDispute!),
            ...dynContent(
              context,
              theme: theme,
              isDetail: isDetail,
              item: item,
              floor: 1,
            ),
            const SizedBox(height: 2),
            if (!isDetail) ...[
              if (item.modules?.moduleInteraction?.items?.isNotEmpty == true)
                dynInteraction(
                  theme: theme,
                  items: item.modules!.moduleInteraction!.items!,
                ),
              ActionPanel(item: item),
              if (item.modules?.moduleFold != null) ...[
                Divider(
                  height: 1,
                  color: theme.dividerColor.withOpacity(0.1),
                ),
                _buildFoldItem(theme, item.modules!.moduleFold!),
              ],
            ] else
              const SizedBox(height: 12),
          ],
        ),
      ),
    );

    return DecoratedBox(
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            width: isDetail ? 0 : 8,
            color: theme.dividerColor.withOpacity(0.05),
          ),
        ),
      ),
      child: Padding(
        padding: EdgeInsets.only(bottom: isDetail ? 12 : 8),
        child: child,
      ),
    );
  }

  Widget _buildDispute(ThemeData theme, ModuleDispute moduleDispute) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.fromLTRB(12, 2, 12, 6),
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
      decoration: BoxDecoration(
        color: theme.colorScheme.secondaryContainer.withOpacity(0.5),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text.rich(
        TextSpan(
          children: [
            WidgetSpan(
              alignment: PlaceholderAlignment.middle,
              child: Padding(
                padding: const EdgeInsets.only(right: 4),
                child: Icon(
                  Icons.warning_rounded,
                  size: 15,
                  color: theme.colorScheme.onSecondaryContainer,
                ),
              ),
            ),
            TextSpan(text: moduleDispute.title ?? moduleDispute.desc ?? ''),
          ],
        ),
        style: TextStyle(
          height: 1,
          fontSize: 13,
          color: theme.colorScheme.onSecondaryContainer,
        ),
      ),
    );
  }

  Widget _buildFoldItem(ThemeData theme, ModuleFold moduleFold) {
    return InkWell(
      onTap: () {},
      child: Container(
        alignment: Alignment.center,
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: Text.rich(
          TextSpan(
            children: [
              TextSpan(text: moduleFold.statement ?? '展开'),
              WidgetSpan(
                alignment: PlaceholderAlignment.middle,
                child: Icon(
                  Icons.keyboard_arrow_down,
                  size: 19,
                  color: theme.colorScheme.outline,
                ),
              ),
            ],
          ),
          textAlign: TextAlign.center,
          style: TextStyle(
            height: 1,
            fontSize: 13,
            color: theme.colorScheme.outline,
          ),
        ),
      ),
    );
  }
}
