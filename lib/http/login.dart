import 'dart:io';

import 'package:dilidili/common/constants.dart';
import 'package:dilidili/http/dio_instance.dart';
import 'package:dilidili/http/static/api_string.dart';
import 'package:dilidili/model/login/geetest.dart';
import 'package:dilidili/utils/user.dart';
import 'package:dilidili/utils/utils.dart';
import 'package:dio/dio.dart';

class LoginHttp {
  static Future getWebQrcode() async {
    final Map<String, dynamic> params = {
      'local_id': '0',
      'platform': 'android',
      'mobi_app': 'android_hd',
      'ts': (DateTime.now().millisecondsSinceEpoch ~/ 1000).toString(),
    };
    final String sign = Utils.appSign(
      params,
      Constants.androidAppKey,
      Constants.androidAppSec,
    );
    var res = await DioInstance.instance().post(
      path: ApiString.getTVCode,
      param: {...params, 'sign': sign},
      options: Options(headers: {'user-agent': Constants.userAgentApp}),
    );
    if (res.data['code'] == 0) {
      return {
        'status': true,
        'data': res.data['data'],
      };
    } else {
      return {'status': false, 'data': [], 'msg': res.data['message']};
    }
  }

  // TV/HD端二维码轮询登录状态
  static Future queryWebQrcodeStatus(String qrcodeKey) async {
    final Map<String, dynamic> params = {
      'auth_code': qrcodeKey,
      'local_id': '0',
      'ts': (DateTime.now().millisecondsSinceEpoch ~/ 1000).toString(),
    };
    final String sign = Utils.appSign(
      params,
      Constants.androidAppKey,
      Constants.androidAppSec,
    );
    var res = await DioInstance.instance().post(
      path: ApiString.qrcodePoll,
      param: {
        ...params,
        'sign': sign,
      },
      options: Options(headers: {'user-agent': Constants.userAgentApp}),
    );
    if (res.data['code'] == 0) {
      return {
        'status': true,
        'data': res.data['data'],
      };
    } else {
      return {
        'status': false,
        'code': res.data['code'],
        'data': res.data['data'],
        'msg': res.data['message'],
      };
    }
  }

  static Future<void> saveTvLoginCookies(List<dynamic>? cookieInfo) async {
    if (cookieInfo == null || cookieInfo.isEmpty) {
      return;
    }
    final List<Cookie> cookies = cookieInfo
        .whereType<Map>()
        .map((item) {
          final Cookie cookie = Cookie(
            item['name']?.toString() ?? '',
            item['value']?.toString() ?? '',
          )
            ..domain = item['domain']?.toString() ?? '.bilibili.com'
            ..path = item['path']?.toString() ?? '/'
            ..httpOnly = _toBool(item['http_only'])
            ..secure = _toBool(item['secure']);
          final int? expires = int.tryParse(
            (item['expires'] ?? item['expires_timestamp'])?.toString() ?? '',
          );
          if (expires != null && expires > 0) {
            cookie.expires = DateTime.fromMillisecondsSinceEpoch(
              expires > 1000000000000 ? expires : expires * 1000,
            );
          }
          return cookie;
        })
        .where((cookie) => cookie.name.isNotEmpty)
        .toList();
    if (cookies.isEmpty) {
      return;
    }
    final List<Uri> uris = [
      Uri.parse(ApiString.mainUrl),
      Uri.parse(ApiString.baseUrl),
      Uri.parse(ApiString.passportUrl),
      Uri.parse(ApiString.baseMsgUrl),
    ];
    for (final Uri uri in uris) {
      await DioInstance.cookieManager.cookieJar.saveFromResponse(uri, cookies);
    }
    final List<Cookie> headerCookies = await DioInstance.cookieManager.cookieJar
        .loadForRequest(Uri.parse(ApiString.mainUrl));
    DioInstance.dio.options.headers['cookie'] = headerCookies
        .map((cookie) => '${cookie.name}=${cookie.value}')
        .join('; ');
  }

  static bool _toBool(dynamic value) {
    if (value is bool) {
      return value;
    }
    return value?.toString() == '1' || value?.toString() == 'true';
  }

  static Future queryCaptcha() async {
    var res = await DioInstance.instance().get(
      path: ApiString.passBaseUrl + ApiString.getCaptcha,
    );
    if (res.data['code'] == 0) {
      return {
        'status': true,
        'data': CaptchaDataModel.fromJson(res.data['data']),
      };
    } else {
      return {'status': false, 'data': res.data['message']};
    }
  }

  // 获取盐hash跟PubKey
  static Future getWebKey() async {
    var res = await DioInstance.instance().get(
        path: ApiString.passBaseUrl + ApiString.getWebKey,
        param: {'disable_rcmd': 0, 'local_id': UserUtils.generateBuvid()});
    if (res.data['code'] == 0) {
      return {'status': true, 'data': res.data['data']};
    } else {
      return {'status': false, 'data': {}, 'msg': res.data['message']};
    }
  }

  // web端密码登录
  static Future loginInByWebPwd({
    required int username,
    required String password,
    required String token,
    required String challenge,
    required String validate,
    required String seccode,
  }) async {
    Map data = {
      'username': username,
      'password': password,
      'keep': 0,
      'token': token,
      'challenge': challenge,
      'validate': validate,
      'seccode': seccode,
      'source': 'main-fe-header',
      "go_url": ApiString.mainUrl
    };
    FormData formData = FormData.fromMap({...data});
    var res = await DioInstance.instance().post(
      path: ApiString.passBaseUrl + ApiString.loginInByWebPwd,
      data: formData,
    );
    if (res.data['code'] == 0) {
      if (res.data['data']['status'] == 0) {
        return {
          'status': true,
          'data': res.data['data'],
        };
      } else {
        return {
          'status': false,
          'code': 1,
          'data': res.data['data'],
          'msg': res.data['data']['message'],
        };
      }
    } else {
      return {
        'status': false,
        'data': [],
        'msg': res.data['message'],
      };
    }
  }
}
