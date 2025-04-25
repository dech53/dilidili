import 'package:dilidili/http/search.dart';
import 'package:dilidili/model/search_type.dart';
import 'package:dilidili/utils/log_utils.dart';
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
    }
    return result;
  }
}
