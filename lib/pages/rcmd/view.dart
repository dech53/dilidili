import 'package:dilidili/common/constants.dart';
import 'package:dilidili/common/skeleton/video_card_v.dart';
import 'package:dilidili/common/widgets/http_error.dart';
import 'package:dilidili/component/video_card_component.dart';
import 'package:dilidili/pages/rcmd/controller.dart';
import 'package:dilidili/utils/string_utils.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class RcmdPage extends StatefulWidget {
  const RcmdPage({super.key});

  @override
  State<RcmdPage> createState() => _RcmdPageState();
}

class _RcmdPageState extends State<RcmdPage>
    with AutomaticKeepAliveClientMixin {
  final RcmdController _rcmdController = Get.put(RcmdController());
  late Future _futureBuilderFuture;

  @override
  void initState() {
    super.initState();
    _futureBuilderFuture = _rcmdController.queryRcmdFeed('init');
    ScrollController scrollController = _rcmdController.scrollController;
    scrollController.addListener(
      () {
        if (scrollController.position.pixels >=
            scrollController.position.maxScrollExtent - 200) {
          _rcmdController.isLoadingMore = true;
          _rcmdController.onLoad();
        }
      },
    );
  }

  @override
  void dispose() {
    _rcmdController.scrollController.removeListener(() {});
    super.dispose();
  }

  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Container(
      clipBehavior: Clip.hardEdge,
      margin: const EdgeInsets.only(
          left: StyleString.safeSpace, right: StyleString.safeSpace),
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.all(StyleString.imgRadius),
      ),
      child: RefreshIndicator(
        onRefresh: () async {
          await _rcmdController.onRefresh();
          await Future.delayed(const Duration(milliseconds: 300));
        },
        child: CustomScrollView(
          controller: _rcmdController.scrollController,
          physics: const AlwaysScrollableScrollPhysics(),
          slivers: [
            SliverPadding(
              padding:
                  const EdgeInsets.fromLTRB(0, StyleString.safeSpace, 0, 0),
              sliver: FutureBuilder(
                future: _futureBuilderFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.done) {
                    Map data = snapshot.data as Map;
                    if (data['status']) {
                      return Obx(
                        () {
                          if (_rcmdController.isLoadingMore &&
                              _rcmdController.videoList.isEmpty) {
                            return contentGrid(_rcmdController, []);
                          } else {
                            // 显示视频列表
                            return contentGrid(
                              _rcmdController,
                              _rcmdController.videoList,
                            );
                          }
                        },
                      );
                    } else {
                      return HttpError(
                        errMsg: data['msg'],
                        fn: () {
                          setState(
                            () {
                              _rcmdController.isLoadingMore = true;
                              _futureBuilderFuture =
                                  _rcmdController.queryRcmdFeed('init');
                            },
                          );
                        },
                      );
                    }
                  } else {
                    return contentGrid(_rcmdController, []);
                  }
                },
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget contentGrid(ctr, videoList) {
    int crossAxisCount = ctr.crossAxisCount.value;
    double mainAxisExtent = (Get.size.width /
            crossAxisCount /
            StyleString.aspectRatio) +
        (crossAxisCount == 1 ? 68 : MediaQuery.textScalerOf(context).scale(80));
    return SliverGrid(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        mainAxisSpacing: StyleString.safeSpace,
        crossAxisSpacing: StyleString.safeSpace,
        crossAxisCount: crossAxisCount,
        mainAxisExtent: mainAxisExtent,
      ),
      delegate: SliverChildBuilderDelegate(
        (BuildContext context, int index) {
          return videoList!.isNotEmpty
              ? VideoCardComponent(
                  video: videoList[index],
                )
              : const VideoCardVSkeleton();
        },
        childCount: videoList!.isNotEmpty ? videoList!.length : 10,
      ),
    );
  }
}
