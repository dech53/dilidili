import 'package:dilidili/http/dio_instance.dart';
import 'package:dilidili/http/static/api_string.dart';
import 'package:dilidili/model/login/geetest.dart';
import 'package:dilidili/utils/user.dart';
import 'package:dio/dio.dart';

class LoginHttp {
  static Future getWebQrcode() async {
    var res = await DioInstance.instance().get(
      path: ApiString.passportUrl + ApiString.apply_QRCode,
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

  // web端二维码轮询登录状态
  static Future queryWebQrcodeStatus(String qrcodeKey) async {
    var res = await DioInstance.instance().get(
      path: ApiString.passportUrl + ApiString.check_QRCode,
      param: {
        'qrcode_key': qrcodeKey,
      },
    );
    if (res.data['data']['code'] == 0) {
      return {
        'status': true,
        'data': res.data['data'],
      };
    } else {
      return {'status': false, 'data': [], 'msg': res.data['message']};
    }
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
      path:ApiString.passBaseUrl+ ApiString.loginInByWebPwd,
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
