import 'package:dilidili/http/message.dart';
import 'package:dilidili/model/message/account.dart';
import 'package:dilidili/model/message/session.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class WhisperController extends GetxController {
  bool isLoading = false;
  RxList<SessionList> sessionList = <SessionList>[].obs;
  RxList<AccountListModel> accountList = <AccountListModel>[].obs;
  @override
  void onInit() {
    unread();
    super.onInit();
  }

  RxList noticesList = [
    {
      'icon': Icons.message_outlined,
      'title': '回复我的',
      'path': '/messageReply',
      'count': 0,
    },
    {
      'icon': Icons.alternate_email,
      'title': '@我的',
      'path': '/messageAt',
      'count': 0,
    },
    {
      'icon': Icons.thumb_up_outlined,
      'title': '收到的赞',
      'path': '/messageLike',
      'count': 0,
    },
    {
      'icon': Icons.notifications_none_outlined,
      'title': '系统通知',
      'path': '/messageSystem',
      'count': 0,
    }
  ].obs;

  Future querySessionList(String? type) async {
    if (isLoading) return;
    var res = await MsgHttp.sessionList(
        endTs: type == 'onLoad' ? sessionList.last.sessionTs! : null);
    if (res['data'].sessionList != null && res['data'].sessionList.isNotEmpty) {
      await queryAccountList(res['data'].sessionList);
      Map<int, dynamic> accountMap = {};
      for (var j in accountList) {
        accountMap[j.mid!] = j;
      }
      for (var i in res['data'].sessionList) {
        var accountInfo = accountMap[i.talkerId];
        if (accountInfo != null) {
          i.accountInfo = accountInfo;
        }
      }
    }
    if (res['status'] && res['data'].sessionList != null) {
      if (type == 'onLoad') {
        sessionList.addAll(res['data'].sessionList);
      } else {
        sessionList.value = res['data'].sessionList;
      }
    }
    isLoading = false;
    return res;
  }

  Future onRefresh() async {
    querySessionList('onRefresh');
  }

  Future onLoad() async {
    querySessionList('onLoad');
  }

  Future queryAccountList(sessionList) async {
    List midsList = sessionList.map((e) => e.talkerId!).toList();
    var res = await MsgHttp.accountList(midsList.join(','));
    if (res['status']) {
      accountList.value = res['data'];
    }
    return res;
  }

  // 消息未读数
  void unread() async {
    var res = await MsgHttp.unread();
    if (res['status']) {
      noticesList[0]['count'] = res['data']['reply'];
      noticesList[1]['count'] = res['data']['at'];
      noticesList[2]['count'] = res['data']['like'];
      noticesList[3]['count'] = res['data']['sys_msg'];
      noticesList.refresh();
    }
  }

  void refreshLastMsg(int talkerId, String content) {
    final SessionList currentItem =
        sessionList.where((p0) => p0.talkerId == talkerId).first;
    currentItem.lastMsg!.content['content'] = content;
    sessionList.removeWhere((p0) => p0.talkerId == talkerId);
    sessionList.insert(0, currentItem);
    sessionList.refresh();
  }
}
