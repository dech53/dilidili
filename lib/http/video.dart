import 'package:dilidili/http/dio_instance.dart';
import 'package:dilidili/http/static/api_string.dart';
import 'package:dilidili/model/model_hot_video_item.dart';
import 'package:dilidili/model/nav_user_info.dart';
import 'package:dilidili/model/rcmd_video.dart';
import 'package:dilidili/model/root_data.dart';
import 'package:dilidili/model/user/fav_folder.dart';
import 'package:dilidili/model/video/hot_video.dart';
import 'package:dilidili/model/video/related_video.dart';
import 'package:dilidili/model/video/url.dart';
import 'package:dilidili/model/video/video_basic_info.dart';
import 'package:dilidili/model/video/video_tag.dart';
import 'package:dilidili/utils/wbi_utils.dart';

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

  static Future videoTag({required String bvid}) async {
    var res = await DioInstance.instance().get(
      path: ApiString.baseUrl + ApiString.videoTag,
      param: {
        'bvid': bvid,
      },
    );
    if (res.data['code'] == 0) {
      var result = Rootdata.fromJson(
        res.data,
        (dynamic data) =>
            (data as List).map((e) => VideoTag.fromJson(e)).toList(),
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
        List<RcmdVideoItem> list = [];
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

  // 获取点赞状态
  static Future hasLikeVideo({required String bvid}) async {
    var res = await DioInstance.instance().get(
      path: ApiString.baseUrl + ApiString.hasLikeVideo,
      param: {
        'bvid': bvid,
      },
    );
    if (res.data['code'] == 0) {
      return {'status': true, 'data': res.data['data']};
    } else {
      return {'status': false, 'data': []};
    }
  }

  // 获取投币状态
  static Future hasCoinVideo({required String bvid}) async {
    var res = await DioInstance.instance().get(
      path: ApiString.baseUrl + ApiString.hasCoinVideo,
      param: {
        'bvid': bvid,
      },
    );
    print('res: $res');
    if (res.data['code'] == 0) {
      return {'status': true, 'data': res.data['data']};
    } else {
      return {'status': false, 'data': []};
    }
  }

  // 获取收藏状态
  static Future hasFavVideo({required int aid}) async {
    var res = await DioInstance.instance().get(
      path: ApiString.baseUrl + ApiString.hasFavVideo,
      param: {
        'aid': aid,
      },
    );
    if (res.data['code'] == 0) {
      return {'status': true, 'data': res.data['data']};
    } else {
      return {'status': false, 'data': []};
    }
  }

  // （取消）点赞
  static Future likeVideo({required String bvid, required bool type}) async {
    var res = await DioInstance.instance().post(
      path: ApiString.baseUrl + ApiString.likeVideo,
      param: {
        'bvid': bvid,
        'like': type ? 1 : 2,
        'csrf': await DioInstance.instance().getCsrf(),
      },
    );
    if (res.data['code'] == 0) {
      return {'status': true, 'data': res.data['code']};
    } else {
      return {'status': false, 'data': [], 'msg': res.data['message']};
    }
  }

  static Future coinVideo({required String bvid, required int multiply}) async {
    var res = await DioInstance.instance().post(
      path: ApiString.baseUrl + ApiString.coinVideo,
      param: {
        'bvid': bvid,
        'multiply': multiply,
        'select_like': 0,
        'csrf': await DioInstance.instance().getCsrf(),
      },
    );
    if (res.data['code'] == 0) {
      return {'status': true, 'data': res.data['data']};
    } else {
      return {'status': false, 'data': [], 'msg': res.data['message']};
    }
  }

  static Future videoInFolder({required int mid, required int rid}) async {
    var res = await DioInstance.instance().get(
      path: ApiString.baseUrl + ApiString.videoInFolder,
      param: {
        'up_mid': mid,
        'rid': rid,
      },
    );
    if (res.data['code'] == 0) {
      FavFolderData data = FavFolderData.fromJson(res.data['data']);
      return {'status': true, 'data': data};
    } else {
      return {'status': false, 'data': []};
    }
  }

  // （取消）收藏
  static Future favVideo(
      {required int aid, String? addIds, String? delIds}) async {
    var res = await DioInstance.instance().post(
      path: ApiString.baseUrl + ApiString.favVideo,
      param: {
        'rid': aid,
        'type': 2,
        'add_media_ids': addIds ?? '',
        'del_media_ids': delIds ?? '',
        'csrf': await DioInstance.instance().getCsrf(),
      },
    );
    if (res.data['code'] == 0) {
      return {'status': true, 'data': res.data['data']};
    } else {
      return {'status': false, 'data': [], 'msg': res.data['message']};
    }
  }

  static Future videoUrl(
      {int? avid, String? bvid, required int cid, int? qn}) async {
    var res = await DioInstance.instance().get(
      path: ApiString.baseUrl + ApiString.video_playurl,
      param: await WbiUtils.getWbi(
        {
          'cid': cid,
          'avid': avid,
          'bvid': bvid,
          'qn': qn ?? 80,
          'fourk': 1,
          'voice_balance': 1,
          'gaia_source': 'pre-load',
          'web_location': 1550101,
          'fnval': 4048,
        },
      ),
    );
    if (res.data['code'] == 0) {
      return {'status': true, 'data': PlayUrlModel.fromJson(res.data['data'])};
    } else {
      return {
        'status': false,
        'data': [],
        'code': res.data['code'],
        'msg': res.data['message'],
      };
    }
  }

  // 视频排行
  static Future getRankVideoList(int rid) async {
    try {
      var rankApi =
          "${ApiString.baseUrl}${ApiString.getRankApi}?rid=$rid&type=all";
      var res = await DioInstance.instance().get(path: rankApi);
      if (res.data['code'] == 0) {
        List<HotVideoItemModel> list = [];
        for (var i in res.data['data']['list']) {
          list.add(HotVideoItemModel.fromJson(i));
        }
        return {'status': true, 'data': list};
      } else {
        return {'status': false, 'data': [], 'msg': res.data['message']};
      }
    } catch (err) {
      return {'status': false, 'data': [], 'msg': err};
    }
  }
}
