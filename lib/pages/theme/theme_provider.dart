import 'package:dilidili/pages/theme/dark_theme.dart';
import 'package:dilidili/pages/theme/light_theme.dart';
import 'package:flutter/material.dart';

class ThemeProvider with ChangeNotifier {
  ThemeData _themeData = lightMode;
  ThemeData get themeData => _themeData;
  ThemeData get lightTheme => lightMode;
  ThemeData get darkTheme => darkMode;

  bool get isDarkMode => _themeData == darkMode;

  set theme(ThemeData themeData) {
    _themeData = themeData;
    notifyListeners();
  }

  void toggleTheme() {
    theme = isDarkMode ? darkMode : lightMode;
  }
}
