import 'package:dilidili/http/dio_instance.dart';
import 'package:dilidili/http/static/api_string.dart';
import 'package:dilidili/model/dynamics/result.dart';
import 'package:dilidili/model/member/archive.dart';
import 'package:dilidili/model/member/folder_detail.dart';
import 'package:dilidili/model/member/member_info.dart';
import 'package:dilidili/utils/utils.dart';
import 'package:dilidili/utils/wbi_utils.dart';

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
}
