import 'package:flutter/material.dart';

class AppTheme {
  static Color primaryColor = Colors.blueAccent;

  static ThemeData get themeData => ThemeData(
    scaffoldBackgroundColor: Colors.white,
    appBarTheme: AppBarTheme(backgroundColor: Colors.white, elevation: 0),
    primaryColor: primaryColor,
    colorScheme: ColorScheme.fromSeed(seedColor: Colors.blueAccent),
    useMaterial3: true,
  );
}
