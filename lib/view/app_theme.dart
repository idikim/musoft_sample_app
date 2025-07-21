import 'package:flutter/material.dart';

class AppTheme {
  static Color primaryColor = Colors.blue;

  static ThemeData get themeData => ThemeData(
    primaryColor: primaryColor,
    colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
    useMaterial3: true,
  );

  static void setPrimaryColor(Color color) {
    primaryColor = color;
  }
}
