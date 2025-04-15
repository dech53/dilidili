import 'package:cached_network_image/cached_network_image.dart';
import 'package:dilidili/model/member/member_info.dart';
import 'package:dilidili/utils/num_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class ProfilePanel extends StatelessWidget {
  final dynamic ctr;
  final bool loadingStatus;
  const ProfilePanel({
    super.key,
    required this.ctr,
    this.loadingStatus = false,
  });
  @override
  Widget build(BuildContext context) {
    MemberInfo memberInfo = ctr.memberInfo.value;
    return Builder(
      builder: (context) {
        return Row(
          children: [
            CircleAvatar(
              radius: 50,
              backgroundImage: CachedNetworkImageProvider(
                memberInfo.face ?? "",
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Padding(
                    padding:
                        const EdgeInsets.only(top: 10, left: 10, right: 10),
                    child: Row(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        InkWell(
                          onTap: () {},
                          child: Column(
                            children: [
                              Text(
                                !loadingStatus
                                    ? ctr.userStat!['following'].toString()
                                    : '-',
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold),
                              ),
                              Text(
                                '关注',
                                style: TextStyle(
                                    fontSize: Theme.of(context)
                                        .textTheme
                                        .labelMedium!
                                        .fontSize),
                              )
                            ],
                          ),
                        ),
                        InkWell(
                          onTap: () {},
                          child: Column(
                            children: [
                              Text(
                                  !loadingStatus
                                      ? ctr.userStat!['follower'] != null
                                          ? NumUtils.int2Num(
                                              ctr.userStat!['follower'],
                                            )
                                          : '-'
                                      : '-',
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold)),
                              Text(
                                '粉丝',
                                style: TextStyle(
                                    fontSize: Theme.of(context)
                                        .textTheme
                                        .labelMedium!
                                        .fontSize),
                              )
                            ],
                          ),
                        ),
                        Column(
                          children: [
                            Text(
                                !loadingStatus
                                    ? ctr.userStat!['likes'] != null
                                        ? NumUtils.int2Num(
                                            ctr.userStat!['likes'],
                                          )
                                        : '-'
                                    : '-',
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold)),
                            Text(
                              '获赞',
                              style: TextStyle(
                                  fontSize: Theme.of(context)
                                      .textTheme
                                      .labelMedium!
                                      .fontSize),
                            )
                          ],
                        ),
                      ],
                    ),
                  ),
                  10.verticalSpace,
                  if (ctr.ownerMid != ctr.mid && ctr.ownerMid != -1) ...[
                    Row(
                      children: [
                        Obx(
                          () => Expanded(
                            child: TextButton(
                              onPressed: () => loadingStatus
                                  ? null
                                  : ctr.actionRelationMod(),
                              style: TextButton.styleFrom(
                                foregroundColor: ctr.attribute.value == -1
                                    ? Colors.transparent
                                    : ctr.attribute.value != 0
                                        ? Theme.of(context).colorScheme.outline
                                        : Theme.of(context)
                                            .colorScheme
                                            .onPrimary,
                                backgroundColor: ctr.attribute.value != 0
                                    ? Theme.of(context)
                                        .colorScheme
                                        .onInverseSurface
                                    : Theme.of(context)
                                        .colorScheme
                                        .primary,
                              ),
                              child: Obx(() => Text(ctr.attributeText.value)),
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: TextButton(
                            onPressed: () {},
                            style: TextButton.styleFrom(
                              backgroundColor: Theme.of(context)
                                  .colorScheme
                                  .onInverseSurface,
                            ),
                            child: const Text('发消息'),
                          ),
                        ),
                      ],
                    )
                  ]
                ],
              ),
            ),
          ],
        );
      },
    );
  }
}
