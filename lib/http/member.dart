import 'package:dilidili/common/constants.dart';
import 'package:dilidili/http/dio_instance.dart';
import 'package:dilidili/http/static/api_string.dart';
import 'package:dilidili/model/dynamics/result.dart';
import 'package:dilidili/model/follow/result.dart';
import 'package:dilidili/model/member/archive.dart';
import 'package:dilidili/model/member/folder_detail.dart';
import 'package:dilidili/model/member/member_info.dart';
import 'package:dilidili/model/member/tags.dart';
import 'package:dilidili/utils/storage.dart';
import 'package:dilidili/utils/utils.dart';
import 'package:dilidili/utils/wbi_utils.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:hive/hive.dart';

class MemberHttp {
  static Future memberInfo({
    int? mid,
    String token = '',
  }) async {
    var res = await DioInstance.instance().get(
      path: ApiString.baseUrl + ApiString.memberInfo,
      param: await WbiUtils.getWbi(
        {
          'mid': mid,
        },
      ),
    );
    if (res.data['code'] == 0) {
      return {'status': true, 'data': MemberInfo.fromJson(res.data['data'])};
    } else {
      return {
        'status': false,
        'data': [],
        'msg': res.data['message'],
      };
    }
  }

  static Future memberStat({int? mid}) async {
    var res = await DioInstance.instance().get(
      path: ApiString.baseUrl + ApiString.userStat,
      param: {
        'vmid': mid,
      },
    );
    if (res.data['code'] == 0) {
      return {'status': true, 'data': res.data['data']};
    } else {
      return {
        'status': false,
        'data': [],
        'msg': res.data['message'],
      };
    }
  }

  // 获取up播放数、点赞数
  static Future memberView({required int mid}) async {
    var res = await DioInstance.instance().get(
      path: ApiString.baseUrl + ApiString.getMemberViewApi,
      param: {'mid': mid},
    );
    if (res.data['code'] == 0) {
      return {'status': true, 'data': res.data['data']};
    } else {
      return {
        'status': false,
        'data': [],
        'msg': res.data['message'],
      };
    }
  }

  static Future memberFolderDetail({required int id}) async {
    var res = await DioInstance.instance().get(
      path: ApiString.baseUrl + ApiString.getFolerDetail,
      param: {
        'media_id': id,
      },
    );
    if (res.data['code'] == 0) {
      return {
        'status': true,
        'data': FolderDetail.fromJson(res.data['data']),
      };
    } else {
      return {
        'status': false,
        'data': [],
        'msg': res.data['message'],
      };
    }
  }

  //获取用户投稿信息
  static Future memberPost({
    int? mid,
    int ps = 30,
    int tid = 0,
    int? pn,
    String? keyword,
    String order = 'pubdate',
    bool orderAvoided = true,
  }) async {
    var res = await DioInstance.instance().get(
      path: ApiString.baseUrl + ApiString.memberPost,
      param: await WbiUtils.getWbi(
        {
          'mid': mid,
          'pn': pn,
        },
      ),
      extra: {'ua': 'pc'},
    );
    if (res.data['code'] == 0) {
      return {
        'status': true,
        'data': MemberPostDataModel.fromJson(res.data['data'])
      };
    } else {
      Map errMap = {
        -352: '风控校验失败，请检查登录状态',
      };
      return {
        'status': false,
        'data': [],
        'msg': errMap[res.data['code']] ?? res.data['message'],
      };
    }
  }

  // 用户动态
  static Future memberMoment({String? offset, int? mid}) async {
    var res = await DioInstance.instance().get(
      path: ApiString.baseUrl + ApiString.memberMoment,
      param: {
        'offset': offset ?? '',
        'host_mid': mid,
        'timezone_offset': '-480',
      },
    );
    if (res.data['code'] == 0) {
      return {
        'status': true,
        'data': MomentsDataModel.fromJson(res.data['data']),
      };
    } else {
      Map errMap = {
        -352: '风控校验失败，请检查登录状态',
      };
      return {
        'status': false,
        'data': [],
        'msg': errMap[res.data['code']] ?? res.data['message'],
      };
    }
  }

