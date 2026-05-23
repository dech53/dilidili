import 'package:dilidili/http/user.dart';
import 'package:dilidili/pages/home/controller.dart';
import 'package:dilidili/pages/moments/controller.dart';
import 'package:dilidili/pages/root/controller.dart';
import 'package:dilidili/pages/user/controller.dart';
import 'package:dilidili/utils/cookie.dart';
import 'package:dilidili/utils/storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:uuid/uuid.dart';

class UserUtils {
  static Future refreshLoginStatus(bool status) async {
    try {
      await Get.find<UserPageController>().resetUserInfo();
      HomeController homeCtr = Get.find<HomeController>();
      final MomentsController momentsCtr = Get.find<MomentsController>();
      momentsCtr.userLogin.value = status;
      homeCtr.userFace.value = '';
      homeCtr.userLogin.value = status;
      homeCtr.userName.value = '';
    } catch (e) {
      SmartDialog.showToast('refreshLoginStatus error: ${e.toString()}');
    }
  }

  static confirmLogin(url, controller) async {
    try {
      await SetCookie.set();
      final result = await UserHttp.userInfo();
      if (result['status'] && result['data'].isLogin) {
        SmartDialog.showToast('登录成功');
        try {
          Box userInfoCache = SPStorage.userInfo;
          if (!userInfoCache.isOpen) {
            userInfoCache = await Hive.openBox('userInfo');
          }
          await userInfoCache.put('userInfoCache', result['data']);
          final HomeController homeCtr = Get.find<HomeController>();
          final UserPageController userCtr = Get.find<UserPageController>();
          userCtr.userInfo.value = result['data'];
          userCtr.userLogin.value = true;
          homeCtr.userFace.value = result['data'].face;
          homeCtr.userLogin.value = true;
          homeCtr.userName.value = result['data'].uname;
          SPStorage.userID = result['data'].mid.toString();
          final MomentsController momentsCtr = Get.find<MomentsController>();
          momentsCtr.userLogin.value = true;
          momentsCtr.userInfo = result['data'];
        } catch (e) {
          SmartDialog.show(
            builder: (BuildContext context) {
              return AlertDialog(
                title: const Text('登录遇到问题'),
                content: Text(e.toString()),
                actions: const [
                  TextButton(
                    onPressed: SmartDialog.dismiss,
                    child: Text('确认'),
                  )
                ],
              );
            },
          );
        }
        Get.back();
      } else {
        SmartDialog.showToast(result['msg']);
        Clipboard.setData(ClipboardData(text: result['msg']));
      }
    } catch (e) {
      SmartDialog.showNotify(msg: e.toString(), notifyType: NotifyType.warning);
      Clipboard.setData(const ClipboardData(text: "登录失败"));
    }
  }

  static String generateBuvid() {
    String uuid = getUUID() + getUUID();
    return 'XY${uuid.substring(0, 35).toUpperCase()}';
  }

  static String getUUID() {
    return const Uuid().v4().replaceAll('-', '');
  }
}
