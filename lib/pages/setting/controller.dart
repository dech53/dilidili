import 'package:dilidili/http/dio_instance.dart';
import 'package:dilidili/utils/storage.dart';
import 'package:dilidili/utils/user.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';

class SettingController extends GetxController {
  RxBool userLogin = false.obs;
  var userInfo;
  Box userInfoCache = SPStorage.userInfo;
  @override
  void onInit() {
    super.onInit();
    userInfo = userInfoCache.get('userInfoCache');
    userLogin.value = userInfo != null;
  }

  loginOut() async {
    SmartDialog.show(
      useSystem: true,
      animationType: SmartAnimationType.centerFade_otherSlide,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('提示'),
          content: const Text('确认要退出登录吗'),
          actions: [
            TextButton(
              onPressed: () => SmartDialog.dismiss(),
              child: const Text('点错了'),
            ),
            TextButton(
              onPressed: () async {
                await DioInstance.cookieManager.cookieJar.deleteAll();
                DioInstance.dio.options.headers['cookie'] = '';
                userInfoCache.put('userInfoCache', null);
                await UserUtils.refreshLoginStatus(false);
                SmartDialog.dismiss().then((value) => Get.back());
              },
              child: const Text('确定'),
            ),
          ],
        );
      },
    );
  }
}
