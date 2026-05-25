import 'dart:async';

import 'package:dilidili/common/reply_type.dart';
import 'package:dilidili/common/skeleton/video_reply.dart';
import 'package:dilidili/common/widgets/http_error.dart';
import 'package:dilidili/model/dynamics/result.dart';
import 'package:dilidili/model/reply/item.dart';
import 'package:dilidili/pages/moments/detail/controller.dart';
import 'package:dilidili/pages/moments/widgets/author_panel.dart';
import 'package:dilidili/pages/moments/widgets/moments_panel.dart';
import 'package:dilidili/pages/video/reply/widgets/reply_item.dart';
import 'package:dilidili/pages/video/reply_reply/view.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MomentsDetail extends StatefulWidget {
  const MomentsDetail({super.key});

  @override
  State<MomentsDetail> createState() => _MomentsDetailState();
}

class _MomentsDetailState extends State<MomentsDetail>
    with TickerProviderStateMixin {
  late MomentsDetailController _momentsDetailController;
  late StreamController<bool> titleStreamC = StreamController<bool>.broadcast();
  late ScrollController scrollController;
  late AnimationController fabAnimationCtr; // 回复类型
  Future? _futureBuilderFuture;
  late int replyType;
  bool _visibleTitle = false;
  int oid = 0;
  int? opusId;
  bool isOpusId = false;

  void init() async {
    Map args = Get.arguments;
    // 楼层
    int floor = args['floor'];
    // 评论类型
    int commentType = args['item'].basic!['comment_type'] ?? 11;
    replyType = (commentType == 0) ? 11 : commentType;

    if (floor == 1) {
      oid = int.parse(args['item'].basic!['comment_id_str']);
    } else {
      try {
        ModuleDynamicModel moduleDynamic = args['item'].modules.moduleDynamic;
        String majorType = moduleDynamic.major!.type!;

        if (majorType == 'MAJOR_TYPE_OPUS') {
          // 转发的动态
          String jumpUrl = moduleDynamic.major!.opus!.jumpUrl!;
          opusId = int.parse(jumpUrl.split('/').last);
          if (opusId != null) {
            isOpusId = true;
            _momentsDetailController = Get.put(
                MomentsDetailController(oid, replyType),
                tag: opusId.toString());
            await _momentsDetailController.reqHtmlByOpusId(opusId!);
            setState(() {});
          }
        } else {
          oid = moduleDynamic.major!.draw!.id!;
        }
      } catch (_) {}
    }
    if (!isOpusId) {
      _momentsDetailController =
          Get.put(MomentsDetailController(oid, replyType), tag: oid.toString());
    }
    _futureBuilderFuture = _momentsDetailController.queryReplyList();
  }

  // 查看二级评论
  void replyReply(replyItem, currentReply, loadMore) {
    int oid = replyItem.oid;
    int rpid = replyItem.rpid!;
    Get.to(
      () => Scaffold(
        appBar: AppBar(
          titleSpacing: 0,
          centerTitle: false,
          title: Text(
            '评论详情',
            style: Theme.of(context).textTheme.titleMedium,
          ),
        ),
        body: VideoReplyReplyPanel(
          oid: oid,
          rpid: rpid,
          source: 'dynamic',
          replyType: ReplyType.values[replyType],
          firstFloor: replyItem,
          loadMore: loadMore,
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    init();
    fabAnimationCtr = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    fabAnimationCtr.forward();
    scrollController = _momentsDetailController.scrollController;
    scrollController.addListener(() {
      if (scrollController.position.pixels >=
          scrollController.position.maxScrollExtent - 300) {
        _momentsDetailController.queryReplyList(reqType: 'onLoad');
      }
      if (scrollController.offset > 55 && !_visibleTitle) {
        _visibleTitle = true;
        titleStreamC.add(true);
      } else if (scrollController.offset <= 55 && _visibleTitle) {
        _visibleTitle = false;
        titleStreamC.add(false);
      }
    });
  }

  @override
  void dispose() {
    scrollController.removeListener(() {});
    fabAnimationCtr.dispose();
    scrollController.dispose();
    titleStreamC.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        scrolledUnderElevation: 1,
        centerTitle: false,
        titleSpacing: 0,
        title: StreamBuilder(
          stream: titleStreamC.stream,
          initialData: false,
          builder: (context, AsyncSnapshot snapshot) {
            return AnimatedOpacity(
              opacity: snapshot.data ? 1 : 0,
              duration: const Duration(milliseconds: 300),
              child: AuthorPanel(item: _momentsDetailController.item),
            );
          },
        ),
      ),
      body: RefreshIndicator(
        onRefresh: () async {},
        child: CustomScrollView(
          controller: scrollController,
          slivers: [
            SliverToBoxAdapter(
              child: MomentsPanel(
                item: _momentsDetailController.item,
                source: 'detail',
                floor: Get.arguments['floor'],
              ),
            ),
            SliverPersistentHeader(
              delegate: _MySliverPersistentHeaderDelegate(
                child: Container(
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.surface,
                    border: Border(
                      top: BorderSide(
                        width: 0.6,
                        color: Theme.of(context).dividerColor.withOpacity(0.05),
                      ),
                    ),
                  ),
                  height: 45,
                  padding: const EdgeInsets.only(left: 12, right: 6),
                  child: Row(
                    children: [
                      Obx(
                        () => AnimatedSwitcher(
                          duration: const Duration(milliseconds: 400),
                          transitionBuilder:
                              (Widget child, Animation<double> animation) {
                            return ScaleTransition(
                                scale: animation, child: child);
                          },
                          child: Text(
                            '${_momentsDetailController.acount.value}',
                            key: ValueKey<int>(
                                _momentsDetailController.acount.value),
                          ),
                        ),
                      ),
                      const Text('条回复'),
                      const Spacer(),
                      SizedBox(
                        height: 35,
                        child: TextButton.icon(
                          onPressed: () =>
                              _momentsDetailController.queryBySort(),
                          icon: const Icon(Icons.sort, size: 16),
                          label: Obx(() => Text(
                                _momentsDetailController.sortTypeLabel.value,
                                style: const TextStyle(fontSize: 13),
                              )),
                        ),
                      )
                    ],
                  ),
                ),
              ),
              pinned: true,
            ),
            FutureBuilder(
              future: _futureBuilderFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  Map data = snapshot.data as Map;
                  if (snapshot.data['status']) {
                    RxList<ReplyItemModel> replyList =
                        _momentsDetailController.replyList;
                    // 请求成功
                    return Obx(
                      () => replyList.isEmpty &&
                              _momentsDetailController.isLoadingMore
                          ? SliverList(
                              delegate:
                                  SliverChildBuilderDelegate((context, index) {
                                return const VideoReplySkeleton();
                              }, childCount: 8),
                            )
                          : SliverList(
                              delegate: SliverChildBuilderDelegate(
                                (context, index) {
                                  if (index == replyList.length) {
                                    return Container(
                                      padding: EdgeInsets.only(
                                          bottom: MediaQuery.of(context)
                                              .padding
                                              .bottom),
                                      height: MediaQuery.of(context)
                                              .padding
                                              .bottom +
                                          100,
                                      child: Center(
                                        child: Obx(
                                          () => Text(
                                            _momentsDetailController
                                                .noMore.value,
                                            style: TextStyle(
                                              fontSize: 12,
                                              color: Theme.of(context)
                                                  .colorScheme
                                                  .outline,
                                            ),
                                          ),
                                        ),
                                      ),
                                    );
                                  } else {
                                    return ReplyItem(
                                      replyItem: replyList[index],
                                      showReplyRow: true,
                                      replyLevel: '1',
                                      replyType: ReplyType.values[replyType],
                                      replyReply:
                                          (replyItem, currentReply, loadMore) =>
                                              replyReply(replyItem,
                                                  currentReply, loadMore),
                                      addReply: (replyItem) {
                                        replyList[index]
                                            .replies!
                                            .add(replyItem);
                                      },
                                    );
                                  }
                                },
                                childCount: replyList.length + 1,
                              ),
                            ),
                    );
                  } else {
                    // 请求错误
                    return HttpError(
                      errMsg: data['msg'],
                      fn: () => setState(() {}),
                    );
                  }
                } else {
                  // 骨架屏
                  return SliverList(
                    delegate: SliverChildBuilderDelegate((context, index) {
                      return const VideoReplySkeleton();
                    }, childCount: 8),
                  );
                }
              },
            )
          ],
        ),
      ),
    );
  }
}

class _MySliverPersistentHeaderDelegate extends SliverPersistentHeaderDelegate {
  final double _minExtent = 45;
  final double _maxExtent = 45;
  final Widget child;

  _MySliverPersistentHeaderDelegate({required this.child});

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    //创建child子组件
    //shrinkOffset：child偏移值minExtent~maxExtent
    //overlapsContent：SliverPersistentHeader覆盖其他子组件返回true，否则返回false
    return child;
  }

  //SliverPersistentHeader最大高度
  @override
  double get maxExtent => _maxExtent;

  //SliverPersistentHeader最小高度
  @override
  double get minExtent => _minExtent;

  @override
  bool shouldRebuild(covariant _MySliverPersistentHeaderDelegate oldDelegate) {
    return true;
  }
}
