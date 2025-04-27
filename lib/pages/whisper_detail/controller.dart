import 'dart:convert';

import 'package:dilidili/http/message.dart';
import 'package:dilidili/model/message/session.dart';
import 'package:dilidili/pages/whisper/controller.dart';
import 'package:dilidili/utils/storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:get/get.dart';

class WhisperDetailController extends GetxController {
  int? talkerId;
  late String name;
  late String face;
  late String mid;
  late String heroTag;
  late String localUserID;
  RxList<MessageItem> messageList = <MessageItem>[].obs;
  final TextEditingController replyContentController = TextEditingController();
  List emoteList = [];
  List<String> picList = [];
  //表情转换图片规则
  RxList<dynamic> eInfos = [].obs;
  @override
  void onInit() {
    super.onInit();
    localUserID = SPStorage.userID;
    if (Get.parameters.containsKey('talkerId')) {
      talkerId = int.parse(Get.parameters['talkerId']!);
    } else {
      talkerId = int.parse(Get.parameters['mid']!);
    }
    name = Get.parameters['name']!;
    face = Get.parameters['face']!;
    mid = Get.parameters['mid']!;
    heroTag = Get.parameters['heroTag']!;
  }

  Future querySessionMsg() async {
    var res = await MsgHttp.sessionMsg(talkerId: talkerId);
    if (res['status']) {
      messageList.value = res['data'].messages;
      // 找出图片
      try {
        for (var item in messageList) {
          if (item.msgType == 2) {
            picList.add(item.content['url']);
          }
        }
        picList = picList.reversed.toList();
      } catch (e) {
        print('e: $e');
      }

      if (messageList.isNotEmpty) {
        if (res['data'].eInfos != null) {
          eInfos.value = res['data'].eInfos;
        }
      }
    } else {
      SmartDialog.showToast(res['msg']);
    }
    return res;
  }

  Future sendMsg() async {
    String message = replyContentController.text;
    if (message == '') {
      SmartDialog.showToast('请输入内容');
      return;
    }
    var result = await MsgHttp.sendMsg(
      senderUid: int.parse(localUserID),
      receiverId: int.parse(mid),
      content: {'content': message},
      msgType: 1,
    );
    if (result['status']) {
      String content = jsonDecode(result['data']['msg_content'])['content'];
      messageList.insert(
        0,
        MessageItem(
          msgSeqno: result['data']['msg_key'],
          senderUid: int.parse(localUserID),
          receiverId: int.parse(mid),
          content: {'content': content},
          msgType: 1,
          timestamp: DateTime.now().millisecondsSinceEpoch,
        ),
      );
      replyContentController.clear();
      try {
        late final WhisperController whisperController =
            Get.find<WhisperController>();
        whisperController.refreshLastMsg(talkerId!, message);
      } catch (_) {}
      SmartDialog.showToast('发送成功');
    } else {
      SmartDialog.showToast(result['msg']);
    }
  }
}
