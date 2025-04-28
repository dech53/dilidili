import 'package:cached_network_image/cached_network_image.dart';
import 'package:dilidili/common/constants.dart';
import 'package:dilidili/common/skeleton/video_card_v.dart';
import 'package:dilidili/common/widgets/http_error.dart';
import 'package:dilidili/model/live/following_item.dart';
import 'package:dilidili/pages/live/controller.dart';
import 'package:dilidili/pages/live/widgets/live_item.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LivePage extends StatefulWidget {
  const LivePage({super.key});

  @override
  State<LivePage> createState() => _LivePageState();
}

class _LivePageState extends State<LivePage>
    with AutomaticKeepAliveClientMixin {
  final LiveController _liveController = Get.put(LiveController());
  late Future _futureBuilderFuture;
  late Future _futureBuilderFuture2;
  late ScrollController scrollController;
  @override
  bool get wantKeepAlive => true;
  @override
  void initState() {
    super.initState();
    _futureBuilderFuture = _liveController.queryLiveList('init');
    _futureBuilderFuture2 = _liveController.fetchLiveFollowing();
    scrollController = _liveController.scrollController;
    scrollController.addListener(
      () {
        if (scrollController.position.pixels >=
            scrollController.position.maxScrollExtent - 200) {
          _liveController.onLoad();
        }
      },
    );
  }

  @override
  void dispose() {
    // scrollController.removeListener(() {});
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      clipBehavior: Clip.hardEdge,
      margin: const EdgeInsets.only(
          left: StyleString.safeSpace, right: StyleString.safeSpace),
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.all(StyleString.imgRadius),
      ),
      child: RefreshIndicator(
        onRefresh: () async {
          return await _liveController.onRefresh();
        },
        child: CustomScrollView(
          controller: _liveController.scrollController,
          slivers: [
            FollowingList(),
            SliverPadding(
              padding:
                  const EdgeInsets.fromLTRB(0, StyleString.safeSpace, 0, 0),
              sliver: FutureBuilder(
                future: _futureBuilderFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.done) {
                    if (snapshot.data == null) {
                      return const SliverToBoxAdapter(child: SizedBox());
                    }
                    Map data = snapshot.data as Map;
                    if (data['status']) {
                      return SliverLayoutBuilder(
                          builder: (context, boxConstraints) {
                        return Obx(
                          () => contentGrid(
                            _liveController,
                            _liveController.liveRcmdList,
                          ),
                        );
                      });
                    } else {
                      return HttpError(
                        errMsg: data['msg'],
                        fn: () {
                          setState(
                            () {
                              _futureBuilderFuture =
                                  _liveController.queryLiveList('init');
                            },
                          );
                        },
                      );
                    }
                  } else {
                    return contentGrid(
                      _liveController,
                      [],
                    );
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget contentGrid(ctr, liveList) {
    int crossAxisCount = ctr.crossAxisCount.value;
    return SliverGrid(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        // 行间距
        mainAxisSpacing: StyleString.safeSpace,
        // 列间距
        crossAxisSpacing: StyleString.safeSpace,
        // 列数
        crossAxisCount: crossAxisCount,
        mainAxisExtent:
            Get.size.width / crossAxisCount / StyleString.aspectRatio +
                MediaQuery.textScalerOf(context).scale(
                  (crossAxisCount == 1 ? 48 : 68),
                ),
      ),
      delegate: SliverChildBuilderDelegate(
        (BuildContext context, int index) {
          return liveList!.isNotEmpty
              ? LiveCardV(
                  liveItem: liveList[index],
                  crossAxisCount: crossAxisCount,
                )
              : const VideoCardVSkeleton();
        },
        childCount: liveList!.isNotEmpty ? liveList!.length : 10,
      ),
    );
  }

  Widget FollowingList() {
    return SliverPadding(
      padding: const EdgeInsets.only(top: 16),
      sliver: SliverToBoxAdapter(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Obx(
              () => Text.rich(
                TextSpan(
                  children: [
                    const TextSpan(
                      text: ' 我的关注 ',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                      ),
                    ),
                    TextSpan(
                      text: ' ${_liveController.liveFollowingList.length}',
                      style: TextStyle(
                        fontSize: 12,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    ),
                    TextSpan(
                      text: '人正在直播',
                      style: TextStyle(
                        fontSize: 12,
                        color: Theme.of(context).colorScheme.outline,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            FutureBuilder(
              future: _futureBuilderFuture2,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  if (snapshot.data == null) {
                    return const SizedBox();
                  }
                  Map? data = snapshot.data;
                  if (data?['status']) {
                    RxList list = _liveController.liveFollowingList;
                    // ignore: invalid_use_of_protected_member
                    return Obx(() => LiveFollowingListView(list: list.value));
                  } else {
                    return SizedBox(
                      height: 80,
                      child: Center(
                        child: Text(
                          data?['msg'] ?? '',
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.outline,
                            fontSize: 12,
                          ),
                        ),
                      ),
                    );
                  }
                } else {
                  return const SizedBox();
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}

class LiveFollowingListView extends StatelessWidget {
  final List list;

  const LiveFollowingListView({super.key, required this.list});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 100,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemBuilder: (context, index) {
          final FollowingLiveItem item = list[index];
          return Padding(
            padding: const EdgeInsets.fromLTRB(3, 12, 3, 0),
            child: Column(
              children: [
                InkWell(
                  onTap: () {
                    Get.toNamed(
                      '/liveRoom?roomid=${item.roomid}',
                      arguments: {
                        'liveItem': item,
                        'heroTag': item.roomid.toString()
                      },
                    );
                  },
                  child: Container(
                    width: 54,
                    height: 54,
                    padding: const EdgeInsets.all(2),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(27),
                      border: Border.all(
                        color: Theme.of(context).colorScheme.primary,
                        width: 1.5,
                      ),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(50),
                      child: CachedNetworkImage(
                        imageUrl: item.face!,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 6),
                SizedBox(
                  width: 62,
                  child: Text(
                    item.uname!,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 12,
                    ),
                  ),
                ),
              ],
            ),
          );
        },
        itemCount: list.length,
      ),
    );
  }
}
