import 'package:flutter/material.dart';

import 'app_colors.dart';

final lightColorScheme = ColorScheme(
  brightness: Brightness.light,
  primary: AppColors.primary,
  onPrimary: AppColors.primaryOn,

  secondary: AppColors.secondary,
  onSecondary: AppColors.secondaryOn,

  surface: AppColors.surface,
  onSurface: AppColors.surfaceOn,

  background: AppColors.background,
  onBackground: AppColors.foreground,

  error: AppColors.error,
  onError: AppColors.errorOn,

  tertiary: AppColors.accent,
  onTertiary: AppColors.accentOn,

  surfaceTint: Colors.transparent,
);


final ThemeData appTheme = ThemeData(
  useMaterial3: true,
  colorScheme: lightColorScheme,
  fontFamily: 'Pretendard',

  scaffoldBackgroundColor: AppColors.background,

  appBarTheme: const AppBarTheme(
    backgroundColor: AppColors.background,
    foregroundColor: AppColors.foreground,
    elevation: 0,
    centerTitle: true,
    titleTextStyle: TextStyle(
      fontFamily: 'AritaBuri',
      fontWeight: FontWeight.w600,
      fontSize: 20, // 18 → 20
      color: AppColors.foreground,
    ),
  ),


  cardTheme: CardThemeData(
    color: AppColors.surface,
    surfaceTintColor: Colors.transparent,
    elevation: 1,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(16),
    ),
  ),

  filledButtonTheme: FilledButtonThemeData(
    style: FilledButton.styleFrom(
      backgroundColor: const Color(0xFFB58A53),  // 피그마색
      foregroundColor: const Color(0xFF3A2B1A),  // 글씨
      padding: const EdgeInsets.symmetric(
        horizontal: 22,
        vertical: 12,
      ),
      minimumSize: const Size(0, 48),          // 버튼 높이 고정
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(14),
      ),
      textStyle: const TextStyle(
        fontWeight: FontWeight.w600,
        fontSize: 14,
      ),
    ),
  ),



  outlinedButtonTheme: OutlinedButtonThemeData(
    style: OutlinedButton.styleFrom(
      foregroundColor: const Color(0xFF3A2B1A),
      side: const BorderSide(color: Color(0xFFB58A53)),
      padding: const EdgeInsets.symmetric(
        horizontal: 22,
        vertical: 12,
      ),
      minimumSize: const Size(0, 48),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(14),
      ),
      textStyle: const TextStyle(
        fontWeight: FontWeight.w600,
        fontSize: 14,
      ),
    ),
  ),


  progressIndicatorTheme: const ProgressIndicatorThemeData(
    color: AppColors.primary,
    linearTrackColor: AppColors.secondary,
  ),

  inputDecorationTheme: InputDecorationTheme(
    filled: true,
    fillColor: AppColors.inputBackground,
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(10),
      borderSide: const BorderSide(color: AppColors.border),
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(10),
      borderSide: const BorderSide(color: AppColors.border),
    ),
  ),
  bottomNavigationBarTheme: const BottomNavigationBarThemeData(
    backgroundColor: AppColors.background,
    selectedItemColor: AppColors.foreground, // 브라운
    unselectedItemColor: AppColors.mutedOn,  // 연한 브라운
    selectedLabelStyle: TextStyle(
      fontSize: 12,
      fontWeight: FontWeight.w500,
    ),
    unselectedLabelStyle: TextStyle(
      fontSize: 12,
      fontWeight: FontWeight.w400,
    ),
    type: BottomNavigationBarType.fixed,
  ),

);

