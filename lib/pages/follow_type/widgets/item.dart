import 'package:dilidili/common/widgets/network_img_layer.dart';
import 'package:dilidili/model/follow/result.dart';
import 'package:dilidili/utils/string_utils.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class FollowTypeItem extends StatelessWidget {
  const FollowTypeItem({
    super.key,
    required this.item,
    this.onTap,
    this.onLongPress,
    this.onSecondaryTap,
  });

  final FollowItemModel item;
  final VoidCallback? onTap;
  final VoidCallback? onLongPress;
  final VoidCallback? onSecondaryTap;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 66,
      child: InkWell(
        onTap: onTap ?? _openMember,
        onLongPress: onLongPress,
        onSecondaryTap: onSecondaryTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          child: Row(
            children: [
              NetworkImgLayer(
                width: 45,
                height: 45,
                type: 'avatar',
                src: item.face,
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      item.uname ?? '',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(fontSize: 14),
                    ),
                    if (item.sign?.isNotEmpty == true) ...[
                      const SizedBox(height: 3),
                      Text(
                        item.sign!,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 13,
                          color: Theme.of(context).colorScheme.outline,
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
    );
  }

  void _openMember() {
    final String heroTag = StringUtils.makeHeroTag(item.mid);
    Get.toNamed(
      '/member/mid=${item.mid}',
      arguments: {
        'face': item.face,
        'heroTag': heroTag,
        'mid': item.mid.toString(),
      },
    );
  }
}
