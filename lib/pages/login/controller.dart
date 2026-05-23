import 'dart:async';
import 'dart:io';

import 'package:dilidili/http/login.dart';
import 'package:dilidili/model/login/geetest.dart';
import 'package:dilidili/utils/user.dart';
import 'package:encrypt/encrypt.dart';
import 'package:flutter/material.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:get/get.dart';
import 'package:gt3_flutter_plugin/gt3_flutter_plugin.dart';

class LoginPageController extends GetxController {
  RxInt currentIndex = 0.obs;

  final FocusNode mobTextFieldNode = FocusNode();
  final FocusNode passwordTextFieldNode = FocusNode();
  final FocusNode msgCodeTextFieldNode = FocusNode();
  final PageController pageViewController = PageController();

  RxInt validSeconds = 180.obs;
  late String qrcodeKey;
  Timer? validTimer;
  bool _isQueryingQrcodeStatus = false;

  late int tel;
  late int webSmsCode;
  // 倒计时60s
  RxInt seconds = 60.obs;
  RxBool smsCodeSendStatus = false.obs;

  final TextEditingController mobTextController = TextEditingController();
  final TextEditingController passwordTextController = TextEditingController();
  final TextEditingController msgCodeTextController = TextEditingController();

  final GlobalKey mobFormKey = GlobalKey<FormState>();
  final GlobalKey passwordFormKey = GlobalKey<FormState>();
  final GlobalKey msgCodeFormKey = GlobalKey<FormState>();
  RxBool passwordVisible = false.obs;

  final Gt3FlutterPlugin captcha = Gt3FlutterPlugin();

  // 默认密码登录
  RxInt loginType = 0.obs;

  // 输入手机号 下一页
  void nextStep() async {
    if ((mobFormKey.currentState as FormState).validate()) {
      await pageViewController.animateToPage(
        1,
        duration: const Duration(microseconds: 3000),
        curve: Curves.easeInOut,
      );
      passwordTextFieldNode.requestFocus();
      (mobFormKey.currentState as FormState).save();
    }
  }

  // 切换登录方式
  void changeLoginType() {
    loginType.value = loginType.value == 0 ? 1 : 0;
    if (loginType.value == 0) {
      passwordTextFieldNode.requestFocus();
    } else {
      msgCodeTextFieldNode.requestFocus();
    }
  }

