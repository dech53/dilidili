import 'package:dilidili/pages/theme/dark_theme.dart';
import 'package:dilidili/pages/theme/light_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ThemeNotifier extends StateNotifier<ThemeData> {
  ThemeNotifier() : super(lightMode);

  ThemeData get lightTheme => lightMode;
  ThemeData get darkTheme => darkMode;

  bool get isDarkMode => state == darkMode;

  void toggleTheme() {
    state = isDarkMode ? lightMode : darkMode;
  }
}

final themeProvider = StateNotifierProvider<ThemeNotifier, ThemeData>((ref) {
  return ThemeNotifier();
});
