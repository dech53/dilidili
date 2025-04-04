import 'package:dilidili/http/dio_instance.dart';
import 'package:dilidili/http/static/api_string.dart';
import 'package:dilidili/model/qr_code.dart';
import 'package:dilidili/model/root_data.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

/*
扫码登录(web端)
https://passport.bilibili.com/x/passport-login/web/qrcode/poll
请求方式：GET
url参数：
参数名	类型	内容	必要性	备注
qrcode_key	str	扫码登录秘钥	必要	
密钥超时为180秒
验证登录成功后会进行设置以下cookie项：
DedeUserID DedeUserID__ckMd5 SESSDATA bili_jct
 */
class UserPageViewModel extends ChangeNotifier {
  QrCode? _qrCode;
  QrCode? get qrCode => _qrCode;
  set qrCode(QrCode? qr_code) {
    _qrCode = qr_code;
    notifyListeners();
  }

  Future fetchLoginCode() async {
    Response response = await DioInstance.instance().get(
      path: ApiString.passportUrl + ApiString.apply_QRCode,
    );
    QrCode parsedData = Rootdata.fromJson(
      response.data,
      (dynamic data) => QrCode.fromJson(data),
    ).data;
    qrCode = parsedData;
    checkQrCodeState(qr_code_key: parsedData.qrcode_key);
  }

  //检查二维码状态
  Future checkQrCodeState({String? qr_code_key}) async {
    while (true) {
      Response response = await DioInstance.instance().get(
        path: ApiString.passportUrl + ApiString.check_QRCode,
        param: {
          "qrcode_key": qr_code_key,
        },
      );
      QrCodeState parsedData = Rootdata.fromJson(
        response.data,
        (dynamic data) => QrCodeState.fromJson(data),
      ).data;
      //0二维码已扫描;86038二维码已失效
      if (parsedData.code == 0 || parsedData.code == 86038) break;
      await Future.delayed(
        const Duration(milliseconds: 1000),
      );
    }
  }
}
