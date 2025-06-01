import 'package:dilidili/http/dio_instance.dart';
import 'package:dilidili/http/static/api_string.dart';
import 'package:dilidili/model/bangumi/list.dart';

class BangumiHttp {
  static Future bangumiList({int? page}) async {
    var res = await DioInstance.instance().get(
      path: ApiString.baseUrl + ApiString.bangumiList,
      param: {
        'page': page,
      },
    );
    if (res.data['code'] == 0) {
      return {
        'status': true,
        'data': BangumiListDataModel.fromJson(res.data['data'])
      };
    } else {
      return {
        'status': false,
        'data': [],
        'msg': res.data['message'],
      };
    }
  }

  static Future bangumiFollow({int? mid}) async {
    var res = await DioInstance.instance().get(
      path: ApiString.baseUrl + ApiString.bangumiFollow,
      param: {
        'vmid': mid,
      },
    );
    if (res.data['code'] == 0) {
      return {
        'status': true,
        'data': BangumiListDataModel.fromJson(res.data['data'])
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
