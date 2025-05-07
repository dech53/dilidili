import 'package:dilidili/http/dio_instance.dart';
import 'package:dilidili/http/static/api_string.dart';

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
}
