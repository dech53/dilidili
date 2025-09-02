import 'package:dilidili/http/dio_instance.dart';
import 'package:dilidili/http/static/api_string.dart';
import 'package:dilidili/model/user/black.dart';

class BlackHttp {
  static Future blackList({required int pn, int? ps}) async {
    var res = await DioInstance.instance()
        .get(path: ApiString.baseUrl + ApiString.blackLst, param: {
      'pn': pn,
      'ps': ps ?? 50,
      're_version': 0,
      'jsonp': 'jsonp',
      'csrf': await DioInstance.instance().getCsrf(),
    });
    if (res.data['code'] == 0) {
      return {
        'status': true,
        'data': BlackListDataModel.fromJson(res.data['data'])
      };
    } else {
      return {
        'status': false,
        'data': [],
        'msg': res.data['message'],
      };
    }
  }

  // 移除黑名单
  static Future removeBlack({required int fid}) async {
    var res = await DioInstance.instance().post(
      path: ApiString.baseUrl + ApiString.removeBlack,
      param: {
        'act': 6,
        'csrf': await DioInstance.instance().getCsrf(),
        'fid': fid,
        'jsonp': 'jsonp',
        're_src': 116,
      },
    );
    if (res.data['code'] == 0) {
      return {
        'status': true,
        'data': [],
        'msg': '操作成功',
      };
    } else {
      return {
        'status': false,
        'data': [],
        'msg': res.data['message'],
      };
    }
  }
}
