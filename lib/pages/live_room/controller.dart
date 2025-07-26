import 'dart:async';
import 'dart:convert';

import 'package:dilidili/http/dio_instance.dart';
import 'package:dilidili/http/live.dart';
import 'package:dilidili/http/static/api_string.dart';
import 'package:dilidili/model/live/message.dart';
import 'package:dilidili/model/live/quality.dart';
import 'package:dilidili/model/live/room_info.dart';
import 'package:dilidili/model/live/room_info_h5.dart';
import 'package:dilidili/pages/dplayer/controller.dart';
import 'package:dilidili/pages/dplayer/models/data_source.dart';
import 'package:dilidili/pages/live_room/utils/dsocket.dart';
import 'package:dilidili/utils/live.dart';
import 'package:dilidili/utils/storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:ns_danmaku/danmaku_controller.dart';
import 'package:ns_danmaku/models/danmaku_item.dart';

class LiveRoomController extends GetxController {
  late int roomId;
  DPlayerController dPlayerController = DPlayerController(videoType: 'live');
  dynamic liveItem;
  RxString currentQnDesc = ''.obs;
  int? tempCurrentQn;
  RxBool isPortrait = false.obs;
  Box userInfoCache = SPStorage.userInfo;
  int userId = 0;
  int currentQn = LiveQuality.values.last.code;
  late String buvid;
  DSocket? dSocket;
  List<String> danmuHostList = [];
  String token = '';
  DanmakuController? danmakuController;
  // 弹幕消息列表
  RxList<LiveMessageModel> messageList = <LiveMessageModel>[].obs;
  // 输入控制器
  TextEditingController inputController = TextEditingController();
  // 加入直播间提示
  RxMap<String, String> joinRoomTip = {'userName': '', 'message': ''}.obs;
  late List<Map<String, dynamic>> acceptQnList;
  // 直播间弹幕开关 默认打开
  RxBool danmakuSwitch = true.obs;

  Rx<RoomInfoH5Model> roomInfoH5 = RoomInfoH5Model().obs;
  Future queryLiveInfoH5() async {
    var res = await LiveHttp.liveRoomInfoH5(roomId: roomId);
    if (res['status']) {
      roomInfoH5.value = res['data'];
    }
    return res;
  }

  Future queryLiveInfo() async {
    var res = await LiveHttp.liveRoomInfo(roomId: roomId, qn: currentQn);
    if (res['status']) {
      isPortrait.value = res['data'].isPortrait;
      List<CodecItem> codec =
          res['data'].playurlInfo.playurl.stream.first.format.first.codec;
      CodecItem item = codec.first;
      currentQn = item.currentQn!;
      if (tempCurrentQn != null && tempCurrentQn == currentQn) {
        SmartDialog.showToast('画质切换失败，请检查登录状态');
      }
      List acceptQn = item.acceptQn!;
      acceptQnList = acceptQn.map((e) {
        return {
          'code': e,
          'desc': LiveQuality.values
              .firstWhere((element) => element.code == e)
              .description,
        };
      }).toList();
      currentQnDesc.value = LiveQuality.values
          .firstWhere((element) => element.code == currentQn)
          .description;
      String videoUrl = (item.urlInfo?.first.host)! +
          item.baseUrl! +
          item.urlInfo!.first.extra!;
      await playerInit(videoUrl);
      return res;
    }
  }

  Future liveDanmakuInfo() async {
    var res = await LiveHttp.liveDanmakuInfo(roomId: roomId);
    if (res['status']) {
      danmuHostList = (res["data"]["host_list"] as List)
          .map<String>((e) => '${e["host"]}:${e['wss_port']}')
          .toList();
      token = res["data"]["token"];
      print("弹幕服务器地址: $roomId的token是: $token");
      return res;
    }
  }

  playerInit(source) async {
    await dPlayerController.setDataSource(
      DataSource(
        videoSource: source,
        audioSource: null,
        type: DataSourceType.network,
        httpHeaders: {
          'user-agent':
              'Mozilla/5.0 (Macintosh; Intel Mac OS X 13_3_1) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/16.4 Safari/605.1.15',
          'referer': ApiString.mainUrl
        },
      ),
    );
  }

