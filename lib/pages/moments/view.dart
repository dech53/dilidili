import 'package:custom_sliding_segmented_control/custom_sliding_segmented_control.dart';
import 'package:dilidili/common/skeleton/dynamic_card.dart';
import 'package:dilidili/common/widgets/http_error.dart';
import 'package:dilidili/common/widgets/no_data.dart';
import 'package:dilidili/model/dynamics/result.dart';
import 'package:dilidili/pages/moments/controller.dart';
import 'package:dilidili/pages/moments/widgets/dynamic_panel.dart';
import 'package:dilidili/pages/moments/widgets/up_panel.dart';
import 'package:dilidili/utils/storage.dart';
import 'package:easy_debounce/easy_throttle.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';

class MomentsPage extends StatefulWidget {
  const MomentsPage({super.key});

  @override
  State<MomentsPage> createState() => _MomentsPageState();
}

class _MomentsPageState extends State<MomentsPage>
    with AutomaticKeepAliveClientMixin {
  final MomentsController _momentsController = Get.put(MomentsController());
  late Future _futureBuilderFuture;
  late Future _futureBuilderFutureUp;
  Box userInfoCache = SPStorage.userInfo;
  late ScrollController scrollController;
  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    _futureBuilderFuture = _momentsController.queryFollowDynamic();
    _futureBuilderFutureUp = _momentsController.queryFollowUp();
    scrollController = _momentsController.scrollController;
    scrollController.addListener(
      () async {
        if (scrollController.position.pixels >=
            scrollController.position.maxScrollExtent - 200) {
          EasyThrottle.throttle(
              'queryFollowDynamic', const Duration(seconds: 1), () {
            _momentsController.queryFollowDynamic(type: 'onLoad');
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
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        scrolledUnderElevation: 0,
        title: SizedBox(
          height: 34,
          child: Stack(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Obx(
                    () => _momentsController.userLogin.value
                        ? Visibility(
                            visible: _momentsController.mid.value == -1,
                            child: Theme(
                              data: ThemeData(
                                splashColor: Colors.transparent,
                                highlightColor: Colors.transparent,
                              ),
                              child: CustomSlidingSegmentedControl<int>(
                                initialValue:
                                    _momentsController.initialValue.value,
                                children: {
                                  0: Text(
                                    '全部',
                                    style: TextStyle(
                                        fontSize: Theme.of(context)
                                            .textTheme
                                            .labelMedium!
                                            .fontSize),
                                  ),
                                  1: Text('投稿',
                                      style: TextStyle(
                                          fontSize: Theme.of(context)
                                              .textTheme
                                              .labelMedium!
                                              .fontSize)),
                                  2: Text('番剧',
                                      style: TextStyle(
                                          fontSize: Theme.of(context)
                                              .textTheme
                                              .labelMedium!
                                              .fontSize)),
                                  3: Text('专栏',
                                      style: TextStyle(
                                          fontSize: Theme.of(context)
                                              .textTheme
                                              .labelMedium!
                                              .fontSize)),
                                },
                                padding: 13.0,
                                decoration: BoxDecoration(
                                  color: Theme.of(context)
                                      .colorScheme
                                      .surfaceVariant
                                      .withOpacity(0.7),
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                thumbDecoration: BoxDecoration(
                                  color: Theme.of(context).colorScheme.surface,
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                duration: const Duration(milliseconds: 300),
                                curve: Curves.easeInOut,
                                onValueChanged: (v) {
                                  // _momentsController.onSelectType(v);
                                },
                              ),
                            ),
                          )
                        : Text('动态',
                            style: Theme.of(context).textTheme.titleMedium),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
      body: RefreshIndicator(
        onRefresh: () => _momentsController.onRefresh(),
        child: CustomScrollView(
          controller: _momentsController.scrollController,
          slivers: [
            FutureBuilder(
              future: _futureBuilderFutureUp,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  if (snapshot.data == null) {
                    return const SliverToBoxAdapter(child: SizedBox());
                  }
                  Map data = snapshot.data;
                  if (data['status']) {
                    return Obx(
                      () => UpPanel(
                        upData: _momentsController.upData.value,
                        onClickUpCb: (data) {},
                      ),
                    );
                  } else {
                    return const SliverToBoxAdapter(
                      child: SizedBox(height: 80),
                    );
                  }
                } else {
                  return const SliverToBoxAdapter(
                      child: SizedBox(
                    height: 90,
                    child: UpPanelSkeleton(),
                  ));
                }
              },
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
                    List<DynamicItemModel> list =
                        _momentsController.dynamicsList;
                    return Obx(
                      () {
                        if (list.isEmpty) {
                          if (_momentsController.isLoadingDynamic.value) {
                            return skeleton();
                          } else {
                            return const NoData();
                          }
                        } else {
                          return SliverList(
                            delegate: SliverChildBuilderDelegate(
                              (context, index) {
                                return DynamicPanel(item: list[index]);
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
                      fn: () {
                        if (data?['code'] == -101) {
                          // RoutePush.loginRedirectPush();
                        } else {
                          setState(() {
                            _futureBuilderFuture =
                                _momentsController.queryFollowDynamic();
                            _futureBuilderFutureUp =
                                _momentsController.queryFollowUp();
                          });
                        }
                      },
                    );
                  }
                } else {
                  return skeleton();
                }
              },
            ),
            const SliverToBoxAdapter(child: SizedBox(height: 40))
          ],
        ),
      ),
    );
  }

  Widget skeleton() {
    return SliverList(
      delegate: SliverChildBuilderDelegate((context, index) {
        return const DynamicCardSkeleton();
      }, childCount: 5),
    );
  }
}
