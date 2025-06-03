import 'package:dilidili/http/dio_instance.dart';
import 'package:dilidili/http/static/api_string.dart';
import 'package:dilidili/model/dynamics/result.dart';
import 'package:dilidili/model/dynamics/up.dart';

class DynamicsHttp {
  static Future followUp() async {
    var res = await DioInstance.instance().get(
      path: ApiString.baseUrl + ApiString.followUp,
    );
    if (res.data['code'] == 0) {
      return {
        'status': true,
        'data': FollowUpModel.fromJson(res.data['data']),
      };
    } else {
      return {
        'status': false,
        'data': [],
        'msg': res.data['message'],
      };
    }
  }

  static Future followDynamic({
    String? type,
    int? page,
    String? offset,
    int? mid,
  }) async {
    Map<String, dynamic> data = {
      'type': type ?? 'all',
      'page': page ?? 1,
      'timezone_offset': '-480',
      'offset': page == 1 ? '' : offset,
    };
    if (mid != -1) {
      data['host_mid'] = mid;
      data.remove('timezone_offset');
    }
    var res = await DioInstance.instance().get(
      path: ApiString.baseUrl + ApiString.followDynamic,
      param: data,
    );
    if (res.data['code'] == 0) {
      try {
        return {
          'status': true,
          'data': DynamicsDataModel.fromJson(res.data['data']),
        };
      } catch (err) {
        print(err);
        return {
          'status': false,
          'data': [],
          'msg': err.toString(),
        };
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
}
