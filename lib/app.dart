import 'package:dilidili/pages/root/root_page.dart';
import 'package:dilidili/pages/theme/dark_theme.dart';
import 'package:dilidili/pages/theme/theme_provider.dart';
import 'package:dilidili/utils/storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

Size get designSize {
  final firstView = WidgetsBinding.instance.platformDispatcher.views.first;
  final logicalShortestSize =
      firstView.physicalSize.shortestSide / firstView.devicePixelRatio;
  final logicalLongestSize =
      firstView.physicalSize.longestSide / firstView.devicePixelRatio;
  const scaleFactor = 0.95;
  return Size(
    logicalShortestSize * scaleFactor,
    logicalLongestSize * scaleFactor,
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    double statusBarHeight = MediaQuery.of(context).padding.top;
    SPStorage.statusBarHeight = statusBarHeight;
    final themeController = Get.put(ThemeController());
    return ScreenUtilInit(
      designSize: designSize,
      builder: (context, child) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          theme: themeController.currentTheme,
          darkTheme: darkMode,
          themeMode: ThemeMode.system,
          home: const RootPage(),
        );
      },
    );
  }
}
