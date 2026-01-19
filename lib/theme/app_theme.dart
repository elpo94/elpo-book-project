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
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
  ),

  filledButtonTheme: FilledButtonThemeData(
    style: FilledButton.styleFrom(
      backgroundColor: AppColors.buttonPrimaryBg,
      foregroundColor: AppColors.buttonPrimaryFg,
      padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 14),
      minimumSize: const Size(0, 48),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(14),
      ),
      textStyle: const TextStyle(
        fontWeight: FontWeight.w600,
        fontSize: 15,
      ),
    ),
  ),

  outlinedButtonTheme: OutlinedButtonThemeData(
    style: OutlinedButton.styleFrom(
      foregroundColor: const Color(0xFF3A2B1A),
      side: const BorderSide(color: Color(0xFFB58A53)),
      padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 12),
      minimumSize: const Size(0, 48),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      textStyle: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
    ),
  ),

  progressIndicatorTheme: const ProgressIndicatorThemeData(
    color: AppColors.primary,
    linearTrackColor: AppColors.secondary,
  ),

  inputDecorationTheme: InputDecorationTheme(
    filled: true,
    fillColor: AppColors.surface, // ← 피그마 베이지 카드색

    contentPadding: const EdgeInsets.symmetric(
      horizontal: 14,
      vertical: 14,
    ),

    hintStyle: TextStyle(
      color: AppColors.mutedOn, // 안내문구 연한 브라운
      fontSize: 14,
    ),

    labelStyle: TextStyle(
      color: AppColors.mutedOn,
      fontSize: 13,
    ),

    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(14),
      borderSide: BorderSide(
        color: AppColors.border, // 연한 베이지 테두리
        width: 1,
      ),
    ),

    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(14),
      borderSide: BorderSide(
        color: AppColors.primary, // 포커스 시 브라운
        width: 1.2,
      ),
    ),

    disabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(14),
      borderSide: BorderSide(
        color: AppColors.border, // disabled도 회색 X
        width: 1,
      ),
    ),
  ),



  bottomNavigationBarTheme: const BottomNavigationBarThemeData(
    backgroundColor: AppColors.background,
    selectedItemColor: AppColors.foreground, // 브라운
    unselectedItemColor: AppColors.mutedOn, // 연한 브라운
    selectedLabelStyle: TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
    unselectedLabelStyle: TextStyle(fontSize: 12, fontWeight: FontWeight.w400),
    type: BottomNavigationBarType.fixed,
  ),
);