  // 上一页
  void previousPage() async {
    passwordTextFieldNode.unfocus();
    await Future.delayed(const Duration(milliseconds: 200));
    pageViewController.animateToPage(
      0,
      duration: const Duration(microseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  // 申请极验验证码
  Future getCaptcha(oncall) async {
    SmartDialog.showLoading(msg: '请求中...');
    var result = await LoginHttp.queryCaptcha();
    if (result['status']) {
      CaptchaDataModel captchaData = result['data'];
      var registerData = Gt3RegisterData(
        challenge: captchaData.geetest!.challenge,
        gt: captchaData.geetest!.gt!,
        success: true,
      );
      captcha.addEventHandler(onShow: (Map<String, dynamic> message) async {
        SmartDialog.dismiss();
      }, onClose: (Map<String, dynamic> message) async {
        SmartDialog.showToast('取消验证');
      }, onResult: (Map<String, dynamic> message) async {
        debugPrint("Captcha result: $message");
        String code = message["code"];
        if (code == "1") {
          // 发送 message["result"] 中的数据向 B 端的业务服务接口进行查询
          SmartDialog.showToast('验证成功');
          captchaData.validate = message['result']['geetest_validate'];
          captchaData.seccode = message['result']['geetest_seccode'];
          captchaData.geetest!.challenge =
              message['result']['geetest_challenge'];
          oncall(captchaData);
        } else {
          // 终端用户完成验证失败，自动重试 If the verification fails, it will be automatically retried.
          debugPrint("Captcha result code : $code");
        }
      }, onError: (Map<String, dynamic> message) async {
        String code = message["code"];

        // 处理验证中返回的错误 Handling errors returned in verification
        if (Platform.isAndroid) {
          // Android 平台
          if (code == "-2") {
            // Dart 调用异常 Call exception
          } else if (code == "-1") {
            // Gt3RegisterData 参数不合法 Parameter is invalid
          } else if (code == "201") {
            // 网络无法访问 Network inaccessible
          } else if (code == "202") {
            // Json 解析错误 Analysis error
          } else if (code == "204") {
            // WebView 加载超时，请检查是否混淆极验 SDK   Load timed out
          } else if (code == "204_1") {
            // WebView 加载前端页面错误，请查看日志 Error loading front-end page, please check the log
          } else if (code == "204_2") {
            // WebView 加载 SSLError
          } else if (code == "206") {
            // gettype 接口错误或返回为 null   API error or return null
          } else if (code == "207") {
            // getphp 接口错误或返回为 null    API error or return null
          } else if (code == "208") {
            // ajax 接口错误或返回为 null      API error or return null
          } else {
            // 更多错误码参考开发文档  More error codes refer to the development document
            // https://docs.geetest.com/sensebot/apirefer/errorcode/android
          }
        }

        if (Platform.isIOS) {
          // iOS 平台
          if (code == "-1009") {
            // 网络无法访问 Network inaccessible
          } else if (code == "-1004") {
            // 无法查找到 HOST  Unable to find HOST
          } else if (code == "-1002") {
            // 非法的 URL  Illegal URL
          } else if (code == "-1001") {
            // 网络超时 Network timeout
          } else if (code == "-999") {
            // 请求被意外中断, 一般由用户进行取消操作导致 The interrupted request was usually caused by the user cancelling the operation
          } else if (code == "-21") {
            // 使用了重复的 challenge   Duplicate challenges are used
            // 检查获取 challenge 是否进行了缓存  Check if the fetch challenge is cached
          } else if (code == "-20") {
            // 尝试过多, 重新引导用户触发验证即可 Try too many times, lead the user to request verification again
          } else if (code == "-10") {
            // 预判断时被封禁, 不会再进行图形验证 Banned during pre-judgment, and no more image captcha verification
          } else if (code == "-2") {
            // Dart 调用异常 Call exception
          } else if (code == "-1") {
            // Gt3RegisterData 参数不合法  Parameter is invalid
          } else {
            // 更多错误码参考开发文档 More error codes refer to the development document
            // https://docs.geetest.com/sensebot/apirefer/errorcode/ios
          }
        }
      });
      captcha.startCaptcha(registerData);
    } else {}
  }

  // web端密码登录
  void loginInByWebPassword() async {
    if ((passwordFormKey.currentState as FormState).validate()) {
      getCaptcha((data) async {
        CaptchaDataModel captchaData = data;
        var webKeyRes = await LoginHttp.getWebKey();
        if (webKeyRes['status']) {
          String rhash = webKeyRes['data']['hash'];
          String key = webKeyRes['data']['key'];
          dynamic publicKey = RSAKeyParser().parse(key);
          String passwordEncryptyed = Encrypter(RSA(publicKey: publicKey))
              .encrypt(rhash + passwordTextController.text)
              .base64;
          var res = await LoginHttp.loginInByWebPwd(
            username: tel,
            password: passwordEncryptyed,
            token: captchaData.token!,
            challenge: captchaData.geetest!.challenge!,
            validate: captchaData.validate!,
            seccode: captchaData.seccode!,
          );
          if (res['status']) {
            await UserUtils.confirmLogin('', null);
          } else {
            await SmartDialog.showToast(res['msg']);
            if (res.containsKey('code') && res['code'] == 1) {
              Get.toNamed('/webview', parameters: {
                'url': res['data']['url'],
                'type': 'login',
                'pageTitle': '登录验证',
              });
            }
          }
        } else {
          SmartDialog.showToast(webKeyRes['msg']);
        }
      });
    }
  }

  // 获取web端验证码
  void getWebMsgCode() async {}

  // 获取登录二维码
  Future getWebQrcode() async {
    stopWebQrcodePolling();
    var res = await LoginHttp.getWebQrcode();
    validSeconds.value = 180;
    if (res['status']) {
      qrcodeKey = res['data']['qrcode_key'];
      validTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
        if (validSeconds.value > 0) {
          validSeconds.value--;
          queryWebQrcodeStatus();
        } else {
          timer.cancel();
          getWebQrcode();
        }
      });
      return res;
    } else {
      SmartDialog.showToast(res['msg']);
    }
  }

  // 轮询二维码登录状态
  Future queryWebQrcodeStatus() async {
    if (_isQueryingQrcodeStatus) {
      return;
    }
    _isQueryingQrcodeStatus = true;
    try {
      var res = await LoginHttp.queryWebQrcodeStatus(qrcodeKey);
      if (res['status']) {
        await UserUtils.confirmLogin('', null);
        stopWebQrcodePolling();
        Get.back();
      }
    } finally {
      _isQueryingQrcodeStatus = false;
    }
  }

  void stopWebQrcodePolling() {
    validTimer?.cancel();
    validTimer = null;
  }

  // 监听pageView切换
  void onPageChange(int index) {
    currentIndex.value = index;
  }

  @override
  void onClose() {
    stopWebQrcodePolling();
    mobTextFieldNode.dispose();
    passwordTextFieldNode.dispose();
    msgCodeTextFieldNode.dispose();
    pageViewController.dispose();
    mobTextController.dispose();
    passwordTextController.dispose();
    msgCodeTextController.dispose();
    super.onClose();
  }
}