  // 查询分组
  static Future followUpTags() async {
    var res = await DioInstance.instance().get(
      path: ApiString.baseUrl + ApiString.followUpTag,
    );
    if (res.data['code'] == 0) {
      return {
        'status': true,
        'data': res.data['data']
            .map<MemberTagItemModel>((e) => MemberTagItemModel.fromJson(e))
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

  // 获取某分组下的up
  static Future followUpGroup(
    int? mid,
    int? tagid,
    int? pn,
    int? ps,
  ) async {
    var res = await DioInstance.instance()
        .get(path: ApiString.baseUrl + ApiString.followUpGroup, param: {
      'mid': mid,
      'tagid': tagid,
      'pn': pn,
      'ps': ps,
    });
    if (res.data['code'] == 0) {
      // FollowItemModel
      return {
        'status': true,
        'data': res.data['data']
            .map<FollowItemModel>((e) => FollowItemModel.fromJson(e))
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

  // 设置分组
  static Future addUsers(int? fids, String? tagids) async {
    var res = await DioInstance.instance().post(
      path: ApiString.baseUrl + ApiString.addUsers,
      param: {
        'fids': fids,
        'tagids': tagids ?? '0',
        'csrf': await DioInstance.instance().getCsrf(),
        'cross_domain': true
      },
    );
    if (res.data['code'] == 0) {
      return {'status': true, 'data': [], 'msg': '操作成功'};
    } else {
      return {
        'status': false,
        'data': [],
        'msg': res.data['message'],
      };
    }
  }

  // 获取TV authCode
  static Future getTVCode() async {
    SmartDialog.showLoading();
    var params = {
      'appkey': Constants.appKey,
      'local_id': '0',
      'ts': (DateTime.now().millisecondsSinceEpoch ~/ 1000).toString(),
    };
    String sign = Utils.appSign(
      params,
      Constants.appKey,
      Constants.appSec,
    );
    var res = await DioInstance.instance()
        .post(path: ApiString.getTVCode, param: {...params, 'sign': sign});
    if (res.data['code'] == 0) {
      return {
        'status': true,
        'data': res.data['data']['auth_code'],
        'msg': '操作成功'
      };
    } else {
      return {
        'status': false,
        'data': [],
        'msg': res.data['message'],
      };
    }
  }

  // 获取access_key
  static Future cookieToKey() async {
    var authCodeRes = await getTVCode();
    if (authCodeRes['status']) {
      var res = await DioInstance.instance().post(
        path: ApiString.cookieToKey,
        data: {
          'auth_code': authCodeRes['data'],
          'build': 708200,
          'csrf': await DioInstance.instance().getCsrf(),
        },
      );
      await Future.delayed(const Duration(milliseconds: 300));
      await qrcodePoll(authCodeRes['data']);
      if (res.data['code'] == 0) {
        return {'status': true, 'data': [], 'msg': '操作成功'};
      } else {
        return {
          'status': false,
          'data': [],
          'msg': res.data['message'],
        };
      }
    }
  }

  static Future qrcodePoll(authCode) async {
    var params = {
      'appkey': Constants.appKey,
      'auth_code': authCode.toString(),
      'local_id': '0',
      'ts': (DateTime.now().millisecondsSinceEpoch ~/ 1000).toString(),
    };
    String sign = Utils.appSign(
      params,
      Constants.appKey,
      Constants.appSec,
    );
    var res = await DioInstance.instance()
        .post(path: ApiString.qrcodePoll, param: {...params, 'sign': sign});
    SmartDialog.dismiss();
    if (res.data['code'] == 0) {
      String accessKey = res.data['data']['access_token'];
      Box localCache = SPStorage.localCache;
      Box userInfoCache = SPStorage.userInfo;
      var userInfo = userInfoCache.get('userInfoCache');
      localCache.put(
          LocalCacheKey.accessKey, {'mid': userInfo.mid, 'value': accessKey});
      return {'status': true, 'data': [], 'msg': '操作成功'};
    } else {
      return {
        'status': false,
        'data': [],
        'msg': res.data['message'],
      };
    }
  }
}
