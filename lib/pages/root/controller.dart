import 'package:dilidili/utils/storage.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';

class RootController extends GetxController {
  Box userInfoCache = SPStorage.userInfo;
  var userInfo;
  RxBool userLogin = false.obs;
  @override
  void onInit() async {
    userInfo = userInfoCache.get('userInfoCache');
    userLogin.value = userInfo != null;
  }
}
