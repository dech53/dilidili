import 'package:dilidili/pages/root/root_page.dart';
import 'package:dilidili/pages/theme/dark_theme.dart';
import 'package:dilidili/pages/theme/theme_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

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

class MyApp extends ConsumerWidget {
  const MyApp({super.key});
//适配屏幕尺寸
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeData = ref.watch(themeProvider);
    return ScreenUtilInit(
      designSize: designSize,
      builder: (context, child) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          theme: themeData,
          darkTheme: darkMode,
          themeMode: ThemeMode.system,
          home: const RootPage(),
        );
      },
    );
  }
}
