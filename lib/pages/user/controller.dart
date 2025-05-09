import 'dart:async';
import 'package:dilidili/http/user.dart';
import 'package:dilidili/model/user/stat.dart';
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
  // 用户状态 动态、关注、粉丝
  Rx<UserStat> userStat = UserStat().obs;
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
      userLogin.value = true;
      validTimer?.cancel();
      Get.back();
    }
  }

  Future queryUserInfo() async {
    if (!userLogin.value) {
      return {'status': false};
    }
    var res = await UserHttp.userInfo();
    if (res['status']) {
      if (res['data'].isLogin) {
        userInfo.value = res['data'];
        userInfoCache.put('userInfoCache', res['data']);
        userLogin.value = true;
      } else {
        resetUserInfo();
      }
    }
    await queryUserStatOwner();
    return res;
  }

  Future queryUserStatOwner() async {
    var res = await UserHttp.userStatOwner();
    if (res['status']) {
      userStat.value = res['data'];
    }
    return res;
  }

  Future resetUserInfo() async {
    userInfo.value = UserInfoData();
    userStat.value = UserStat();
    userInfoCache.delete('userInfoCache');
    userLogin.value = false;
  }
}
