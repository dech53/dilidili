import 'package:dilidili/cache/shared_preferences_instance.dart';
import 'package:dilidili/http/dio_instance.dart';
import 'package:dilidili/http/http_methods.dart';
import 'package:dilidili/http/static/api_string.dart';
import 'package:dilidili/model/qr_code.dart';
import 'package:dilidili/model/root_data.dart';
import 'package:dilidili/utils/log_utils.dart';
import 'package:dilidili/utils/wbi_utils.dart';
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
引入user结构体在fetch时如果存在刷新token就api获取user初始化信息
 */
class UserPageViewModel extends ChangeNotifier {
  QrCode? _qrCode;
  //是否已经存在用户
  bool _hasUser = false;
  String? _userID;
  QrCode? get qrCode => _qrCode;
  bool get hasUser => _hasUser;
  String? get ID => _userID;
  set qrCode(QrCode? qr_code) {
    _qrCode = qr_code;
    notifyListeners();
  }

  set ID(String? id) {
    _userID = id;
    notifyListeners();
  }

  set hasUser(bool hasuser) {
    _hasUser = hasuser;
    notifyListeners();
  }

  Future fetchLoginCode() async {
    final prefs = await SharedPreferencesInstance.instance();
    if (prefs.getString("refresh_token") == null) {
      Response response = await DioInstance.instance().get(
        path: ApiString.passportUrl + ApiString.apply_QRCode,
      );
      QrCode parsedData = Rootdata.fromJson(
        response.data,
        (dynamic data) => QrCode.fromJson(data),
      ).data;
      qrCode = parsedData;
      final cookieMap =
          await checkQrCodeState(qr_code_key: parsedData.qrcode_key);
      await prefs.setString('SESSDATA', cookieMap['SESSDATA'] ?? '');
      await prefs.setString('bili_jct', cookieMap['bili_jct'] ?? '');
      await prefs.setString('DedeUserID', cookieMap['DedeUserID'] ?? '');
      await prefs.setString(
          'DedeUserID__ckMd5', cookieMap['DedeUserID__ckMd5'] ?? '');
      await prefs.setString("refresh_token", cookieMap['refresh_token'] ?? '');
      Logutils.println(prefs.getString('DedeUserID')!);
    } else {
      hasUser = true;
      ID = prefs.getString("DedeUserID");
    }
  }

  //检查二维码状态
  Future<Map<String, String>> checkQrCodeState({String? qr_code_key}) async {
    final cookieMap = <String, String>{};
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
      switch (parsedData.code) {
        case 0:
          {
            final cookies = response.headers['set-cookie'];
            if (cookies != null) {
              for (final cookie in cookies) {
                final parts = cookie.split(";");
                if (parts.isNotEmpty) {
                  final keyValue = parts[0].trim().split('=');
                  if (keyValue.length >= 2) {
                    cookieMap[keyValue[0]] = keyValue[1];
                  }
                }
              }
            }
            cookieMap["refresh_token"] = parsedData.refresh_token;
            return cookieMap;
          }
        case 86038:
          break;
      }
      await Future.delayed(
        const Duration(milliseconds: 1000),
      );
    }
  }
}
