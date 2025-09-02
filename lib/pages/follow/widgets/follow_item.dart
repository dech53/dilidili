import 'package:bottom_sheet/bottom_sheet.dart';
import 'package:dilidili/common/widgets/network_img_layer.dart';
import 'package:dilidili/model/follow/result.dart';
import 'package:dilidili/pages/follow/controller.dart';
import 'package:dilidili/pages/video/introduction/widgets/group_panel.dart';
import 'package:dilidili/utils/string_utils.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class FollowItem extends StatelessWidget {
  final FollowItemModel item;
  final FollowController? ctr;
  const FollowItem({super.key, required this.item, this.ctr});

  @override
  Widget build(BuildContext context) {
    String heroTag = StringUtils.makeHeroTag(item.mid);
    return ListTile(
      onTap: () {
        Get.toNamed('/member/mid=${item.mid}', arguments: {
          'face': item.face,
          'heroTag': heroTag,
          'mid': item.mid.toString(),
        });
      },
      leading: Hero(
        tag: heroTag,
        child: NetworkImgLayer(
          width: 45,
          height: 45,
          type: 'avatar',
          src: item.face,
        ),
      ),
      title: Text(
        item.uname!,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: const TextStyle(fontSize: 14),
      ),
      subtitle: Text(
        item.sign!,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
      dense: true,
      trailing: ctr != null && ctr!.isOwner.value
          ? SizedBox(
              height: 34,
              child: TextButton(
                onPressed: () async {
                  await showFlexibleBottomSheet(
                    bottomSheetBorderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(16),
                      topRight: Radius.circular(16),
                    ),
                    minHeight: 1,
                    initHeight: 1,
                    maxHeight: 1,
                    context: Get.context!,
                    builder: (BuildContext context,
                        ScrollController scrollController, double offset) {
                      return GroupPanel(
                        mid: item.mid!,
                        scrollController: scrollController,
                      );
                    },
                    anchors: [1],
                    isSafeArea: true,
                  );
                },
                style: TextButton.styleFrom(
                  padding: const EdgeInsets.fromLTRB(15, 0, 15, 0),
                  foregroundColor: Theme.of(context).colorScheme.outline,
                  backgroundColor:
                      Theme.of(context).colorScheme.onInverseSurface, // 设置按钮背景色
                ),
                child: const Text(
                  '已关注',
                  style: TextStyle(fontSize: 12),
                ),
              ),
            )
          : const SizedBox(),
    );
  }
}
