import 'package:get/get.dart';

class MemberController extends GetxController {
  late int mid;
  @override
  void onInit() {
    mid = int.parse(Get.parameters['mid']!);
  }
}
