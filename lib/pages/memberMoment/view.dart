import 'package:dilidili/common/skeleton/dynamic_card.dart';
import 'package:dilidili/common/widgets/http_error.dart';
import 'package:dilidili/model/dynamics/result.dart';
import 'package:dilidili/pages/memberMoment/controller.dart';
import 'package:dilidili/pages/moments/widgets/moments_panel.dart';
import 'package:dilidili/utils/string_utils.dart';
import 'package:easy_debounce/easy_throttle.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MemberMomentPage extends StatefulWidget {
  const MemberMomentPage({super.key});

  @override
  State<MemberMomentPage> createState() => _MemberMomentPageState();
}

class _MemberMomentPageState extends State<MemberMomentPage>
    with AutomaticKeepAliveClientMixin {
  late MemberMomentController _memberMomentController;
  late Future _futureBuilderFuture;
  late int mid;

  @override
  void initState() {
    super.initState();
    mid = int.parse(Get.arguments['mid']!);
    _memberMomentController =
        Get.put(MemberMomentController(), tag: mid.toString());
    _futureBuilderFuture =
        _memberMomentController.getMemberDynamic('onRefresh');
  }

  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return CustomScrollView(
      slivers: [
        FutureBuilder(
          future: _futureBuilderFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              if (snapshot.data != null) {
                Map data = snapshot.data as Map;
                List<MomentItemModel> list =
                    _memberMomentController.momentsList;
                if (data['status']) {
                  return Obx(
                    () => list.isNotEmpty
                        ? SliverList(
                            delegate: SliverChildBuilderDelegate(
                              (context, index) {
                                if (index >=
                                    _memberMomentController.momentsList.length -
                                        2) {
                                  EasyThrottle.throttle(
                                      'history', const Duration(seconds: 1),
                                      () {
                                    _memberMomentController.onLoad();
                                  });
                                }
                                return MomentsPanel(
                                  item: list[index],
                                  floor: 1,
                                );
                              },
                              childCount: list.length,
                            ),
                          )
                        : HttpError(
                            errMsg: '暂无动态',
                            fn: () {},
                          ),
                  );
                } else {
                  return HttpError(
                    errMsg: snapshot.data['msg'],
                    fn: () {},
                  );
                }
              } else {
                return HttpError(
                  errMsg: snapshot.data['msg'],
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
