import 'package:dating_app/themes/colors.dart';
import 'package:flutter/material.dart';

class AppTheme {
  static const colors = AppColors();

  static ThemeData appTheme = ThemeData(
    colorScheme: const ColorScheme.light(
        primary: Color(0xFFFF5864),
        secondary: Color(0xFFCCEEE7),
        error: Colors.red,
        onPrimary: Colors.white,
        onSecondary: Colors.white,
        onError: Colors.black,
        brightness: Brightness.light),
  );
}
