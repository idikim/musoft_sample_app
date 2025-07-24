import 'package:flutter/material.dart';

class AppTheme {
  static Color primaryColor = Colors.blueAccent;

  static ThemeData get themeData => ThemeData(
    fontFamily: 'Pretendard',
    scaffoldBackgroundColor: Colors.white,
    appBarTheme: AppBarTheme(
      backgroundColor: Colors.white,
      elevation: 0,
      titleTextStyle: TextStyle(
        fontSize: 16,
        color: Colors.black,
        fontWeight: FontWeight.bold,
      ),
    ),
    primaryColor: primaryColor,
    colorScheme: ColorScheme.fromSeed(seedColor: Colors.blueAccent),
    useMaterial3: true,
  );
}
