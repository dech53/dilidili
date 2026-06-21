import 'package:dilidili/common/constants.dart';
import 'package:dilidili/common/widgets/network_img_layer.dart';
import 'package:dilidili/model/space/space_article/item.dart';
import 'package:dilidili/pages/member_home/widgets/member_home_navigation.dart';
import 'package:dilidili/utils/num_utils.dart';
import 'package:flutter/material.dart';

class MemberHomeArticleItem extends StatelessWidget {
  const MemberHomeArticleItem({
    super.key,
    required this.item,
  });

  final SpaceArticleItem item;

  @override
  Widget build(BuildContext context) {
    final String? cover = item.originImageUrls?.isNotEmpty == true
        ? item.originImageUrls!.first
        : null;
    final Color outline = Theme.of(context).colorScheme.outline;
    return Material(
      type: MaterialType.transparency,
      child: InkWell(
        onTap: () => MemberHomeNavigation.openArticle(item),
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: StyleString.safeSpace,
            vertical: 5,
          ),
          child: SizedBox(
            height: 88,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                NetworkImgLayer(
                  src: cover,
                  width: 140.8,
                  height: 88,
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        item.title ?? '',
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const Spacer(),
                      Text(
                        [
                          if (item.stats?.view != null)
                            '${NumUtils.int2Num(item.stats!.view)}浏览',
                          if (item.stats?.reply != null)
                            '${NumUtils.int2Num(item.stats!.reply)}评论',
                          if (item.publishTimeText?.isNotEmpty == true)
                            item.publishTimeText!,
                        ].join(' · '),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(fontSize: 12, color: outline),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
