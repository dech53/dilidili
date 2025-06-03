import 'package:dilidili/common/widgets/network_img_layer.dart';
import 'package:dilidili/utils/num_utils.dart';
import 'package:dilidili/utils/string_utils.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AuthorPanel extends StatelessWidget {
  final dynamic item;
  const AuthorPanel({super.key, this.item});

  @override
  Widget build(BuildContext context) {
    String heroTag = StringUtils.makeHeroTag(item.modules.moduleAuthor.mid);
    return Row(
      children: [
        GestureDetector(
          onTap: () {
            // 番剧
            if (item.modules.moduleAuthor.type == 'AUTHOR_TYPE_PGC') {
              return;
            }
            Get.toNamed(
              '/member?mid=${item.modules.moduleAuthor.mid}',
              arguments: {
                'face': item.modules.moduleAuthor.face,
                'heroTag': heroTag
              },
            );
          },
          child: Hero(
            tag: heroTag,
            child: NetworkImgLayer(
              width: 40,
              height: 40,
              type: 'avatar',
              src: item.modules.moduleAuthor.face,
            ),
          ),
        ),
        const SizedBox(width: 10),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  item.modules.moduleAuthor.name,
                  style: TextStyle(
                    color: item.modules.moduleAuthor!.vip != null &&
                            item.modules.moduleAuthor!.vip['status'] > 0
                        ? const Color.fromARGB(255, 251, 100, 163)
                        : Theme.of(context).colorScheme.onSurface,
                    fontSize: Theme.of(context).textTheme.titleSmall!.fontSize,
                  ),
                ),
              ],
            ),
            DefaultTextStyle.merge(
              style: TextStyle(
                color: Theme.of(context).colorScheme.outline,
                fontSize: Theme.of(context).textTheme.labelSmall!.fontSize,
              ),
              child: Row(
                children: [
                  if (item.modules.moduleAuthor.pubTime != '') ...[
                    Text(item.modules.moduleAuthor.pubTime),
                  ] else ...[
                    Text(NumUtils.dateFormat(item.modules.moduleAuthor.pubTs)),
                  ],
                  if (item.modules.moduleAuthor.pubTime != '' &&
                      item.modules.moduleAuthor.pubAction != '')
                    const Text(' '),
                  Text(item.modules.moduleAuthor.pubAction),
                ],
              ),
            )
          ],
        ),
        const Spacer(),
      ],
    );
  }
}
