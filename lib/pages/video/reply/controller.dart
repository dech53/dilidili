import 'package:dilidili/common/reply_sort_type.dart';
import 'package:dilidili/common/reply_type.dart';
import 'package:dilidili/http/reply.dart';
import 'package:dilidili/model/reply/item.dart';
import 'package:easy_debounce/easy_throttle.dart';
import 'package:get/get.dart';

class VideoReplyController extends GetxController {
  VideoReplyController(
    this.aid,
    this.rpid,
    this.replyLevel,
  );

  @override
  void onInit() {
    super.onInit();
    _sortType = ReplySortType.values[0];
    sortTypeTitle.value = _sortType.titles;
    sortTypeLabel.value = _sortType.labels;
  }

  int ps = 20;
  bool isLoadingMore = false;
  int currentPage = 0;
  RxString noMore = ''.obs;
  RxList<ReplyItemModel> replyList = <ReplyItemModel>[].obs;
  ReplySortType _sortType = ReplySortType.time;
  RxString sortTypeTitle = ReplySortType.time.titles.obs;
  RxString sortTypeLabel = ReplySortType.time.labels.obs;
  int? aid;
  String? replyLevel;
  RxInt count = 0.obs;
  String? rpid;
  Future onLoad() async {
    queryReplyList(type: 'onLoad');
  }

  Future queryReplyList({type = 'init'}) async {
    if (isLoadingMore) {
      return;
    }
    isLoadingMore = true;
    if (type == 'init') {
      currentPage = 0;
      noMore.value = '';
    }
    if (noMore.value == '没有更多了') {
      isLoadingMore = false;
      return;
    }
    final res = await ReplyHttp.replyList(
      oid: aid!,
      pageNum: currentPage + 1,
      ps: ps,
      type: ReplyType.video.index,
      sort: _sortType.index,
    );
    if (res['status']) {
      final List<ReplyItemModel> replies = res['data'].replies;
      if (replies.isNotEmpty) {
        noMore.value = '加载中...';
        if (currentPage == 0 && replies.length < 18) {
          noMore.value = '没有更多了';
        }
        currentPage++;
        if (replyList.length == res['data'].page.acount) {
          noMore.value = '没有更多了';
        }
      } else {
        noMore.value = currentPage == 0 ? '还没有评论' : '没有更多了';
      }
      if (type == 'init') {
        if (res['data'].upper.top != null) {
          final bool flag = res['data'].topReplies.any((ReplyItemModel reply) =>
              reply.rpid == res['data'].upper.top.rpid) as bool;
          if (!flag) {
            replies.insert(0, res['data'].upper.top);
          }
        }
        replies.insertAll(0, res['data'].topReplies);
        count.value = res['data'].page.count;
        replyList.value = replies;
      } else {
        replyList.addAll(replies);
      }
    }
    isLoadingMore = false;
    return res;
  }

  queryBySort() {
    EasyThrottle.throttle('queryBySort', const Duration(seconds: 1), () {
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
      currentPage = 0;
      noMore.value = '';
      replyList.clear();
      queryReplyList(type: 'init');
    });
  }
}
