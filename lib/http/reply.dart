import 'package:dilidili/http/dio_instance.dart';
import 'package:dilidili/http/static/api_string.dart';
import 'package:dilidili/model/reply/data.dart';

class ReplyHttp {
  static Future replyList({
    required int oid,
    required int pageNum,
    required int type,
    int? ps,
    int sort = 1,
  }) async {
    var res = await DioInstance.instance().get(
      path: ApiString.baseUrl + ApiString.replyList,
      param: {
        'oid': oid,
        'pn': pageNum,
        'type': type,
        'sort': sort,
        'ps': ps ?? 20,
      },
    );
    if (res.data['code'] == 0) {
      return {
        'status': true,
        'data': ReplyData.fromJson(res.data['data']),
        'code': 200,
      };
    } else {
      return {
        'status': false,
        'date': [],
        'code': res.data['code'],
        'msg': res.data['message'],
      };
    }
  }

  static Future likeReply({
    required int type,
    required int oid,
    required int rpid,
    required int action,
  }) async {
    var res = await DioInstance.instance().post(
      path: ApiString.baseUrl + ApiString.likeReply,
      param: {
        'type': type,
        'oid': oid,
        'rpid': rpid,
        'action': action,
        'csrf': await DioInstance.instance().getCsrf(),
      },
    );
    if (res.data['code'] == 0) {
      return {'status': true, 'data': res.data['data']};
    } else {
      return {
        'status': false,
        'date': [],
        'msg': res.data['message'],
      };
    }
  }
}
