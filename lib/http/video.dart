import 'package:dilidili/http/dio_instance.dart';
import 'package:dilidili/http/static/api_string.dart';
import 'package:dilidili/model/nav_user_info.dart';
import 'package:dilidili/model/root_data.dart';
import 'package:dilidili/model/video/related_video.dart';
import 'package:dilidili/model/video/video_basic_info.dart';

class VideoHttp {
  static Future relatedVideoList({required String bvid}) async {
    var res = await DioInstance.instance().get(
      path: ApiString.baseUrl + ApiString.getRelatedVideo,
      param: {"bvid": bvid},
    );
    if (res.data['code'] == 0) {
      var relatedVideo = (res.data['data'] as List<dynamic>)
          .map((e) => RelatedVideoItem.fromJson(e as Map<String, dynamic>))
          .toList();
      return {'status': true, 'data': relatedVideo};
    } else {
      return {'status': false, 'data': []};
    }
  }

  static Future videoIntro({required String bvid}) async {
    var res = await DioInstance.instance().get(
      path: ApiString.baseUrl + ApiString.video_basic_info,
      param: {'bvid': bvid},
    );
    if (res.data['code'] == 0) {
      var result = Rootdata.fromJson(
          res.data, (dynamic data) => VideoDetailData.fromJson(data));
      return {'status': true, 'data': result.data};
    } else {
      return {
        'status': false,
        'data': null,
        'code': res.data['code'],
        'msg': res.data['message'],
      };
    }
  }

  static Future userInfo({required int mid}) async {
    var res = await DioInstance.instance().get(
      path: ApiString.baseUrl + ApiString.user_info,
      param: {
        'mid': mid,
        'photo': false,
      },
    );
    if (res.data['code'] == 0) {
      var result = Rootdata.fromJson(
        res.data,
        (dynamic data) => UserCardInfo.fromJson(data),
      );
      return {'status': true, 'data': result.data};
    } else {
      return {
        'status': false,
        'data': null,
        'code': res.data['code'],
        'msg': res.data['message'],
      };
    }
  }
}
