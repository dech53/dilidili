import 'package:dilidili/common/widgets/network_img_layer.dart';
import 'package:dilidili/model/space/space_audio/item.dart';
import 'package:dilidili/pages/member_home/widgets/member_home_navigation.dart';
import 'package:dilidili/utils/num_utils.dart';
import 'package:flutter/material.dart';

class MemberHomeAudioItem extends StatelessWidget {
  const MemberHomeAudioItem({
    super.key,
    required this.item,
  });

  final SpaceAudioItem item;

  @override
  Widget build(BuildContext context) {
    final Color outline = Theme.of(context).colorScheme.outline;
    return Card(
      margin: EdgeInsets.zero,
      clipBehavior: Clip.hardEdge,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      child: InkWell(
        onTap: () => MemberHomeNavigation.openAudio(item),
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: Row(
            children: [
              NetworkImgLayer(
                src: item.cover,
                width: 64,
                height: 64,
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
                        if (item.statistic?.play != null)
                          '${NumUtils.int2Num(item.statistic!.play)}播放',
                        if (item.statistic?.comment != null)
                          '${NumUtils.int2Num(item.statistic!.comment)}评论',
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
    );
  }
}
