import 'package:dilidili/http/dio_instance.dart';
import 'package:dilidili/http/static/api_string.dart';

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
}
