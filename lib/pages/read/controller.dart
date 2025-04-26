import 'dart:async';
import 'package:dilidili/http/read.dart';
import 'package:dilidili/model/read/read.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ReadPageController extends GetxController {
  RxString title = ''.obs;
  late String url;
  late String id;
  late String articleType;
  Rx<ReadDataModel> cvData = ReadDataModel().obs;
  final ScrollController scrollController = ScrollController();
  late StreamController<bool> appbarStream = StreamController<bool>.broadcast();

  @override
  void onInit() async {
    super.onInit();
    id = Get.parameters['id']!;
    url = 'https://www.bilibili.com/read/cv$id';
    title.value = Get.parameters['title'] ?? '';
    articleType = Get.parameters['articleType'] ?? 'read';
    scrollController.addListener(_scrollListener);
  }

  Future fetchCvData() async {
    var res = await ReadHttp.parseArticleCv(id: id);
    if (res['status']) {
      cvData.value = res['data'];
      title.value = cvData.value.readInfo!.title!;
    }
    return res;
  }

  // 跳转webview
  void onJumpWebview() {
    Get.toNamed('/webview', parameters: {
      'url': url,
      'type': 'webview',
      'pageTitle': title.value,
    });
  }

  void _scrollListener() {
    final double offset = scrollController.position.pixels;
    if (offset > 100) {
      appbarStream.add(true);
    } else {
      appbarStream.add(false);
    }
  }

  @override
  void onClose() {
    scrollController.removeListener(_scrollListener);
    appbarStream.close();
    super.onClose();
  }
}
