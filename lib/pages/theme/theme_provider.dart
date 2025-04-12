import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ThemeController extends GetxController {
  final Rx<ThemeData> _currentTheme = ThemeData.light().obs;

  ThemeData get currentTheme => _currentTheme.value;

  void toggleTheme() {
    _currentTheme.value = _currentTheme.value == ThemeData.light()
        ? ThemeData.dark()
        : ThemeData.light();
    update();
  }
}