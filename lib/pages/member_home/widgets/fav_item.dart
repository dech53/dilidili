import 'package:dilidili/common/constants.dart';
import 'package:dilidili/common/widgets/network_img_layer.dart';
import 'package:dilidili/model/space/space_fav/list.dart';
import 'package:dilidili/pages/member_home/widgets/member_home_navigation.dart';
import 'package:dilidili/utils/string_utils.dart';
import 'package:flutter/material.dart';

class MemberHomeFavItem extends StatelessWidget {
  const MemberHomeFavItem({
    super.key,
    required this.item,
    required this.isOwner,
  });

  final SpaceFavItemModel item;
  final bool isOwner;

  @override
  Widget build(BuildContext context) {
    final int? mediaId = item.mediaId ?? item.id;
    final String? heroTag =
        mediaId == null ? null : StringUtils.makeHeroTag(mediaId);
    final Widget cover = NetworkImgLayer(
      src: item.cover,
      width: 140.8,
      height: 88,
    );
    return Material(
      type: MaterialType.transparency,
      child: InkWell(
        onTap: () => MemberHomeNavigation.openFavorite(
          item,
          isOwner: isOwner,
          heroTag: heroTag,
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: StyleString.safeSpace,
            vertical: 5,
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              heroTag == null
                  ? cover
                  : Hero(
                      tag: heroTag,
                      child: cover,
                    ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item.title ?? '',
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const Spacer(),
                    Text(
                      '${item.count ?? item.mediaCount ?? 0}个内容 · ${item.isPublic == 1 ? '私密' : '公开'}',
                      style: TextStyle(
                        fontSize: 12,
                        color: Theme.of(context).colorScheme.outline,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
