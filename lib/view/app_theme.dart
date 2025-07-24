import 'package:flutter/material.dart';

class AppTheme {
  static Color primaryColor = Colors.blueAccent;

  static ThemeData get themeData => ThemeData(
    primaryColor: primaryColor,
    colorScheme: ColorScheme.fromSeed(seedColor: Colors.blueAccent),
    useMaterial3: true,
  );
}
