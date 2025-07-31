import 'package:dilidili/http/search.dart';
import 'package:dilidili/model/search/hot.dart';
import 'package:dilidili/model/search/suggest.dart';
import 'package:dilidili/utils/storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_rx/src/rx_workers/utils/debouncer.dart';
import 'package:hive/hive.dart';

class SSearchController extends GetxController {
  final FocusNode searchFocusNode = FocusNode();
  RxString searchKeyWord = ''.obs;
  String hintText = '搜索';
  RxList historyList = [].obs;
  Box histiryWord = SPStorage.historyword;
  List historyCacheList = [];
  Rx<TextEditingController> controller = TextEditingController().obs;
  bool enableHotKey = true;
  RxList<HotSearchItem> hotSearchList = <HotSearchItem>[].obs;
  RxList<SearchSuggestItem> searchSuggestList = <SearchSuggestItem>[].obs;
  final _debouncer =
      Debouncer(delay: const Duration(milliseconds: 200)); // 设置延迟时间

  @override
  void onInit() {
    super.onInit();
    historyCacheList = histiryWord.get('cacheList') ?? [];
    historyList.value = historyCacheList;
  }

  //清除搜索关键字
  void onClear() {
    if (searchKeyWord.value.isNotEmpty && controller.value.text != '') {
      controller.value.clear();
      searchKeyWord.value = '';
      searchSuggestList.value = [];
    } else {
      Get.back();
    }
  }

  onSelect(word) {
    searchKeyWord.value = word;
    controller.value.text = word;
    submit();
  }

  onLongSelect(word) {
    int index = historyList.indexOf(word);
    historyList.removeAt(index);
    historyList.refresh();
  }

  //输入的搜索关键字
  void onChange(value) {
    searchKeyWord.value = value;
    if (value == '') {
      searchSuggestList.value = [];
      return;
    }
    //延时触发
    _debouncer.call(() => querySearchSuggest(value));
  }

  // 发起搜索
  void submit() {
    // ignore: unrelated_type_equality_checks
    if (searchKeyWord == '') {
      return;
    }
    List arr = historyCacheList.where((e) => e != searchKeyWord.value).toList();
    arr.insert(0, searchKeyWord.value);
    historyCacheList = arr;

    historyList.value = historyCacheList;
    // 手动刷新
    historyList.refresh();
    histiryWord.put('cacheList', historyCacheList);
    searchFocusNode.unfocus();
    Get.toNamed('/searchResult', parameters: {'keyword': searchKeyWord.value});
  }

  // 获取热搜关键词
  Future queryHotSearchList() async {
    var result = await SearchHttp.hotSearchList();
    if (result['status']) {
      hotSearchList.value = result['data'].list;
    }
    return result;
  }

  //搜索建议
  Future querySearchSuggest(String value) async {
    var result = await SearchHttp.searchSuggest(term: value);
    if (result['status']) {
      if (result['data'] is SearchSuggestModel) {
        searchSuggestList.value = result['data'].tag;
      }
    }
  }

  //点击热搜、搜索建议
  void onClickKeyword(String keyword) {
    searchKeyWord.value = keyword;
    controller.value.text = keyword;
    controller.value.selection = TextSelection.fromPosition(
      TextPosition(offset: controller.value.text.length),
    );
    submit();
  }
}
