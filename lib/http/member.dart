import 'package:dilidili/common/constants.dart';
import 'package:dilidili/http/dio_instance.dart';
import 'package:dilidili/http/static/api_string.dart';
import 'package:dilidili/model/dynamics/result.dart';
import 'package:dilidili/model/follow/result.dart';
import 'package:dilidili/model/member/archive.dart';
import 'package:dilidili/model/member/contribute_type.dart';
import 'package:dilidili/model/member/folder_detail.dart';
import 'package:dilidili/model/member/member_info.dart';
import 'package:dilidili/model/member/tags.dart';
import 'package:dilidili/model/space/space/data.dart';
import 'package:dilidili/model/space/space_archive/data.dart';
import 'package:dilidili/utils/storage.dart';
import 'package:dilidili/utils/utils.dart';
import 'package:dilidili/utils/wbi_utils.dart';
import 'package:dio/dio.dart';

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
        'features': 'itemOpusStyle'
      },
    );

    if (res.data['code'] == 0) {
      try {
        final data = MomentsDataModel.fromJson(res.data['data']);
        return {
          'status': true,
          'data': data,
        };
      } catch (e, st) {
        print('memberMoment fromJson error: $e');
        print(st);
        print(res.data['data']);
        return {
          'status': false,
          'data': null,
          'msg': '动态数据解析失败: $e',
        };
      }
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

  static Future space({
    int? mid,
    dynamic fromViewAid,
  }) async {
    String? accessKey;
    final dynamic userInfo = SPStorage.userInfo.get('userInfoCache');
    final dynamic cachedAccessKey =
        SPStorage.localCache.get(LocalCacheKey.accessKey);
    final int? ownerMid = int.tryParse(userInfo?.mid?.toString() ?? '');
    int? cacheMid;
    if (cachedAccessKey is Map) {
      final dynamic value = cachedAccessKey['value'];
      cacheMid = int.tryParse(cachedAccessKey['mid']?.toString() ?? '');
      if (value is String &&
          value.isNotEmpty &&
          (ownerMid == null || cacheMid == ownerMid)) {
        accessKey = value;
      }
    }
    print(
      '[MemberHttp.space] access_key attached=${accessKey != null}, '
      'targetMid=$mid, ownerMid=$ownerMid, cacheMid=$cacheMid',
    );
    final Map<String, dynamic> params = {
      'build': 8430300,
      'version': '8.43.0',
      'c_locale': 'zh_CN',
      'channel': 'master',
      'mobi_app': 'android',
      'platform': 'android',
      's_locale': 'zh_CN',
      if (fromViewAid != null) 'from_view_aid': fromViewAid,
      if (accessKey != null) 'access_key': accessKey,
      'statistics': Constants.statisticsApp,
      'vmid': mid,
      'ts': (DateTime.now().millisecondsSinceEpoch ~/ 1000).toString(),
    };
    try {
      String sign = Utils.appSign(
        params,
        Constants.androidAppKey,
        Constants.androidAppSec,
      );
      var res = await DioInstance.instance().get(
        path: ApiString.appBaseUrl + ApiString.memberSpace,
        param: {
          ...params,
          'sign': sign,
        },
        options: Options(
          headers: {
            'bili-http-engine': 'cronet',
            'user-agent': Constants.userAgentApp,
          },
        ),
      );
      if (res.data['code'] == 0) {
        final SpaceData spaceData = SpaceData.fromJson(res.data['data']);
        print(spaceData.toString());
        final dynamic rawData = res.data['data'];
        final dynamic rawCard = rawData is Map ? rawData['card'] : null;
        print(
          '[MemberHttp.space] raw card.followings_followed_upper: '
          '${rawCard is Map ? rawCard['followings_followed_upper'] : null}',
        );
        _printSpaceFollowedUpper(spaceData);
        return {
          'status': true,
          'data': spaceData,
        };
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

  static void _printSpaceFollowedUpper(SpaceData spaceData) {
    final followedUpper = spaceData.card?.followingsFollowedUpper;
    final items = followedUpper?.items ?? [];
    print(
      '[MemberHttp.space] parsed card.followingsFollowedUpper: '
      'exists=${followedUpper != null}, '
      'jumpUrl=${followedUpper?.jumpUrl}, '
      'count=${items.length}, '
      'items=${items.map((item) {
        return '{mid: ${item.mid}, name: ${item.name}, face: ${item.face}}';
      }).join(', ')}',
    );
  }

  static Future spaceArchive({
    required ContributeType type,
    required int mid,
    int? pn,
  }) async {
    final Map<String, dynamic> params = {
      'build': 8430300,
      'version': '8.43.0',
      'c_locale': 'zh_CN',
      'channel': 'master',
      'mobi_app': 'android',
      'platform': 'android',
      's_locale': 'zh_CN',
      'ps': 20,
      if (pn != null) 'pn': pn,
      'qn': 32,
      'statistics': Constants.statisticsApp,
      'vmid': mid,
    };
    try {
      var res = await DioInstance.instance().get(
        path: ApiString.appBaseUrl + type.api,
        param: params,
        options: Options(
          headers: {
            'bili-http-engine': 'cronet',
            'user-agent': Constants.userAgentApp,
          },
        ),
      );
      if (res.data['code'] == 0) {
        return {
          'status': true,
          'data': SpaceArchiveData.fromJson(res.data['data']),
        };
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
}
