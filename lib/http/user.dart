import 'package:dilidili/http/dio_instance.dart';
import 'package:dilidili/http/static/api_string.dart';
import 'package:dilidili/model/message/unread.dart';
import 'package:dilidili/model/model_hot_video_item.dart';
import 'package:dilidili/model/user/fav_detail.dart';
import 'package:dilidili/model/user/fav_folder.dart';
import 'package:dilidili/model/user/history.dart';
import 'package:dilidili/model/user/info.dart';
import 'package:dilidili/model/user/stat.dart';
import 'package:dilidili/model/user/sub_detail.dart';
import 'package:dilidili/model/user/sub_folder.dart';

class UserHttp {
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

  static Future<dynamic> userInfo() async {
    var res = await DioInstance.instance()
        .get(path: ApiString.baseUrl + ApiString.navInterface);
    if (res.data['code'] == 0) {
      UserInfoData data = UserInfoData.fromJson(res.data['data']);
      return {'status': true, 'data': data};
    } else {
      return {'status': false, 'msg': res.data['message']};
    }
  }

  static Future<dynamic> userStatOwner() async {
    var res = await DioInstance.instance().get(
      path: ApiString.baseUrl + ApiString.userStatOwner,
    );
    if (res.data['code'] == 0) {
      UserStat data = UserStat.fromJson(res.data['data']);
      return {'status': true, 'data': data};
    } else {
      return {'status': false, 'data': [], 'msg': res.data['message']};
    }
  }

  static Future<dynamic> getUnreadMsg() async {
    var res = await DioInstance.instance().get(
      path: ApiString.baseMsgUrl + ApiString.whisper_unread,
    );
    if (res.data['code'] == 0) {
      UnreadMsgCount data = UnreadMsgCount.fromJson(res.data['data']);
      return {'status': true, 'data': data};
    } else {
      return {'status': false, 'data': [], 'msg': res.data['message']};
    }
  }

  // 收藏夹
  static Future<dynamic> userfavFolder({
    required int pn,
    required int ps,
    required int mid,
  }) async {
    var res = await DioInstance.instance()
        .get(path: ApiString.baseUrl + ApiString.userFavFolder, param: {
      'pn': pn,
      'ps': ps,
      'up_mid': mid,
    });
    if (res.data['code'] == 0) {
      late FavFolderData data;
      if (res.data['data'] != null) {
        data = FavFolderData.fromJson(res.data['data']);
        return {'status': true, 'data': data};
      } else {
        return {'status': false, 'msg': '收藏夹为空'};
      }
    } else {
      return {
        'status': false,
        'data': [],
        'msg': res.data['message'],
        'code': res.data['code'],
      };
    }
  }

  // 删除文件夹
  static Future delFavFolder({required int mediaIds}) async {
    var res = await DioInstance.instance().post(
      path: ApiString.baseUrl + ApiString.delFavFolder,
      param: {
        'media_ids': mediaIds,
        'platform': 'web',
        'csrf': await DioInstance.instance().getCsrf(),
      },
    );
    if (res.data['code'] == 0) {
      return {'status': true};
    } else {
      return {'status': false, 'msg': res.data['message']};
    }
  }

  static Future<dynamic> userFavFolderDetail(
      {required int mediaId,
      required int pn,
      required int ps,
      String keyword = '',
      String order = 'mtime',
      int type = 0}) async {
    var res = await DioInstance.instance().get(
      path: ApiString.baseUrl + ApiString.userFavFolderDetail,
      param: {
        'media_id': mediaId,
        'pn': pn,
        'ps': ps,
        'keyword': keyword,
        'order': order,
        'type': type,
        'tid': 0,
        'platform': 'web'
      },
    );
    if (res.data['code'] == 0) {
      FavDetailData data = FavDetailData.fromJson(res.data['data']);
      return {'status': true, 'data': data};
    } else {
      return {'status': false, 'data': [], 'msg': res.data['message']};
    }
  }

  // 观看历史
  static Future historyList(int? max, int? viewAt) async {
    var res = await DioInstance.instance()
        .get(path: ApiString.baseUrl + ApiString.historyList, param: {
      'type': 'all',
      'ps': 20,
      'max': max ?? 0,
      'view_at': viewAt ?? 0,
    });
    if (res.data['code'] == 0) {
      return {'status': true, 'data': HistoryData.fromJson(res.data['data'])};
    } else {
      return {
        'status': false,
        'data': [],
        'msg': res.data['message'],
        'code': res.data['code'],
      };
    }
  }

  // 删除历史记录
  static Future delHistory(kid) async {
    var res = await DioInstance.instance().post(
      path: ApiString.baseUrl + ApiString.delHistory,
      param: {
        'kid': kid,
        'jsonp': 'jsonp',
        'csrf': await DioInstance.instance().getCsrf(),
      },
    );
    if (res.data['code'] == 0) {
      return {'status': true, 'msg': '已删除'};
    } else {
      return {'status': false, 'msg': res.data['message']};
    }
  }

