import 'dart:io';

import 'package:dilidili/common/custom_toast.dart';
import 'package:dilidili/http/dio_instance.dart';
import 'package:dilidili/pages/download/controller.dart';
import 'package:dilidili/pages/theme/theme_provider.dart';
import 'package:dilidili/pages/search/view.dart';
import 'package:dilidili/pages/video/detail/view.dart';
import 'package:dilidili/router/app_pages.dart';
import 'package:dynamic_color/dynamic_color.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:dilidili/utils/storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_displaymode/flutter_displaymode.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:get/get.dart';
import 'package:liquid_glass_widgets/liquid_glass_widgets.dart';
import 'package:media_kit/media_kit.dart';
import 'app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await LiquidGlassWidgets.initialize();
  await ScreenUtil.ensureScreenSize();
  MediaKit.ensureInitialized();
  await SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
  await SPStorage.init();
  await DioInstance.instance().getBuvid();
  await DioInstance.initDio();
  Get.put(DownloadController(), permanent: true);
  if (Platform.isAndroid) {
    try {
      late List modes;
      FlutterDisplayMode.supported.then(
        (value) {
          modes = value;
          DisplayMode f = DisplayMode.auto;
          DisplayMode preferred = modes.toList().firstWhere((el) => el == f);
          FlutterDisplayMode.setPreferredMode(preferred);
        },
      );
    } catch (_) {}
  }
  final ThemeController themeController = Get.put(ThemeController());

  if (Platform.isAndroid) {
    runApp(DynamicColorBuilder(
      builder: ((ColorScheme? lightDynamic, ColorScheme? darkDynamic) {
        return Obx(() {
          final ColorScheme lightColorScheme = themeController.lightColorScheme(
            lightDynamic: lightDynamic,
            darkDynamic: darkDynamic,
          );

          return GetMaterialApp(
            title: 'Lumo',
            theme: themeController.themeData(lightColorScheme),
            builder: (BuildContext context, Widget? child) {
              return FlutterSmartDialog(
                toastBuilder: (String msg) => CustomToast(msg: msg),
                child: MediaQuery(
                  data: MediaQuery.of(context)
                      .copyWith(textScaler: const TextScaler.linear(1.0)),
                  child: child!,
                ),
              );
            },
            getPages: Routes.getPages,
            debugShowCheckedModeBanner: false,
            home: const MyApp(),
            navigatorObservers: [
              VideoPage.routeObserver,
              SearchPage.routeObserver,
            ],
            localizationsDelegates: const [
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            supportedLocales: const [
              Locale('zh', 'CN'),
            ],
          );
        });
      }),
    ));
  } else {
    runApp(
      Obx(() {
        final ColorScheme lightColorScheme = themeController.lightColorScheme();

        return GetMaterialApp(
          title: 'Lumo',
          theme: themeController.themeData(lightColorScheme),
          builder: FlutterSmartDialog.init(),
          getPages: Routes.getPages,
          debugShowCheckedModeBanner: false,
          home: const MyApp(),
          navigatorObservers: [
            VideoPage.routeObserver,
            SearchPage.routeObserver,
          ],
          localizationsDelegates: const [
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: const [
            Locale('zh', 'CN'),
          ],
        );
      }),
    );
  }
}
