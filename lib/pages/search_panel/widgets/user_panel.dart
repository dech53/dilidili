import 'package:cached_network_image/cached_network_image.dart';
import 'package:dilidili/utils/string_utils.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

Widget searchUserPanel(BuildContext context, ctr, list) {
  TextStyle style = TextStyle(
      fontSize: Theme.of(context).textTheme.labelSmall!.fontSize,
      color: Theme.of(context).colorScheme.outline);

  return ListView.builder(
    controller: ctr!.scrollController,
    addAutomaticKeepAlives: false,
    addRepaintBoundaries: false,
    itemCount: list!.length,
    itemBuilder: (context, index) {
      var i = list![index];
      String heroTag = StringUtils.makeHeroTag(i!.mid);
      return InkWell(
        onTap: () => Get.toNamed('/member/mid=${i.mid}',
            arguments: {'heroTag': heroTag, 'face': i.upic, 'mid': i.mid.toString()}),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
          child: Row(
            children: [
              CircleAvatar(
                backgroundImage: CachedNetworkImageProvider(
                  i.upic,
                ),
              ),
              const SizedBox(width: 10),
              Column(
                mainAxisSize: MainAxisSize.max,
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Row(
                    children: [
                      Text(
                        i!.uname,
                        style: const TextStyle(
                          fontSize: 14,
                        ),
                      ),
                      const SizedBox(width: 6),
                      Image.asset(
                        'assets/images/lv/lv${i!.level}.png',
                        height: 11,
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Text('粉丝：${i.fans} ', style: style),
                      Text(' 视频：${i.videos}', style: style)
                    ],
                  ),
                  if (i.officialVerify['desc'] != '')
                    Text(
                      i.officialVerify['desc'],
                      style: style,
                    ),
                ],
              )
            ],
          ),
        ),
      );
    },
  );
}
