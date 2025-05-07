import 'dart:async';
import 'package:dilidili/utils/storage.dart';
import 'package:dilidili/http/login.dart';
import 'package:dilidili/utils/user.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:get/get.dart';
import 'package:dilidili/model/user/info.dart';
import 'package:hive/hive.dart';

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
class UserPageController extends GetxController {
  // 用户信息 头像、昵称、lv
  Rx<UserInfoData> userInfo = UserInfoData().obs;
  RxInt validSeconds = 180.obs;
  late String qrcodeKey;
  RxBool userLogin = false.obs;
  Box userInfoCache = SPStorage.userInfo;
  Timer? validTimer;


  @override
  onInit() {
    super.onInit();
    if (userInfoCache.get('userInfoCache') != null) {
      userInfo.value = userInfoCache.get('userInfoCache');
      userLogin.value = true;
    }
  }
  // 获取登录二维码
  Future getWebQrcode() async {
    var res = await LoginHttp.getWebQrcode();
    validSeconds.value = 180;
    if (res['status']) {
      qrcodeKey = res['data']['qrcode_key'];
      validTimer = Timer.periodic(const Duration(seconds: 1), (validTimer) {
        if (validSeconds.value > 0) {
          validSeconds.value--;
          queryWebQrcodeStatus();
        } else {
          getWebQrcode();
          validTimer.cancel();
        }
      });
      return res;
    } else {
      SmartDialog.showToast(res['msg']);
    }
  }

  // 轮询二维码登录状态
  Future queryWebQrcodeStatus() async {
    var res = await LoginHttp.queryWebQrcodeStatus(qrcodeKey);
    if (res['status']) {
      await UserUtils.confirmLogin();
      validTimer?.cancel();
      Get.back();
    }
  }
}
