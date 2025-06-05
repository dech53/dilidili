import 'package:dilidili/http/static/api_string.dart';
import 'package:dilidili/model/danmaku/dm.pb.dart';
import 'package:dio/dio.dart';
import 'package:dilidili/http/dio_instance.dart';

class DanmakaHttp {
  static Future queryDanmaku({
    required int cid,
    required int segmentIndex,
  }) async {
    Map<String, int> params = {
      'type': 1,
      'oid': cid,
      'segment_index': segmentIndex,
    };
    var response = await DioInstance.instance().get(
      path: ApiString.baseUrl + ApiString.webDanmaku,
      param: params,
      extra: {'resType': ResponseType.bytes},
    );
    return DmSegMobileReply.fromBuffer(response.data);
  }
}
