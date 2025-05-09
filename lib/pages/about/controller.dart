import 'package:get/get.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter/material.dart';

class AboutController extends GetxController {
  RxString currentVersion = ''.obs;
  RxBool isLoading = true.obs;
  RxBool isUpdate = false.obs;
  @override
  void onInit() async {
    super.onInit();
    var result = await PackageInfo.fromPlatform();
    currentVersion.value = result.version;
  }

  // 跳转github
  githubUrl() {
    launchUrl(
      Uri.parse('https://github.com/dech53/dilidili'),
      mode: LaunchMode.externalApplication,
    );
  }
}
