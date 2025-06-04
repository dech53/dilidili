import 'dart:math';

import 'package:dilidili/http/dio_instance.dart';
import 'package:dilidili/http/static/api_string.dart';
import 'package:dilidili/model/dynamics/result.dart';
import 'package:dilidili/model/dynamics/up.dart';
import 'package:dio/dio.dart';

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

  // 动态点赞
  static Future likeDynamic({
    required String? dynamicId,
    required int? up,
  }) async {
    var res = await DioInstance.instance().post(
      path: ApiString.baseMsgUrl + ApiString.likeDynamic,
      param: {
        'dynamic_id': dynamicId,
        'up': up,
        'csrf': await DioInstance.instance().getCsrf(),
      },
    );
    if (res.data['code'] == 0) {
      return {
        'status': true,
        'data': res.data['data'],
      };
    } else {
      return {
        'status': false,
        'data': [],
        'msg': res.data['message'],
      };
    }
  }

  static Future createDynamic({
    required String? content,
    int scene = 1,
    dynamic images,
    dynamic option,
  }) async {
    var res = await DioInstance.instance().post(
      path: ApiString.baseUrl + ApiString.createDynamic,
      param: {
        'csrf': await DioInstance.instance().getCsrf(),
      },
      data: {
        'dyn_req': {
          'content': {
            'contents': [
              {
                "raw_text": content.toString(),
                'type': 1,
                "biz_id": "",
              },
            ]
          },
          'pics': images,
          "meta": {
            "app_meta": {
              "from": "create.dynamic.web",
              "mobi_app": "web",
            }
          },
          "option": option,
          "scene": scene,
        },
      },
    );
    if (res.data['code'] == 0) {
      return {
        'status': true,
        'data': res.data['data'],
      };
    } else {
      return {
        'status': false,
        'data': [],
        'msg': res.data['message'],
      };
    }
  }

  static Future dynamicCreate({
    required int mid,
    required int scene,
    int? oid,
    String? dynIdStr,
    String? rawText,
  }) async {
    DateTime now = DateTime.now();
    int timestamp = now.millisecondsSinceEpoch ~/ 1000;
    Random random = Random();
    int randomNumber = random.nextInt(9000) + 1000;
    String uploadId = '${mid}_${timestamp}_$randomNumber';
    Map<String, dynamic> webRepostSrc = {
      'dyn_id_str': dynIdStr ?? '',
    };
    if (scene == 5) {
      webRepostSrc = {
        'revs_id': {'dyn_type': 8, 'rid': oid}
      };
    }
    var res = await DioInstance.instance().post(
      path: ApiString.baseUrl + ApiString.createDynamic,
      param: {
        'platform': 'web',
        'csrf': await DioInstance.instance().getCsrf(),
        'x-bili-device-req-json': {'platform': 'web', 'device': 'pc'},
        'x-bili-web-req-json': {'spm_id': '333.999'},
      },
      data: {
        'dyn_req': {
          'content': {
            'contents': [
              {'raw_text': rawText ?? '', 'type': 1, 'biz_id': ''}
            ]
          },
          'scene': scene,
          'attach_card': null,
          'upload_id': uploadId,
          'meta': {
            'app_meta': {'from': 'create.dynamic.web', 'mobi_app': 'web'}
          }
        },
        'web_repost_src': webRepostSrc
      },
      options: Options(contentType: 'application/json'),
    );
    if (res.data['code'] == 0) {
      return {
        'status': true,
        'data': res.data['data'],
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
