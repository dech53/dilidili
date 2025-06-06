import 'package:dilidili/common/constants.dart';
import 'package:dilidili/common/widgets/http_error.dart';
import 'package:dilidili/pages/bangumi/controller.dart';
import 'package:dilidili/pages/bangumi/widgets/bangui_card_s.dart';
import 'package:dilidili/pages/bangumi/widgets/bangumu_card_v.dart';
import 'package:easy_debounce/easy_throttle.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class BangumiPage extends StatefulWidget {
  const BangumiPage({super.key});

  @override
  State<BangumiPage> createState() => _BangumiPageState();
}

class _BangumiPageState extends State<BangumiPage>
    with AutomaticKeepAliveClientMixin {
  final BangumiController _bangumidController = Get.put(BangumiController());
  late Future? _futureBuilderFuture;
  late Future? _futureBuilderFutureFollow;
  late ScrollController scrollController;
  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    scrollController = _bangumidController.scrollController;
    _futureBuilderFuture = _bangumidController.queryBangumiListFeed();
    _futureBuilderFutureFollow = _bangumidController.queryBangumiFollow();
    scrollController.addListener(
      () async {
        if (scrollController.position.pixels >=
            scrollController.position.maxScrollExtent - 200) {
          EasyThrottle.throttle('my-throttler', const Duration(seconds: 1), () {
            _bangumidController.isLoadingMore = true;
            _bangumidController.onLoad();
          });
        }
      },
    );
  }

  @override
  void dispose() {
    scrollController.removeListener(() {});
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () async {
        await _bangumidController.queryBangumiListFeed();
        return _bangumidController.queryBangumiFollow();
      },
      child: CustomScrollView(
        controller: _bangumidController.scrollController,
        slivers: [
          SliverToBoxAdapter(
            child: Obx(
              () => Visibility(
                visible: _bangumidController.userLogin.value,
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(
                          top: StyleString.safeSpace, bottom: 10, left: 16),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            '最近追番',
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                          IconButton(
                            onPressed: () {
                              setState(() {
                                _futureBuilderFutureFollow =
                                    _bangumidController.queryBangumiFollow();
                              });
                            },
                            icon: const Icon(
                              Icons.refresh,
                              size: 20,
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: Get.size.width / 3 / 0.75 +
                          MediaQuery.textScalerOf(context).scale(50.0),
                      child: FutureBuilder(
                        future: _futureBuilderFutureFollow,
                        builder:
                            (BuildContext context, AsyncSnapshot snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.done) {
                            if (snapshot.data == null) {
                              return const SizedBox();
                            }
                            Map data = snapshot.data as Map;
                            List list = _bangumidController.bangumiFollowList;
                            if (data['status']) {
                              return Obx(
                                () => list.isNotEmpty
                                    ? ListView.builder(
                                        scrollDirection: Axis.horizontal,
                                        itemCount: list.length,
                                        itemBuilder: (context, index) {
                                          return Container(
                                            width: Get.size.width / 3,
                                            margin: EdgeInsets.only(
                                                left: StyleString.safeSpace,
                                                right: index ==
                                                        _bangumidController
                                                                .bangumiFollowList
                                                                .length -
                                                            1
                                                    ? StyleString.safeSpace
                                                    : 0),
                                            child: BangumiCardV(
                                              bangumiItem: _bangumidController
                                                  .bangumiFollowList[index],
                                            ),
                                          );
                                        },
                                      )
                                    : const SizedBox(
                                        child: Center(
                                          child: Text('还没有追番'),
                                        ),
                                      ),
                              );
                            } else {
                              return const SizedBox();
                            }
                          } else {
                            return ListView.builder(
                              scrollDirection: Axis.horizontal,
                              itemCount: 4,
                              itemBuilder: (context, index) {
                                return Container(
                                  width: Get.size.width / 3,
                                  margin: EdgeInsets.only(
                                      left: StyleString.safeSpace,
                                      right: index ==
                                              _bangumidController
                                                      .bangumiFollowList
                                                      .length -
                                                  1
                                          ? StyleString.safeSpace
                                          : 0),
                                  child: const BangumiCardVSkeleton(),
                                );
                              },
                            );
                          }
                        },
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.only(top: 10, bottom: 10, left: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '推荐',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                ],
              ),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(
                StyleString.safeSpace, 0, StyleString.safeSpace, 0),
            sliver: FutureBuilder(
              future: _futureBuilderFuture,
              builder: (BuildContext context, AsyncSnapshot snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  Map data = snapshot.data as Map;
                  if (data['status']) {
                    return Obx(() => contentGrid(
                        _bangumidController, _bangumidController.bangumiList));
                  } else {
                    return HttpError(
                      errMsg: data['msg'],
                      fn: () {
                        _futureBuilderFuture =
                            _bangumidController.queryBangumiListFeed();
                      },
                    );
                  }
                } else {
                  return contentGrid(_bangumidController, []);
                }
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget contentGrid(ctr, bangumiList) {
    return SliverGrid(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        mainAxisSpacing: StyleString.cardSpace - 2,
        crossAxisSpacing: StyleString.cardSpace,
        crossAxisCount: 3,
        mainAxisExtent: Get.size.width / 3 / 0.75 +
            MediaQuery.textScalerOf(context).scale(42.0),
      ),
      delegate: SliverChildBuilderDelegate(
        (BuildContext context, int index) {
          return bangumiList!.isNotEmpty
              ? BangumiCardV(bangumiItem: bangumiList[index])
              : const BangumiCardVSkeleton();
        },
        childCount: bangumiList!.isNotEmpty ? bangumiList!.length : 10,
      ),
    );
  }
}
