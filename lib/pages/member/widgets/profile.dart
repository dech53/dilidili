import 'package:cached_network_image/cached_network_image.dart';
import 'package:dilidili/common/widgets/network_img_layer.dart';
import 'package:dilidili/model/live/item.dart';
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
            Hero(
              tag: ctr.heroTag!,
              child: Stack(
                children: [
                  NetworkImgLayer(
                    width: 90,
                    height: 90,
                    type: 'avatar',
                    src: !loadingStatus ? memberInfo.face : ctr.face.value,
                  ),
                  if (!loadingStatus &&
                      memberInfo.liveRoom != null &&
                      memberInfo.liveRoom!.liveStatus == 1)
                    Positioned(
                      bottom: 0,
                      left: 14,
                      child: GestureDetector(
                        onTap: () {
                          LiveItemModel liveItem = LiveItemModel.fromJson({
                            'title': memberInfo.liveRoom!.title,
                            'uname': memberInfo.name,
                            'face': memberInfo.face,
                            'roomid': memberInfo.liveRoom!.roomid,
                            'watched_show': memberInfo.liveRoom!.watchedShow,
                          });
                          Get.toNamed(
                            '/liveRoom?roomid=${memberInfo.liveRoom!.roomid}',
                            arguments: {'liveItem': liveItem},
                          );
                        },
                        child: Container(
                          padding: const EdgeInsets.fromLTRB(6, 2, 6, 2),
                          decoration: BoxDecoration(
                            color: Theme.of(context).colorScheme.primary,
                            borderRadius:
                                const BorderRadius.all(Radius.circular(10)),
                          ),
                          child: Row(children: [
                            Image.asset(
                              'assets/images/live.gif',
                              height: 10,
                            ),
                            Text(
                              ' 直播中',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: Theme.of(context)
                                      .textTheme
                                      .labelSmall!
                                      .fontSize),
                            )
                          ]),
                        ),
                      ),
                    )
                ],
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
                        const Text("|"),
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
                        const Text("|"),
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
                                    : Theme.of(context).colorScheme.primary,
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
