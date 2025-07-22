import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'app_colors.dart';

class AppTheme {
  static final ThemeData lightTheme = ThemeData(
    brightness: Brightness.light,
    scaffoldBackgroundColor: AppColors.primaryLight,
    appBarTheme: AppBarTheme(
      color: AppColors.secondaryBlue,
      iconTheme: const IconThemeData(color: Colors.white),
      titleTextStyle: TextStyle(
        color: Colors.white,
        fontSize: 30.sp,
        fontWeight: FontWeight.bold,
      ),
    ),
    textTheme: TextTheme(
      titleLarge: TextStyle(
        color: AppColors.textPrimaryLight,
        fontSize: 20.sp,
        fontWeight: FontWeight.w600,
      ),
      bodyMedium: TextStyle(
        color: AppColors.textPrimaryLight,
        fontSize: 17.sp,
      ),
    ),
    colorScheme: const ColorScheme.light(
      primary: AppColors.secondaryBlue,
      onPrimary: Colors.white,
      secondary: AppColors.accentPurple,
      onSecondary: Colors.white,
      surface: Colors.white,
      onSurface: AppColors.textPrimaryLight,
      error: Colors.red,
      onError: Colors.white,
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.elevatedButton,
        foregroundColor: Colors.white,
      ),
    ),
    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      backgroundColor: AppColors.accentPurple,
    ),
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      backgroundColor: Colors.white,
      selectedItemColor: AppColors.secondaryBlue,
      unselectedItemColor: Colors.grey,
    ),
  );

  static final ThemeData darkTheme = ThemeData(
    brightness: Brightness.dark,
    scaffoldBackgroundColor: AppColors.primaryDark,
    appBarTheme: const AppBarTheme(
      color: AppColors.textFormFieldFill,
      // Modern dark AppBar
      elevation: 0.5,
      shadowColor: Colors.black54,
      iconTheme: IconThemeData(color: Colors.white),
      titleTextStyle: TextStyle(
        color: Colors.white,
        fontSize: 30,
        fontWeight: FontWeight.bold,
      ),
    ),
    textTheme: TextTheme(
      titleLarge: TextStyle(
        color: AppColors.textPrimaryDark,
        fontSize: 20.sp,
        fontWeight: FontWeight.w600,
      ),
      bodyMedium: TextStyle(
        color: AppColors.textPrimaryDark,
        fontSize: 17.sp,
      ),
    ),
    colorScheme: const ColorScheme.dark(
      primary: AppColors.lightAccent,
      onPrimary: Colors.black,
      secondary: AppColors.linkBlue,
      onSecondary: Colors.black,
      surface: AppColors.textFormFieldFill,
      onSurface: AppColors.textPrimaryDark,
      error: Colors.redAccent,
      onError: Colors.black,
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.lightAccent,
        foregroundColor: Colors.black,
      ),
    ),
    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      backgroundColor: AppColors.linkBlue,
    ),
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      backgroundColor: AppColors.primaryDark,
      selectedItemColor: AppColors.lightAccent,
      unselectedItemColor: Colors.grey,
    ),
  );
}
