import 'package:dilidili/http/dio_instance.dart';
import 'package:dilidili/pages/search/view.dart';
import 'package:dilidili/pages/video/detail/view.dart';
import 'package:dilidili/router/app_pages.dart';
import 'package:dilidili/utils/storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:get/get.dart';
import 'package:media_kit/media_kit.dart';
import 'app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  MediaKit.ensureInitialized();
  SPStorage.init();
  await DioInstance.initDio();
  runApp(
    GetMaterialApp(
      builder: FlutterSmartDialog.init(),
      getPages: Routes.getPages,
      debugShowCheckedModeBanner: false,
      home: const MyApp(),
      navigatorObservers: [
        VideoPage.routeObserver,
        SearchPage.routeObserver,
      ],
    ),
  );
}
