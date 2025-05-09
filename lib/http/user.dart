import 'package:dilidili/http/dio_instance.dart';
import 'package:dilidili/http/static/api_string.dart';
import 'package:dilidili/model/user/info.dart';
import 'package:dilidili/model/user/stat.dart';

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
}
