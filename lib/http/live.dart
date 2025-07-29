import 'package:dilidili/http/dio_instance.dart';
import 'package:dilidili/http/static/api_string.dart';
import 'package:dilidili/model/live/following_item.dart';
import 'package:dilidili/model/live/rcmd_item.dart';
import 'package:dilidili/model/live/room_info.dart';
import 'package:dilidili/model/live/room_info_h5.dart';
import 'package:dilidili/utils/wbi_utils.dart';

class LiveHttp {
  static Future liveList({int? vmid, String? orderType}) async {
    var res = await DioInstance.instance().get(
        path: ApiString.live_base + ApiString.getliveRecommend,
        param: {'platform': 'web'});
    if (res.data['code'] == 0) {
      return {
        'status': true,
        'data': res.data['data']['recommend_room_list']
            .map<RecommendLiveItem>((e) => RecommendLiveItem.fromJson(e))
            .toList()
      };
    } else {
      return {
        'status': false,
        'data': [],
        'msg': res.data['message'],
      };
    }
  }

  // 获取弹幕信息
  static Future liveDanmakuInfo({roomId}) async {
    var res = await DioInstance.instance().get(
      path:
          ApiString.live_base + ApiString.getDanmuInfo,
      param: await WbiUtils.getWbi(
        {
          'id': roomId,
        },
      ),
      extra: {'ua': 'pc'},
    );
    print("LiveDanmakuInfo: ${res.data}");
    if (res.data['code'] == 0) {
      return {
        'status': true,
        'data': res.data['data'],
      };
    } else {
      return {
        'status': false,
        'data': [],
        'msg': res.data['message'],
      };
    }
  }

  // 直播历史记录
  static Future liveRoomEntry({required int roomId}) async {
    await DioInstance.instance().post(
      path: ApiString.live_base + ApiString.liveRoomEntry,
      param: {
        'room_id': roomId,
        'platform': 'pc',
        'csrf_token': await DioInstance.instance().getCsrf(),
        'csrf': await DioInstance.instance().getCsrf(),
        'visit_id': '',
      },
    );
  }

  // 发送弹幕
  static Future sendDanmaku({roomId, msg}) async {
    var res = await DioInstance.instance().post(
      path: ApiString.live_base + ApiString.sendLiveMsg,
      param: {
        'bubble': 0,
        'msg': msg,
        'color': 16777215, // 颜色
        'mode': 1, // 模式
        'room_type': 0,
        'jumpfrom': 71001, // 直播间来源
        'reply_mid': 0,
        'reply_attr': 0,
        'replay_dmid': '',
        'statistics': {"appId": 100, "platform": 5},
        'fontsize': 25, // 字体大小
        'rnd': DateTime.now().millisecondsSinceEpoch ~/ 1000, // 时间戳
        'roomid': roomId,
        'csrf': await DioInstance.instance().getCsrf(),
        'csrf_token': await DioInstance.instance().getCsrf(),
      },
    );
    if (res.data['code'] == 0) {
      return {
        'status': true,
        'data': res.data['data'],
      };
    } else {
      return {
        'status': false,
        'data': [],
        'msg': res.data['message'],
      };
    }
  }

  // 我的关注 正在直播
  static Future liveFollowing({int? pn, int? ps}) async {
    var res = await DioInstance.instance().get(
      path: ApiString.live_base + ApiString.getFollowingLive,
      param: {
        'page': pn,
        'page_size': ps,
        'platform': 'web',
        'ignoreRecord': 1,
        'hit_ab': true,
      },
    );
    if (res.data['code'] == 0) {
      return {
        'status': true,
        'data': FollowingLiveItems.fromJson(res.data['data'])
      };
    } else {
      return {
        'status': false,
        'data': [],
        'msg': res.data['message'],
      };
    }
  }

  static Future liveRoomInfoH5({roomId, qn}) async {
    var res = await DioInstance.instance()
        .get(path: ApiString.live_base + ApiString.liveRoomInfoH5, param: {
      'room_id': roomId,
    });
    if (res.data['code'] == 0) {
      return {
        'status': true,
        'data': RoomInfoH5Model.fromJson(res.data['data'])
      };
    } else {
      return {
        'status': false,
        'data': [],
        'msg': res.data['message'],
      };
    }
  }

  static Future liveRoomInfo({roomId, qn}) async {
    var res = await DioInstance.instance()
        .get(path: ApiString.live_base + ApiString.liveRoomInfo, param: {
      'room_id': roomId,
      'protocol': '0, 1',
      'format': '0, 1, 2',
      'codec': '0, 1',
      'qn': qn,
      'platform': 'web',
      'ptype': 8,
      'dolby': 5,
      'panorama': 1,
    });
    if (res.data['code'] == 0) {
      return {'status': true, 'data': RoomInfoModel.fromJson(res.data['data'])};
    } else {
      return {
        'status': false,
        'data': [],
        'msg': res.data['message'],
      };
    }
  }
}
