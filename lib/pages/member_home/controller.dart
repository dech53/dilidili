import 'package:dilidili/model/space/space/data.dart';
import 'package:dilidili/pages/member/controller.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:get/get.dart';

class MemberHomeController extends GetxController {
  MemberHomeController({required this.mid, required this.heroTag});

  final int mid;
  final String? heroTag;

  late final MemberController memberController =
      Get.find<MemberController>(tag: heroTag);

  SpaceData? get spaceData => memberController.spaceData.value;

  void jumpToTab(String param, {String? fallbackMessage}) {
    final int index =
        memberController.tabs.indexWhere((item) => item['param'] == param);
    if (index >= 0) {
      memberController.tabController?.animateTo(index);
      return;
    }
    SmartDialog.showToast(fallbackMessage ?? '暂未实现');
  }
}
