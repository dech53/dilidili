import 'package:dilidili/common/skeleton/dynamic_card.dart';
import 'package:dilidili/common/widgets/http_error.dart';
import 'package:dilidili/common/widgets/no_data.dart';
import 'package:dilidili/model/dynamics/result.dart';
import 'package:dilidili/model/dynamics/up.dart';
import 'package:dilidili/pages/moments/controller.dart';
import 'package:dilidili/pages/moments/up_moments/controller.dart';
import 'package:dilidili/pages/moments/widgets/moments_panel.dart';
import 'package:easy_debounce/easy_throttle.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class UpMomentsPage extends StatefulWidget {
  final UpItem upInfo;
  final MomentsController ctr;

  const UpMomentsPage({
    required this.upInfo,
    required this.ctr,
    Key? key,
  }) : super(key: key);

  @override
  State<UpMomentsPage> createState() => _UpMomentsPageState();
}

class _UpMomentsPageState extends State<UpMomentsPage>
    with AutomaticKeepAliveClientMixin {
  late UpDynamicsController _upDynamicsController;
  final ScrollController scrollController = ScrollController();
  late Future _futureBuilderFuture;

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    _upDynamicsController = Get.put(UpDynamicsController(widget.upInfo),
        tag: widget.upInfo.mid.toString());
    _futureBuilderFuture = _upDynamicsController.queryFollowDynamic();

    scrollController.addListener(
      () async {
        if (scrollController.position.pixels >=
            scrollController.position.maxScrollExtent - 200) {
          EasyThrottle.throttle(
              'queryFollowDynamic', const Duration(seconds: 1), () {
            _upDynamicsController.queryFollowDynamic(type: 'onLoad');
          });
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return CustomScrollView(
      controller: scrollController,
      physics: const AlwaysScrollableScrollPhysics(),
      slivers: [
        SliverPersistentHeader(
          pinned: true,
          floating: true,
          delegate: _CustomSliverPersistentHeaderDelegate(
            child: Container(
              height: 50,
              padding: const EdgeInsets.fromLTRB(20, 4, 4, 4),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surface,
                border: Border(
                  bottom: BorderSide(
                    color: Theme.of(context).colorScheme.onSurface,
                    width: 0.1,
                  ),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    widget.upInfo.uname!,
                    style: Theme.of(context)
                        .textTheme
                        .titleMedium!
                        .copyWith(fontWeight: FontWeight.bold),
                  ),
                  IconButton(
                    onPressed: () => Navigator.of(context).pop(),
                    icon: const Icon(Icons.close),
                  )
                ],
              ),
            ),
          ),
        ),
        FutureBuilder(
          future: _futureBuilderFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              if (snapshot.data == null) {
                return const SliverToBoxAdapter(child: SizedBox());
              }
              Map? data = snapshot.data;
              if (data != null && data['status']) {
                List<MomentItemModel> list = _upDynamicsController.dynamicsList;
                return Obx(
                  () {
                    if (list.isEmpty) {
                      if (_upDynamicsController.isLoadingDynamic.value) {
                        return skeleton();
                      } else {
                        return const NoData();
                      }
                    } else {
                      return SliverList(
                        delegate: SliverChildBuilderDelegate(
                          (context, index) {
                            return MomentsPanel(item: list[index]);
                          },
                          childCount: list.length,
                        ),
                      );
                    }
                  },
                );
              } else {
                return HttpError(
                  errMsg: data?['msg'] ?? '请求异常',
                  btnText: data?['code'] == -101 ? '去登录' : null,
                  fn: () {},
                );
              }
            } else {
              return skeleton();
            }
          },
        ),
      ],
    );
  }

  Widget skeleton() {
    return SliverList(
      delegate: SliverChildBuilderDelegate((context, index) {
        return const MomentsCardSkeleton();
      }, childCount: 5),
    );
  }
}

class _CustomSliverPersistentHeaderDelegate
    extends SliverPersistentHeaderDelegate {
  _CustomSliverPersistentHeaderDelegate({required this.child});
  final double _minExtent = 50;
  final double _maxExtent = 50;
  final Widget child;

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return child;
  }

  @override
  double get maxExtent => _maxExtent;

  @override
  double get minExtent => _minExtent;

  @override
  bool shouldRebuild(
      covariant _CustomSliverPersistentHeaderDelegate oldDelegate) {
    return true;
  }
}
