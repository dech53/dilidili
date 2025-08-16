import 'package:dilidili/http/dio_instance.dart';
import 'package:dilidili/http/static/api_string.dart';
import 'package:dilidili/model/fans/result.dart';

class FanHttp {
  static Future fans({int? vmid, int? pn, int? ps, String? orderType}) async {
    var res = await DioInstance.instance()
        .get(path: ApiString.baseUrl + ApiString.fans, param: {
      'vmid': vmid,
      'pn': pn,
      'ps': ps,
      'order': 'desc',
      'order_type': orderType,
    });
    if (res.data['code'] == 0) {
      return {'status': true, 'data': FansDataModel.fromJson(res.data['data'])};
    } else {
      return {
        'status': false,
        'data': [],
        'msg': res.data['message'],
      };
    }
  }
}