  void initSocket() async {
    final wsUrl = danmuHostList.isNotEmpty
        ? danmuHostList.first
        : "broadcastlv.chat.bilibili.com:443";
    dSocket = DSocket(
      url: 'wss://$wsUrl/sub',
      heartTime: 30,
      onReadyCb: () {
        joinRoom();
      },
      onMessageCb: (message) {
        final List<LiveMessageModel>? liveMsg =
            LiveUtils.decodeMessage(message);
        if (liveMsg != null && liveMsg.isNotEmpty) {
          if (liveMsg.first.type == LiveMessageType.online) {
            print('当前直播间人气：${liveMsg.first.data}');
          } else if (liveMsg.first.type == LiveMessageType.join ||
              liveMsg.first.type == LiveMessageType.follow) {
            // 每隔一秒依次liveMsg中的每一项赋给activeUserName

            int index = 0;
            Timer.periodic(const Duration(seconds: 2), (timer) {
              if (index < liveMsg.length) {
                if (liveMsg[index].type == LiveMessageType.join ||
                    liveMsg[index].type == LiveMessageType.follow) {
                  joinRoomTip.value = {
                    'userName': liveMsg[index].userName,
                    'message': liveMsg[index].message!,
                  };
                }
                index++;
              } else {
                timer.cancel();
              }
            });

            return;
          }
          // 过滤出聊天消息
          var chatMessages =
              liveMsg.where((msg) => msg.type == LiveMessageType.chat).toList();
          // 添加到 messageList
          messageList.addAll(chatMessages);
          // 将 chatMessages 转换为 danmakuItems 列表
          List<DanmakuItem> danmakuItems = chatMessages.map<DanmakuItem>((e) {
            return DanmakuItem(
              e.message ?? '',
              color: Color.fromARGB(
                255,
                e.color.r,
                e.color.g,
                e.color.b,
              ),
            );
          }).toList();

          // 添加到 danmakuController
          if (danmakuSwitch.value) {
            danmakuController?.addItems(danmakuItems);
          }
        }
      },
      onErrorCb: (e) {
        print('error: $e');
      },
    );
    await dSocket?.connect();
  }

  void joinRoom() async {
    var joinData = LiveUtils.encodeData(
      json.encode({
        "uid": userId,
        "roomid": roomId,
        "protover": 3,
        "buvid": '2C79183B-D96A-5418-7EFB-2AC765933C8706972infoc',
        "platform": "web",
        "type": 2,
        "key": token,
      }),
      7,
    );
    dSocket?.sendMessage(joinData);
  }

  // 历史记录
  void heartBeat() {
    LiveHttp.liveRoomEntry(roomId: roomId);
  }

  // 发送弹幕
  void sendMsg() async {
    final msg = inputController.text;
    if (msg.isEmpty) {
      return;
    }
    final res = await LiveHttp.sendDanmaku(
      roomId: roomId,
      msg: msg,
    );
    if (res['status']) {
      inputController.clear();
    } else {
      SmartDialog.showToast(res['msg']);
    }
  }

  String encodeToBase64(String input) {
    List<int> bytes = utf8.encode(input);
    String base64Str = base64.encode(bytes);
    return base64Str;
  }

  @override
  void onClose() {
    heartBeat();
    dSocket?.onClose();
    super.onClose();
  }

  @override
  void onInit() {
    super.onInit();
    roomId = int.parse(Get.parameters['roomid']!);
    if (Get.arguments != null) {
      liveItem = Get.arguments['liveItem'];
      DioInstance.instance().getBuvid().then((value) => buvid = value);
    }
    final userInfo = userInfoCache.get('userInfoCache');
    if (userInfo != null && userInfo.mid != null) {
      userId = userInfo.mid;
    }
    print("用户id是: $userId");
    liveDanmakuInfo().then((value) => initSocket());
    danmakuSwitch.listen((p0) {
      dPlayerController.isOpenDanmu.value = p0;
    });
  }
}
