import 'package:dilidili/http/dio_instance.dart';
import 'package:dilidili/http/static/api_string.dart';
import 'package:dilidili/model/live/following_item.dart';
import 'package:dilidili/model/live/rcmd_item.dart';
import 'package:dilidili/model/live/room_info.dart';
import 'package:dilidili/model/live/room_info_h5.dart';

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
