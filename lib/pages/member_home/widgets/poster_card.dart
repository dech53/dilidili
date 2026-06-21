import 'package:dilidili/common/widgets/network_img_layer.dart';
import 'package:dilidili/model/space/space_archive/item.dart';
import 'package:dilidili/pages/member_home/widgets/member_home_navigation.dart';
import 'package:flutter/material.dart';

class MemberHomePosterCard extends StatelessWidget {
  const MemberHomePosterCard({
    super.key,
    required this.item,
    this.isSeason = false,
  });

  final SpaceArchiveItem item;
  final bool isSeason;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.zero,
      elevation: 0,
      shadowColor: Colors.transparent,
      surfaceTintColor: Colors.transparent,
      clipBehavior: Clip.hardEdge,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      child: InkWell(
        onTap: () => isSeason
            ? MemberHomeNavigation.openSeason(item)
            : MemberHomeNavigation.openArchive(item),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AspectRatio(
              aspectRatio: 0.75,
              child: LayoutBuilder(
                builder: (context, constraints) {
                  return NetworkImgLayer(
                    src: item.cover,
                    width: constraints.maxWidth,
                    height: constraints.maxHeight,
                    type: 'emote',
                  );
                },
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(7, 6, 7, 6),
                child: Text(
                  '${item.title}\n',
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(height: 1.35),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
