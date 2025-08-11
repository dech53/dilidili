import 'package:dilidili/utils/storage.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';

class FollowController extends GetxController with GetTickerProviderStateMixin {
  RxBool isOwner = false.obs;
  Box userInfoCache = SPStorage.userInfo;
  var userInfo;
  late int mid;
  late String name;
  @override
  void onInit() {
    super.onInit();
    userInfo = userInfoCache.get('userInfoCache');
    mid = Get.parameters['mid'] != null
        ? int.parse(Get.arguments['mid']!)
        : userInfo.mid;
    isOwner.value = mid == userInfo.mid;
    name = Get.arguments['name'] ?? userInfo.uname;
  }

  Future queryFollowings(type) async {}
}
