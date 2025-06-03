import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MomentsDetailController extends GetxController {
  MomentsDetailController(this.oid, this.type);
  final ScrollController scrollController = ScrollController();
  dynamic item;
  int? oid;
  int? type;
  @override
  void onInit() {
    super.onInit();
    item = Get.arguments['item'];
  }
}
