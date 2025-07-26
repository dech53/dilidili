import 'dart:async';

import 'package:dilidili/utils/live.dart';
import 'package:web_socket_channel/io.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

enum SocketStatus {
  connected,
  failed,
  closed,
}

class DSocket {
  SocketStatus status = SocketStatus.closed;
  // 链接
  final String url;
  // 心跳时间
  final int heartTime;
  // 监听初始化完成
  final Function? onReadyCb;
  // 监听关闭
  final Function? onCloseCb;
  // 监听异常
  final Function? onErrorCb;
  // 监听消息
  final Function? onMessageCb;
  // 请求头
  final Map<String, dynamic>? headers;

  DSocket({
    required this.url,
    required this.heartTime,
    this.onReadyCb,
    this.onCloseCb,
    this.onErrorCb,
    this.onMessageCb,
    this.headers,
  });

  WebSocketChannel? channel;
  StreamSubscription<dynamic>? channelStreamSub;

  // 建立连接
  Future connect() async {
    // 连接之前关闭上次连接
    // onClose();
    try {
      channel = IOWebSocketChannel.connect(
        url,
        connectTimeout: const Duration(seconds: 15),
        headers: {
          'User-Agent':
              'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/15.2 Safari/605.1.15',
          'Origin': 'https://live.bilibili.com',
        },
      );
      await channel?.ready;
      onReady();
    } catch (err) {
      connect();
      onError(err);
    }
  }

  // 初始化完成
  void onReady() {
    status = SocketStatus.connected;
    onReadyCb?.call();
    channelStreamSub = channel?.stream.listen((message) {
      onMessageCb?.call(message);
    }, onDone: () {
      // 流被关闭
      print('结束了');
    }, onError: (err) {
      onError(err);
    });
    // 每30s发送心跳
    Timer.periodic(Duration(seconds: heartTime), (timer) {
      if (status == SocketStatus.connected) {
        sendMessage(LiveUtils.encodeData(
          "",
          2,
        ));
      } else {
        timer.cancel();
      }
    });
  }

  // 连接关闭
  void onClose() {
    status = SocketStatus.closed;
    onCloseCb?.call();
    channelStreamSub?.cancel();
    channel?.sink.close();
  }

  // 连接异常
  void onError(err) {
    onErrorCb?.call(err);
  }

  // 接收消息
  void onMessage() {}

  void sendMessage(dynamic message) {
    if (status == SocketStatus.connected) {
      channel?.sink.add(message);
    }
  }
}
