import 'package:dilidili/model/dynamics/result.dart';
import 'package:dilidili/pages/moments/controller.dart';
import 'package:dilidili/pages/moments/widgets/dyn_content.dart';
import 'package:dilidili/pages/moments/widgets/module_panel.dart';
import 'package:dilidili/utils/num_utils.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

Widget dynamicForwardPanel(
  BuildContext context, {
  required int floor,
  required ThemeData theme,
  required dynamic orig,
  required bool isDetail,
}) {
  final major = orig.modules?.moduleDynamic?.major;
  final isNoneMajor = major?.type == 'MAJOR_TYPE_NONE';
  Widget child;

  if (isNoneMajor) {
    child = noneWidget(theme, major?.none?.tips);
  } else {
    child = Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (orig.modules?.moduleAuthor != null)
          _forwardAuthor(
            theme: theme,
            moduleAuthor: orig.modules!.moduleAuthor!,
          ),
        const SizedBox(height: 5),
        ...dynContent(
          context,
          theme: theme,
          isDetail: isDetail,
          item: orig,
          floor: floor + 1,
        ),
      ],
    );
  }

  final panel = Container(
    width: double.infinity,
    padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
    color: theme.dividerColor.withOpacity(0.08),
    child: child,
  );

  if (isNoneMajor) return panel;
  final controller = Get.isRegistered<MomentsController>()
      ? Get.find<MomentsController>()
      : Get.put(MomentsController());
  return InkWell(
    onTap: () => controller.pushDetail(orig, floor),
    child: panel,
  );
}

Widget _forwardAuthor({
  required ThemeData theme,
  required ModuleAuthorModel moduleAuthor,
}) {
  final isNormalAuthor =
      moduleAuthor.type == 'AUTHOR_TYPE_NORMAL' || moduleAuthor.type == null;
  return Row(
    children: [
      GestureDetector(
        onTap: isNormalAuthor
            ? () => Get.toNamed(
                  '/member/mid=${moduleAuthor.mid}',
                  arguments: {
                    'mid': moduleAuthor.mid?.toString(),
                    'face': moduleAuthor.face,
                  },
                )
            : null,
        child: Text(
          '${isNormalAuthor ? '@' : ''}${moduleAuthor.name ?? ''}',
          style: TextStyle(color: theme.colorScheme.primary),
        ),
      ),
      const SizedBox(width: 6),
      Text(
        moduleAuthor.pubTs != null
            ? NumUtils.dateFormat(moduleAuthor.pubTs)
            : moduleAuthor.pubTime ?? '',
        style: TextStyle(
          color: theme.colorScheme.outline,
          fontSize: theme.textTheme.labelSmall?.fontSize,
        ),
      ),
    ],
  );
}
