import 'package:dilidili/common/constants.dart';
import 'package:dilidili/common/widgets/badge.dart';
import 'package:dilidili/common/widgets/network_img_layer.dart';
import 'package:dilidili/model/space/space_archive/item.dart';
import 'package:dilidili/pages/member_home/widgets/member_home_navigation.dart';
import 'package:dilidili/utils/num_utils.dart';
import 'package:flutter/material.dart';

class MemberHomeArchiveCard extends StatelessWidget {
  const MemberHomeArchiveCard({
    super.key,
    required this.item,
  });

  final SpaceArchiveItem item;

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
        onTap: () => MemberHomeNavigation.openArchive(item),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AspectRatio(
              aspectRatio: StyleString.aspectRatio,
              child: LayoutBuilder(
                builder: (context, constraints) {
                  return Stack(
                    clipBehavior: Clip.none,
                    children: [
                      NetworkImgLayer(
                        src: item.cover,
                        width: constraints.maxWidth,
                        height: constraints.maxHeight,
                        type: 'emote',
                      ),
                      if (item.duration > 0)
                        PBadge(
                          bottom: 6,
                          right: 7,
                          size: 'small',
                          type: 'gray',
                          text: NumUtils.int2time(item.duration),
                        ),
                      if (item.badges?.isNotEmpty == true)
                        PBadge(
                          text: item.badges!
                              .map((e) => e.text ?? '')
                              .where((text) => text.isNotEmpty)
                              .join('|'),
                          top: 6,
                          right: 6,
                          size: 'small',
                          type: item.badges!.first.text == '充电专属'
                              ? 'line'
                              : 'primary',
                        )
                      else if (item.isCooperation == true)
                        const PBadge(
                          text: '合作',
                          top: 6,
                          right: 6,
                          size: 'small',
                        )
                      else if (item.isSteins == true)
                        const PBadge(
                          text: '互动',
                          top: 6,
                          right: 6,
                          size: 'small',
                        ),
                    ],
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
