import 'package:dilidili/common/reply_sort_type.dart';
import 'package:dilidili/http/html.dart';
import 'package:dilidili/http/reply.dart';
import 'package:dilidili/model/reply/item.dart';
import 'package:dilidili/utils/storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';

class MomentsDetailController extends GetxController {
  MomentsDetailController(this.oid, this.type);
  final ScrollController scrollController = ScrollController();
  dynamic item;
  int? oid;
  int? floor;
  int? type;
  RxInt acount = 0.obs;
  int currentPage = 0;
  bool isLoadingMore = false;
  RxString noMore = ''.obs;
  ReplySortType _sortType = ReplySortType.time;
  RxString sortTypeTitle = ReplySortType.time.titles.obs;
  RxString sortTypeLabel = ReplySortType.time.labels.obs;
  RxList<ReplyItemModel> replyList = <ReplyItemModel>[].obs;
  Box setting = SPStorage.setting;
  RxInt replyReqCode = 200.obs;
  @override
  void onInit() {
    super.onInit();
    item = Get.arguments['item'];
    floor = Get.arguments['floor'];
    if (floor == 1) {
      acount.value =
          int.parse(item!.modules!.moduleStat!.comment!.count ?? '0');
    }
    int deaultReplySortIndex =
        setting.get(SettingBoxKey.replySortType, defaultValue: 0);
    if (deaultReplySortIndex == 2) {
      setting.put(SettingBoxKey.replySortType, 0);
      deaultReplySortIndex = 0;
    }
  }

  Future queryReplyList({reqType = 'init'}) async {
    if (isLoadingMore) {
      return;
    }
    isLoadingMore = true;
    if (reqType == 'init') {
      currentPage = 0;
      noMore.value = '';
    }
    if (noMore.value == '没有更多了') {
      isLoadingMore = false;
      return;
    }
    var res = await ReplyHttp.replyList(
      oid: oid!,
      pageNum: currentPage + 1,
      type: type!,
      sort: _sortType.index,
    );
    if (res['status']) {
      List<ReplyItemModel> replies = res['data'].replies;
      acount.value = res['data'].page.acount;
      if (replies.isNotEmpty) {
        currentPage++;
        noMore.value = '加载中...';
        if (replies.length < 20) {
          noMore.value = '没有更多了';
        }
      } else {
        noMore.value = currentPage == 0 ? '还没有评论' : '没有更多了';
      }
      if (reqType == 'init') {
        // 添加置顶回复
        if (res['data'].upper.top != null) {
          bool flag = res['data']
              .topReplies
              .any((reply) => reply.rpid == res['data'].upper.top.rpid);
          if (!flag) {
            replies.insert(0, res['data'].upper.top);
          }
        }
        replies.insertAll(0, res['data'].topReplies);
        replyList.value = replies;
      } else {
        replyList.addAll(replies);
      }
    }
    replyReqCode.value = res['code'];
    isLoadingMore = false;
    return res;
  }

  // 排序搜索评论
  queryBySort() {
    switch (_sortType) {
      case ReplySortType.time:
        _sortType = ReplySortType.like;
        break;
      case ReplySortType.like:
        _sortType = ReplySortType.time;
        break;
      default:
    }
    sortTypeTitle.value = _sortType.titles;
    sortTypeLabel.value = _sortType.labels;
    replyList.clear();
    queryReplyList(reqType: 'init');
  }

  // 上拉加载
  Future onLoad() async {
    queryReplyList(reqType: 'onLoad');
  }


  // 根据jumpUrl获取动态html
  //存在问题无法获取到正确的oid导致无法加载评论
  reqHtmlByOpusId(int id) async {
    var res = await HtmlHttp.reqHtml(id, 'opus');
    if (res == null || res['commentId'] == null) {
      SmartDialog.showToast('动态评论 oid 解析失败');
      return false;
    }
    oid = res['commentId'];
    return true;
  }
}
