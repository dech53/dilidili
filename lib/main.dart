import 'dart:io';

import 'package:dilidili/http/dio_instance.dart';
import 'package:dilidili/model/color_type.dart';
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
import 'package:media_kit/media_kit.dart';
import 'app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await ScreenUtil.ensureScreenSize();
  MediaKit.ensureInitialized();
  await SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
  await SPStorage.init();
  await DioInstance.instance().getBuvid();
  await DioInstance.initDio();
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
  if (Platform.isAndroid) {
    runApp(DynamicColorBuilder(
      builder: ((ColorScheme? lightDynamic, ColorScheme? darkDynamic) {
        ColorScheme? lightColorScheme;
        if (lightDynamic != null && darkDynamic != null) {
          // dynamic取色成功
          lightColorScheme = lightDynamic.harmonized();
        } else {
          // dynamic取色失败，采用品牌色
          lightColorScheme = ColorScheme.fromSeed(
            seedColor: colorThemeTypes[0]['color'],
            brightness: Brightness.light,
          );
        }
        return GetMaterialApp(
          title: 'Dilidili',
          theme: ThemeData(
            colorScheme: lightColorScheme,
            snackBarTheme: SnackBarThemeData(
              actionTextColor: lightColorScheme.primary,
              backgroundColor: lightColorScheme.secondaryContainer,
              closeIconColor: lightColorScheme.secondary,
              contentTextStyle: TextStyle(color: lightColorScheme.secondary),
              elevation: 20,
            ),
            pageTransitionsTheme: const PageTransitionsTheme(
              builders: <TargetPlatform, PageTransitionsBuilder>{
                TargetPlatform.android: ZoomPageTransitionsBuilder(
                  allowEnterRouteSnapshotting: false,
                ),
              },
            ),
          ),
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
    ));
  } else {
    ColorScheme lightColorScheme = ColorScheme.fromSeed(
      seedColor: colorThemeTypes[0]['color'],
      brightness: Brightness.light,
    );
    runApp(
      GetMaterialApp(
        title: 'Dilidili',
        theme: ThemeData(
          colorScheme: lightColorScheme,
          snackBarTheme: SnackBarThemeData(
            actionTextColor: lightColorScheme.primary,
            backgroundColor: lightColorScheme.secondaryContainer,
            closeIconColor: lightColorScheme.secondary,
            contentTextStyle: TextStyle(color: lightColorScheme.secondary),
            elevation: 20,
          ),
          pageTransitionsTheme: const PageTransitionsTheme(
            builders: <TargetPlatform, PageTransitionsBuilder>{
              TargetPlatform.android: ZoomPageTransitionsBuilder(
                allowEnterRouteSnapshotting: false,
              ),
            },
          ),
        ),
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
      ),
    );
  }
}
