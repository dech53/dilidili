import 'package:dilidili/common/widgets/network_img_layer.dart';
import 'package:dilidili/model/dynamics/up.dart';
import 'package:dilidili/model/live/item.dart';
import 'package:dilidili/utils/string_utils.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class UpPanel extends StatefulWidget {
  const UpPanel({super.key, required this.upData, this.onClickUpCb});
  final FollowUpModel upData;
  final Function? onClickUpCb;
  @override
  State<UpPanel> createState() => _UpPanelState();
}

class _UpPanelState extends State<UpPanel> {
  final ScrollController scrollController = ScrollController();
  int currentMid = -1;
  late double contentWidth = 56;
  List<UpItem> upList = [];
  List<LiveUserItem> liveList = [];
  static const itemPadding = EdgeInsets.symmetric(horizontal: 5, vertical: 0);
  late MyInfo userInfo;
  void listFormat() {
    userInfo = widget.upData.myInfo!;
    upList = widget.upData.upList!;
    liveList = widget.upData.liveList!;
  }

  @override
  Widget build(BuildContext context) {
    listFormat();
    return SliverPersistentHeader(
      floating: true,
      pinned: false,
      delegate: _SliverHeaderDelegate(
        height: liveList.isNotEmpty || upList.isNotEmpty ? 126 : 0,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              color: Theme.of(context).colorScheme.surface,
              padding: const EdgeInsets.only(left: 16, right: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Text('最新关注'),
                  GestureDetector(
                    onTap: () {
                      // Get.toNamed('/follow?mid=${userInfo.mid}');
                    },
                    child: Container(
                      padding: const EdgeInsets.only(top: 5, bottom: 5),
                      child: Text(
                        '查看全部',
                        style: TextStyle(
                            color: Theme.of(context).colorScheme.outline),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Container(
              height: 90,
              color: Theme.of(context).colorScheme.surface,
              child: Row(
                children: [
                  Flexible(
                    child: ListView(
                      scrollDirection: Axis.horizontal,
                      controller: scrollController,
                      children: [
                        const SizedBox(width: 10),
                        if (liveList.isNotEmpty) ...[
                          for (int i = 0; i < liveList.length; i++) ...[
                            upItemBuild(liveList[i], i)
                          ],
                          VerticalDivider(
                            indent: 20,
                            endIndent: 40,
                            width: 26,
                            color: Theme.of(context)
                                .colorScheme
                                .primary
                                .withOpacity(0.5),
                          ),
                        ],
                        for (int i = 0; i < upList.length; i++) ...[
                          upItemBuild(upList[i], i)
                        ],
                        const SizedBox(width: 10),
                      ],
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget upItemBuild(data, i) {
    bool isCurrent = currentMid == data.mid || currentMid == -1;
    return InkWell(
      onTap: () {
        if (data.type == 'up') {
        } else if (data.type == 'live') {
          LiveItemModel liveItem = LiveItemModel.fromJson({
            'title': data.title,
            'uname': data.uname,
            'face': data.face,
            'roomid': data.roomId,
          });
          Get.toNamed(
            '/liveRoom?roomid=${data.roomId}',
            arguments: {'liveItem': liveItem},
          );
        }
      },
      onLongPress: () {
        if (data.mid == -1) {
          return;
        }
        String heroTag = StringUtils.makeHeroTag(data.mid);
        Get.toNamed('/member?mid=${data.mid}',
            arguments: {'face': data.face, 'heroTag': heroTag});
      },
      child: Padding(
        padding: itemPadding,
        child: AnimatedOpacity(
          opacity: isCurrent ? 1 : 0.3,
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeInOut,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Badge(
                smallSize: 8,
                label: data.type == 'live' ? const Text('Live') : null,
                textColor: Theme.of(context).colorScheme.onSecondaryContainer,
                alignment: data.type == 'live'
                    ? AlignmentDirectional.topCenter
                    : AlignmentDirectional.topEnd,
                padding: const EdgeInsets.only(left: 6, right: 6),
                isLabelVisible: data.type == 'live' ||
                    (data.type == 'up' && (data.hasUpdate ?? false)),
                backgroundColor: data.type == 'live'
                    ? Theme.of(context).colorScheme.secondaryContainer
                    : Theme.of(context).colorScheme.primary,
                child: data.face != ''
                    ? NetworkImgLayer(
                        width: 50,
                        height: 50,
                        src: data.face,
                        type: 'avatar',
                      )
                    : const CircleAvatar(
                        radius: 25,
                        backgroundImage: AssetImage(
                          'assets/images/noface.jpeg',
                        ),
                      ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 4),
                child: SizedBox(
                  width: contentWidth,
                  child: Text(
                    data.uname,
                    overflow: TextOverflow.ellipsis,
                    softWrap: false,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        color: currentMid == data.mid
                            ? Theme.of(context).colorScheme.primary
                            : Theme.of(context).colorScheme.outline,
                        fontSize:
                            Theme.of(context).textTheme.labelMedium!.fontSize),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class UpPanelSkeleton extends StatelessWidget {
  const UpPanelSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      scrollDirection: Axis.horizontal,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: 10,
      itemBuilder: ((context, index) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.onInverseSurface,
                  borderRadius: BorderRadius.circular(50),
                ),
              ),
              Container(
                margin: const EdgeInsets.only(top: 6),
                width: 45,
                height: 12,
                color: Theme.of(context).colorScheme.onInverseSurface,
              ),
            ],
          ),
        );
      }),
    );
  }
}

class _SliverHeaderDelegate extends SliverPersistentHeaderDelegate {
  _SliverHeaderDelegate({required this.height, required this.child});

  final double height;
  final Widget child;

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return child;
  }

  @override
  double get maxExtent => height;

  @override
  double get minExtent => height;

  @override
  bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) =>
      true;
}
