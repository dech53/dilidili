import 'package:dilidili/model/color_type.dart';
import 'package:dilidili/utils/storage.dart';
import 'package:dynamic_color/dynamic_color.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';

class ThemeController extends GetxController {
  final Box setting = SPStorage.setting;
  RxBool dynamicColor = true.obs;
  RxInt customColor = 0.obs;

  @override
  void onInit() {
    super.onInit();
    dynamicColor.value =
        setting.get(SettingBoxKey.dynamicColor, defaultValue: true);
    customColor.value = setting.get(SettingBoxKey.customColor, defaultValue: 0);
  }

  void setDynamicColor(bool value) {
    dynamicColor.value = value;
    setting.put(SettingBoxKey.dynamicColor, value);
  }

  void setCustomColor(int index) {
    customColor.value = index;
    setting.put(SettingBoxKey.customColor, index);
  }

  Color get seedColor => colorThemeTypes[customColor.value]['color'];

  ColorScheme lightColorScheme({
    ColorScheme? lightDynamic,
    ColorScheme? darkDynamic,
  }) {
    if (dynamicColor.value && lightDynamic != null && darkDynamic != null) {
      return lightDynamic.harmonized();
    }

    return ColorScheme.fromSeed(
      seedColor: seedColor,
      brightness: Brightness.light,
    );
  }

  ThemeData themeData(ColorScheme colorScheme) {
    return ThemeData(
      colorScheme: colorScheme,
      snackBarTheme: SnackBarThemeData(
        actionTextColor: colorScheme.primary,
        backgroundColor: colorScheme.secondaryContainer,
        closeIconColor: colorScheme.secondary,
        contentTextStyle: TextStyle(color: colorScheme.secondary),
        elevation: 20,
      ),
      pageTransitionsTheme: const PageTransitionsTheme(
        builders: <TargetPlatform, PageTransitionsBuilder>{
          TargetPlatform.android: ZoomPageTransitionsBuilder(
            allowEnterRouteSnapshotting: false,
          ),
        },
      ),
    );
  }
}
