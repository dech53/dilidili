import 'package:custom_sliding_segmented_control/custom_sliding_segmented_control.dart';
import 'package:dilidili/common/skeleton/dynamic_card.dart';
import 'package:dilidili/common/widgets/http_error.dart';
import 'package:dilidili/common/widgets/no_data.dart';
import 'package:dilidili/http/dynamics.dart';
import 'package:dilidili/model/dynamics/result.dart';
import 'package:dilidili/pages/moments/controller.dart';
import 'package:dilidili/pages/moments/widgets/moments_panel.dart';
import 'package:dilidili/pages/moments/widgets/up_panel.dart';
import 'package:dilidili/utils/storage.dart';
import 'package:easy_debounce/easy_throttle.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
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
  TextEditingController _inputController = TextEditingController();
  FocusNode myFocusNode = FocusNode();
  RxString _inputText = ''.obs;

  RxDouble height = Get.size.height.obs;
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
    _momentsController.userLogin.listen((status) {
      if (mounted) {
        setState(() {
          _futureBuilderFuture = _momentsController.queryFollowDynamic();
          _futureBuilderFutureUp = _momentsController.queryFollowUp();
        });
      }
    });
  }

  void sendMoments() async {
    showModalBottomSheet(
      context: context,
      enableDrag: false,
      useRootNavigator: true,
      isScrollControlled: true,
      builder: (context) {
        return Obx(
          () => AnimatedContainer(
            onEnd: () async {},
            duration: Durations.medium1,
            height: height.value + MediaQuery.of(context).padding.bottom,
            child: Column(
              children: [
                AnimatedContainer(
                  duration: Durations.medium1,
                  height: 34,
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(8, 8, 8, 5),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(
                          onPressed: () {
                            Get.back();
                            _momentsController.toggleOption(false);
                            _inputText.value = '';
                            _inputController.clear();
                          },
                          icon: const Icon(Icons.clear)),
                      const Text(
                        "发布动态",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      IconButton(
                        onPressed: () {},
                        icon: const Icon(
                          Icons.remove_red_eye_outlined,
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 10, 16, 0),
                  child: TextField(
                    maxLines: 5,
                    focusNode: myFocusNode,
                    controller: _inputController,
                    onChanged: (value) {
                      setState(() {
                        _inputText.value = value;
                      });
                    },
                    decoration: const InputDecoration(
                      border: InputBorder.none,
                      hintText: '说点什么吧...',
                    ),
                  ),
                ),
                const Spacer(),
                const Divider(
                  color: Colors.grey,
                  thickness: 0.5,
                  height: 4,
                ),
                Padding(
                  padding: EdgeInsets.fromLTRB(
                      8, 5, 12, MediaQuery.of(context).viewInsets.bottom + 5),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Row(
                        children: [
                          TextButton(
                            style: TextButton.styleFrom(
                              foregroundColor:
                                  _momentsController.option.value == 2
                                      ? Colors.red.shade800
                                      : Theme.of(context).colorScheme.primary,
                            ),
                            onPressed: () {
                              _momentsController.toggleOption(true);
                            },
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: <Widget>[
                                Icon(
                                  _momentsController.option.value != 3
                                      ? FontAwesomeIcons.comment
                                      : FontAwesomeIcons.commentDots,
                                  color: _momentsController.option.value == 2
                                      ? Colors.red.shade800
                                      : Theme.of(context).colorScheme.primary,
                                ),
                                5.horizontalSpace,
                                Text(
                                  _momentsController.optionText.value,
                                  style: const TextStyle(
                                    fontSize: 11,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          TextButton(
                            onPressed: () async {
                              SmartDialog.showToast("暂未实现");
                              // if (myFocusNode.hasFocus) {
                              //   myFocusNode.unfocus();
                              // }
                              // final DateTime? date = await showDatePicker(
                              //   context: context,
                              //   initialDate: DateTime.now(),
                              //   firstDate: DateTime(2000),
                              //   lastDate: DateTime(2100),
                              //   locale: const Locale('zh', 'CN'),
                              // );
                              // final TimeOfDay? time = await showTimePicker(
                              //   context: context,
                              //   initialTime: TimeOfDay.now(),
                              // );
                            },
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Icon(Icons.access_time),
                                5.horizontalSpace,
                                Text(
                                  "定时发布",
                                  style: const TextStyle(
                                    fontSize: 11,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          IconButton(
                            onPressed: () {},
                            icon: const Icon(
                              Icons.add_a_photo,
                            ),
                          ),
                          TextButton(
                            onPressed: () async {
                              if (_inputText.value != '') {
                                var res = await DynamicsHttp.createDynamic(
                                  content: _inputText.value,
                                  option: _momentsController.option.value == 1
                                      ? {}
                                      : _momentsController.option.value == 2
                                          ? {'close_comment': 1}
                                          : {'up_choose_comment': 1},
                                );
                                if (res['status']) {
                                  Get.back();
                                  _momentsController.toggleOption(false);
                                  _inputText.value = '';
                                  _inputController.clear();
                                  SmartDialog.showToast('发送成功');
                                } else {
                                  SmartDialog.showToast(res['msg']);
                                }
                              } else {
                                SmartDialog.showToast("主题内容不可为空");
                              }
                            },
                            style: TextButton.styleFrom(
                              foregroundColor: _inputText.value == ''
                                  ? Theme.of(context).colorScheme.outline
                                  : Theme.of(context).colorScheme.onPrimary,
                              backgroundColor: _inputText.value == ''
                                  ? Theme.of(context)
                                      .colorScheme
                                      .onInverseSurface
                                  : Theme.of(context).colorScheme.primary,
                            ),
                            child: const Text(
                              "发布",
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        );
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
    super.build(context);
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        forceMaterialTransparency: true,
        scrolledUnderElevation: 0,
        title: SizedBox(
          height: 34,
          child: Stack(
            alignment: Alignment.center,
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
                                  _momentsController.onSelectType(v);
                                },
                              ),
                            ),
                          )
                        : Text('动态',
                            style: Theme.of(context).textTheme.titleMedium),
                  ),
                ],
              ),
              Positioned(
                right: 0,
                child: IconButton(
                  color: Theme.of(context).colorScheme.primary,
                  onPressed: sendMoments,
                  icon: const Icon(
                    Icons.add,
                  ),
                ),
              ),
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
                                return MomentsPanel(
                                  item: list[index],
                                  floor: 1,
                                );
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
                      fn: () {
                        setState(() {
                          _futureBuilderFuture =
                              _momentsController.queryFollowDynamic();
                          _futureBuilderFutureUp =
                              _momentsController.queryFollowUp();
                        });
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
