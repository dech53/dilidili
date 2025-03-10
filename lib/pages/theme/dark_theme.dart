import 'package:flutter/material.dart';

ThemeData darkMode = ThemeData(
  useMaterial3: true,
  appBarTheme: const AppBarTheme(
    scrolledUnderElevation: 0.0,
  ),
  colorScheme: ColorScheme.light(
      primary: const Color(0xFF3CA9FC),
      onPrimary: Colors.white,
      secondary: Colors.grey.withOpacity(0.25),
      tertiary: const Color(0xFFEE4667),
      inversePrimary: Colors.grey.shade600,
      inverseSurface: Colors.black87,
      onInverseSurface: Colors.black26,
      surfaceContainer: Colors.grey.shade300),
);
