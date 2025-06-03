import 'package:dilidili/model/dynamics/result.dart';
import 'package:dilidili/pages/moments/controller.dart';
import 'package:dilidili/pages/moments/widgets/action_panel.dart';
import 'package:dilidili/pages/moments/widgets/author_panel.dart';
import 'package:dilidili/pages/moments/widgets/content_panel.dart';
import 'package:dilidili/pages/moments/widgets/forward_panel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class MomentsPanel extends StatelessWidget {
  MomentsPanel({super.key, required this.item, this.source, this.floor});
  final dynamic item;
  dynamic floor;
  final String? source;

  final MomentsController _momentsController = Get.put(MomentsController());

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: source == 'detail'
          ? const EdgeInsets.only(bottom: 12)
          : EdgeInsets.zero,
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            width: 8,
            color: Theme.of(context).dividerColor.withOpacity(0.05),
          ),
        ),
      ),
      child: Material(
        elevation: 0,
        clipBehavior: Clip.hardEdge,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(0),
        ),
        child: InkWell(
          onTap: () => _momentsController.pushDetail(item, 1),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(12, 12, 12, 8),
                child: AuthorPanel(item: item),
              ),
              if (item.modules!.moduleDynamic!.desc != null ||
                  item.modules!.moduleDynamic!.major != null)
                Content(
                  item: item,
                  source: source,
                ),
              forWard(item, context, _momentsController, source),
              2.verticalSpace,
              if (source == null || floor == 1)
                ActionPanel(
                  item: item,
                ),
            ],
          ),
        ),
      ),
    );
  }
}
