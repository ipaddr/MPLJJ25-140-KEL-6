import 'package:flutter/material.dart';

class AppColors {
  static const Color primaryColor = Color(0xFF1E88E5);
  static const Color secondaryColor = Color(0xFFFFA726);
  static const Color backgroundColor = Color(0xFFF5F5F5);
  static const Color textColor = Color(0xFF212121);
}

final ThemeData appTheme = ThemeData(
  primaryColor: AppColors.primaryColor,
  scaffoldBackgroundColor: AppColors.backgroundColor,
  colorScheme: ColorScheme.fromSwatch().copyWith(
    secondary: AppColors.secondaryColor,
  ),
  textTheme: const TextTheme(
    titleLarge: TextStyle(
      color: AppColors.textColor,
      fontSize: 20,
      fontWeight: FontWeight.bold,
    ),
    bodyMedium: TextStyle(
      color: AppColors.textColor,
      fontSize: 16,
    ),
  ),
);
