import 'package:dilidili/http/search.dart';
import 'package:dilidili/model/search_type.dart';
import 'package:dilidili/utils/id_utils.dart';
import 'package:dilidili/utils/string_utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

class SearchPanelController extends GetxController {
  SearchPanelController({this.keyword, this.searchType});
  String? keyword;
  SearchType? searchType;
  RxList resultList = [].obs;
  ScrollController scrollController = ScrollController();
  RxInt page = 1.obs;
  RxString order = ''.obs;
  RxInt duration = 0.obs;
  RxInt tids = (-1).obs;

  // 返回顶部并刷新
  void animateToTop() async {
    if (scrollController.offset >=
        MediaQuery.of(Get.context!).size.height * 5) {
      scrollController.jumpTo(0);
    } else {
      await scrollController.animateTo(0,
          duration: const Duration(milliseconds: 500), curve: Curves.easeInOut);
    }
  }

  Future onRefresh() async {
    page.value = 1;
    await onSearch(type: 'onRefresh');
  }

  Future onSearch({type = 'init'}) async {
    var result = await SearchHttp.searchByType(
      searchType: searchType!,
      keyword: keyword!,
      page: page.value,
      order: !['video', 'article'].contains(searchType!.type)
          ? null
          : (order.value == '' ? null : order.value),
      duration: searchType!.type != 'video' ? null : duration.value,
      tids: searchType!.type != 'video' ? null : tids.value,
    );
    if (result['status']) {
      if (type == 'onRefresh') {
        resultList.value = result['data'].list ?? [];
      } else {
        resultList.addAll(result['data'].list ?? []);
      }
      page.value++;
      resultList.refresh();
      // onPushDetail(keyword, resultList);
    }
    return result;
  }

  void onPushDetail(keyword, resultList) async {
    // 匹配输入内容，如果是AV、BV号且有结果 直接跳转详情页
    Map matchRes = IdUtils.matchAvorBv(input: keyword);
    List matchKeys = matchRes.keys.toList();
    String? bvid;
    String? mid;
    try {
      bvid = resultList.first.bvid;
    } catch (_) {
      bvid = null;
    }
    try {
      mid = resultList.first.mid;
    } catch (_) {
      mid = null;
    }
    // keyword 可能输入纯数字
    int? aid;
    try {
      aid = resultList.first.aid;
    } catch (_) {
      aid = null;
    }
    if (matchKeys.isNotEmpty && searchType == SearchType.video ||
        aid.toString() == keyword) {
      String heroTag = StringUtils.makeHeroTag(bvid);
      int cid = await SearchHttp.ab2c(aid: aid, bvid: bvid);
      if (matchKeys.isNotEmpty &&
              matchKeys.first == 'BV' &&
              matchRes[matchKeys.first] == bvid ||
          matchKeys.isNotEmpty &&
              matchKeys.first == 'AV' &&
              matchRes[matchKeys.first] == aid ||
          aid.toString() == keyword) {
        Get.toNamed(
          '/video?bvid=$bvid&cid=$cid',preventDuplicates: false,
          arguments: {
            'videoItem': resultList.first,
            'heroTag': heroTag,
            'bvid': bvid,
            'cid': cid.toString(),
          },
        );
      }
    }
  }
}
