import 'package:dilidili/http/dio_instance.dart';
import 'package:dilidili/http/static/api_string.dart';
import 'package:dilidili/model/nav_user_info.dart';
import 'package:dilidili/model/rcmd_video.dart';
import 'package:dilidili/model/root_data.dart';
import 'package:dilidili/model/video/hot_video.dart';
import 'package:dilidili/model/video/related_video.dart';
import 'package:dilidili/model/video/video_basic_info.dart';

class VideoHttp {
  static Future relatedVideoList({required String bvid}) async {
    var res = await DioInstance.instance().get(
      path: ApiString.baseUrl + ApiString.getRelatedVideo,
      param: {"bvid": bvid},
    );
    if (res.data['code'] == 0) {
      var relatedVideo = (res.data['data'] as List<dynamic>)
          .map((e) => RelatedVideoItem.fromJson(e as Map<String, dynamic>))
          .toList();
      return {'status': true, 'data': relatedVideo};
    } else {
      return {'status': false, 'data': []};
    }
  }

  static Future videoIntro({required String bvid}) async {
    var res = await DioInstance.instance().get(
      path: ApiString.baseUrl + ApiString.video_basic_info,
      param: {'bvid': bvid},
    );
    if (res.data['code'] == 0) {
      var result = Rootdata.fromJson(
          res.data, (dynamic data) => VideoDetailData.fromJson(data));
      return {'status': true, 'data': result.data};
    } else {
      return {
        'status': false,
        'data': null,
        'code': res.data['code'],
        'msg': res.data['message'],
      };
    }
  }

  static Future userInfo({required int mid}) async {
    var res = await DioInstance.instance().get(
      path: ApiString.baseUrl + ApiString.user_info,
      param: {
        'mid': mid,
        'photo': false,
      },
    );
    if (res.data['code'] == 0) {
      var result = Rootdata.fromJson(
        res.data,
        (dynamic data) => UserCardInfo.fromJson(data),
      );
      return {'status': true, 'data': result.data};
    } else {
      return {
        'status': false,
        'data': null,
        'code': res.data['code'],
        'msg': res.data['message'],
      };
    }
  }

  static Future rcmdVideoList({required int ps, required int freshIdx}) async {
    try {
      var res = await DioInstance.instance().get(
        path: ApiString.baseUrl + ApiString.getRcmdVideo,
        param: {
          'ps': ps,
          'fresh_idx': freshIdx,
          'brush': freshIdx,
          'fresh_type': 4
        },
      );
      if (res.data['code'] == 0) {
        List<VideoItem> list = [];
        list.addAll(
          Rootdata.fromJson(
              res.data, (dynamic data) => RcmdVideo.fromJson(data)).data.item,
        );
        return {'status': true, 'data': list};
      } else {
        return {
          'status': false,
          'data': [],
          'msg': res.data['message'],
        };
      }
    } catch (e) {
      return {
        'status': false,
        'data': [],
        'msg': e.toString(),
      };
    }
  }

  static Future hotVideoList({required int pn, required int ps}) async {
    try {
      var res = await DioInstance.instance().get(
        path: ApiString.baseUrl + ApiString.hotList,
        param: {
          'pn': pn,
          'ps': ps,
        },
      );
      if (res.data['code'] == 0) {
        List<HotVideoItem> list = [];
        list.addAll(
          Rootdata.fromJson(
            res.data,
            (dynamic data) => HotVideoItemList.fromJson(data),
          ).data.list!,
        );
        return {'status': true, 'data': list};
      } else {
        return {'status': false, 'data': [], 'msg': res.data['message']};
      }
    } catch (err) {
      return {'status': false, 'data': [], 'msg': err};
    }
  }

  static Future onlineTotal({int? aid, String? bvid, int? cid}) async {
    var res = await DioInstance.instance().get(
      path: ApiString.baseUrl + ApiString.video_online_people,
      param: {
        'aid': aid,
        'bvid': bvid,
        'cid': cid,
      },
    );
    if (res.data['code'] == 0) {
      return {'status': true, 'data': res.data['data']};
    } else {
      return {'status': false, 'data': null, 'msg': res.data['message']};
    }
  }

  static Future hasFollow(int mid) async {
    var res = await DioInstance.instance().get(
      path: ApiString.baseUrl + ApiString.hasFollow,
      param: {
        'fid': mid,
      },
    );
    if (res.data['code'] == 0) {
      return {'status': true, 'data': res.data['data']};
    } else {
      return {'status': false, 'msg': res.data['message']};
    }
  }

  // 操作用户关系
  static Future relationMod(
      {required int mid, required int act, required int reSrc}) async {
    var res = await DioInstance.instance().post(
      path: ApiString.baseUrl + ApiString.relationMod,
      param: {
        'fid': mid,
        'act': act,
        're_src': reSrc,
        'csrf': await DioInstance.instance().getCsrf(),
      },
    );
    if (res.data['code'] == 0) {
      return {'status': true, 'data': res.data['data'], 'msg': '成功'};
    } else {
      return {'status': false, 'data': [], 'msg': res.data['message']};
    }
  }
}
