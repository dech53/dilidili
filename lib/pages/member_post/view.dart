import 'package:dilidili/common/skeleton/video_card_h.dart';
import 'package:dilidili/common/widgets/http_error.dart';
import 'package:dilidili/common/widgets/no_data.dart';
import 'package:dilidili/common/widgets/video_card_h.dart';
import 'package:dilidili/pages/member_post/controller.dart';
import 'package:dilidili/utils/string_utils.dart';
import 'package:easy_debounce/easy_throttle.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MemberPostPage extends StatefulWidget {
  const MemberPostPage({super.key});

  @override
  State<MemberPostPage> createState() => _MemberPostPageState();
}

class _MemberPostPageState extends State<MemberPostPage>
    with AutomaticKeepAliveClientMixin {
  late MemberPostController _memberPostController;
  late Future _futureBuilderFuture;
  late ScrollController scrollController;
  late int mid;
  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    mid = int.parse(Get.arguments['mid']!);
    _memberPostController = Get.put(MemberPostController(), tag: mid.toString());
    _futureBuilderFuture = _memberPostController.getMemberPost('init');
    scrollController = _memberPostController.scrollController;
    scrollController.addListener(
      () {
        if (scrollController.position.pixels >=
            scrollController.position.maxScrollExtent - 200) {
          EasyThrottle.throttle(
              'member_archives', const Duration(milliseconds: 500), () {
            _memberPostController.onLoad();
          });
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return CustomScrollView(
      slivers: [
        FutureBuilder(
          future: _futureBuilderFuture,
          builder: (BuildContext context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              if (snapshot.data != null) {
                Map data = snapshot.data as Map;
                List list = _memberPostController.postsList;
                if (data['status']) {
                  return Obx(
                    () => list.isNotEmpty
                        ? SliverList(
                            delegate: SliverChildBuilderDelegate(
                              (BuildContext context, index) {
                                if (index >=
                                    _memberPostController.postsList.length -
                                        2) {
                                  EasyThrottle.throttle(
                                      'history', const Duration(seconds: 1),
                                      () {
                                    _memberPostController.onLoad();
                                  });
                                }
                                return VideoCardH(
                                  videoItem: list[index],
                                  enableTap: true,
                                );
                              },
                              childCount: list.length,
                            ),
                          )
                        : _memberPostController.isLoading.value
                            ? SliverList(
                                delegate: SliverChildBuilderDelegate(
                                    (context, index) {
                                  return const VideoCardHSkeleton();
                                }, childCount: 10),
                              )
                            : const NoData(),
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
              return SliverList(
                delegate: SliverChildBuilderDelegate((context, index) {
                  return const VideoCardHSkeleton();
                }, childCount: 10),
              );
            }
          },
        ),
      ],
    );
  }
}