  // 我的订阅
  static Future userSubFolder({
    required int mid,
    required int pn,
    required int ps,
  }) async {
    var res = await DioInstance.instance().get(
      path: ApiString.baseUrl + ApiString.userSubFolder,
      param: {
        'up_mid': mid,
        'ps': ps,
        'pn': pn,
        'platform': 'web',
      },
    );
    if (res.data['code'] == 0) {
      return {
        'status': true,
        'data': SubFolderModelData.fromJson(res.data['data'])
      };
    } else {
      return {
        'status': false,
        'data': [],
        'msg': res.data['message'],
        'code': res.data['code'],
      };
    }
  }

  // 取消订阅
  static Future cancelSub({required int seasonId}) async {
    var res = await DioInstance.instance().post(
      path: ApiString.baseUrl + ApiString.cancelSub,
      param: {
        'platform': 'web',
        'season_id': seasonId,
        'csrf': await DioInstance.instance().getCsrf(),
      },
    );
    if (res.data['code'] == 0) {
      return {'status': true};
    } else {
      return {'status': false, 'msg': res.data['message']};
    }
  }

  static Future userSeasonList({
    required int seasonId,
    required int pn,
    required int ps,
  }) async {
    var res = await DioInstance.instance()
        .get(path: ApiString.baseUrl + ApiString.userSeasonList, param: {
      'season_id': seasonId,
      'ps': ps,
      'pn': pn,
    });
    if (res.data['code'] == 0) {
      return {
        'status': true,
        'data': SubDetailModelData.fromJson(res.data['data'])
      };
    } else {
      return {'status': false, 'msg': res.data['message']};
    }
  }

  static Future userResourceList({
    required int seasonId,
    required int pn,
    required int ps,
  }) async {
    var res = await DioInstance.instance().get(
      path: ApiString.baseUrl + ApiString.userResourceList,
      param: {
        'media_id': seasonId,
        'ps': ps,
        'pn': pn,
        'keyword': '',
        'order': 'mtime',
        'type': 0,
        'tid': 0,
        'platform': 'web',
      },
    );
    if (res.data['code'] == 0) {
      try {
        return {
          'status': true,
          'data': SubDetailModelData.fromJson(res.data['data'])
        };
      } catch (err) {
        return {'status': false, 'msg': err};
      }
    } else {
      return {'status': false, 'msg': res.data['message']};
    }
  }

  // 稍后再看
  static Future toViewLater({String? bvid, dynamic aid}) async {
    var data = {
      'csrf': await DioInstance.instance().getCsrf(),
    };
    if (bvid != null) {
      data['bvid'] = bvid;
    } else if (aid != null) {
      data['aid'] = aid;
    }
    var res = await DioInstance.instance().post(
      path: ApiString.baseUrl + ApiString.toViewLater,
      param: data,
    );
    if (res.data['code'] == 0) {
      return {'status': true, 'msg': 'yeah！稍后再看'};
    } else {
      return {'status': false, 'msg': res.data['message']};
    }
  }

  // 稍后再看
  static Future<dynamic> seeYouLater() async {
    var res = await DioInstance.instance().get(
      path: ApiString.baseUrl + ApiString.seeYouLater,
    );
    if (res.data['code'] == 0) {
      if (res.data['data']['count'] == 0) {
        return {
          'status': true,
          'data': {'list': [], 'count': 0}
        };
      }
      List<HotVideoItemModel> list = [];
      for (var i in res.data['data']['list']) {
        list.add(HotVideoItemModel.fromJson(i));
      }
      return {
        'status': true,
        'data': {'list': list, 'count': res.data['data']['count']}
      };
    } else {
      return {
        'status': false,
        'data': [],
        'msg': res.data['message'],
        'code': res.data['code'],
      };
    }
  }

  // 移除已观看
  static Future toViewDel({int? aid}) async {
    final Map<String, dynamic> params = {
      'jsonp': 'jsonp',
      'csrf': await DioInstance.instance().getCsrf(),
    };

    params[aid != null ? 'aid' : 'viewed'] = aid ?? true;
    var res = await DioInstance.instance().post(
      path: ApiString.baseUrl + ApiString.toViewDel,
      param: params,
    );
    if (res.data['code'] == 0) {
      return {'status': true, 'msg': 'yeah！成功移除'};
    } else {
      return {'status': false, 'msg': res.data['message']};
    }
  }

  // 清空稍后再看
  static Future toViewClear() async {
    var res = await DioInstance.instance().post(
      path: ApiString.baseUrl + ApiString.toViewClear,
      param: {
        'jsonp': 'jsonp',
        'csrf': await DioInstance.instance().getCsrf(),
      },
    );
    if (res.data['code'] == 0) {
      return {'status': true, 'msg': '操作完成'};
    } else {
      return {'status': false, 'msg': res.data['message']};
    }
  }
}
