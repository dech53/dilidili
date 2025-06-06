import 'package:dilidili/common/skeleton/video_card_h.dart';
import 'package:dilidili/common/widgets/http_error.dart';
import 'package:dilidili/model/search_type.dart';
import 'package:dilidili/pages/search_panel/controller.dart';
import 'package:dilidili/pages/search_panel/widgets/article_panel.dart';
import 'package:dilidili/pages/search_panel/widgets/live_panel.dart';
import 'package:dilidili/pages/search_panel/widgets/media_bangumi_panel.dart';
import 'package:dilidili/pages/search_panel/widgets/test_panel.dart';
import 'package:dilidili/pages/search_panel/widgets/user_panel.dart';
import 'package:dilidili/pages/search_panel/widgets/video_panel.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:easy_debounce/easy_throttle.dart';

class SearchPanel extends StatefulWidget {
  const SearchPanel(
      {required this.keyword, required this.searchType, this.tag, Key? key})
      : super(key: key);
  final SearchType? searchType;
  final String? tag;
  final String? keyword;
  @override
  State<SearchPanel> createState() => _SearchPanelState();
}

class _SearchPanelState extends State<SearchPanel>
    with AutomaticKeepAliveClientMixin {
  late SearchPanelController _searchPanelController;
  late ScrollController scrollController;
  late Future _futureBuilderFuture;
  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    _searchPanelController = Get.put(
      SearchPanelController(
        keyword: widget.keyword,
        searchType: widget.searchType,
      ),
      tag: widget.searchType!.type + widget.keyword!,
    );

    /// 专栏默认排序
    if (widget.searchType == SearchType.article) {
      _searchPanelController.order.value = 'totalrank';
    }

    scrollController = _searchPanelController.scrollController;

    scrollController.addListener(() async {
      if (scrollController.position.pixels >=
          scrollController.position.maxScrollExtent - 100) {
        EasyThrottle.throttle('history', const Duration(seconds: 1), () {
          _searchPanelController.onSearch(type: 'onLoad');
        });
      }
    });
    _futureBuilderFuture = _searchPanelController.onSearch();
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
        await _searchPanelController.onRefresh();
      },
      child: FutureBuilder(
        future: _futureBuilderFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            if (snapshot.data != null) {
              Map data = snapshot.data;
              var ctr = _searchPanelController;
              RxList list = ctr.resultList;
              if (data['status']) {
                return Obx(() {
                  switch (widget.searchType) {
                    case SearchType.video:
                      return SearchVideoPanel(
                        ctr: _searchPanelController,
                        list: list.value,
                      );
                    case SearchType.live_room:
                      return searchLivePanel(context, ctr, list);
                    case SearchType.bili_user:
                      return searchUserPanel(context, ctr, list);
                    case SearchType.media_bangumi:
                      return searchMbangumiPanel(context, ctr, list);
                    case SearchType.article:
                      return SearchArticlePanel(
                        ctr: _searchPanelController,
                        list: list.value,
                      );
                    default:
                      return TestPanel(
                        list: list.value,
                      );
                  }
                });
              } else {
                return CustomScrollView(
                  physics: const NeverScrollableScrollPhysics(),
                  slivers: [
                    HttpError(
                      errMsg: data['msg'],
                      fn: () {
                        setState(() {
                          _searchPanelController.onSearch();
                        });
                      },
                    ),
                  ],
                );
              }
            } else {
              return CustomScrollView(
                physics: const NeverScrollableScrollPhysics(),
                slivers: [
                  HttpError(
                    errMsg: '没有相关数据',
                    fn: () {
                      setState(() {
                        _searchPanelController.onSearch();
                      });
                    },
                  ),
                ],
              );
            }
          } else {
            // 骨架屏
            return ListView.builder(
              addAutomaticKeepAlives: false,
              addRepaintBoundaries: false,
              itemCount: 15,
              itemBuilder: (context, index) => const VideoCardHSkeleton(),
            );
          }
        },
      ),
    );
  }
}
