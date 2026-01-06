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

  // ⭐ 기본 폰트
  fontFamily: 'Pretendard',

  scaffoldBackgroundColor: lightColorScheme.surface,

  appBarTheme: AppBarTheme(
    backgroundColor: lightColorScheme.surface,
    foregroundColor: lightColorScheme.onSurface,
    elevation: 0,
  ),

  bottomNavigationBarTheme: BottomNavigationBarThemeData(
    backgroundColor: lightColorScheme.surface,
    selectedItemColor: lightColorScheme.primary,
    unselectedItemColor: lightColorScheme.onSurfaceVariant,
  ),


  cardTheme: CardThemeData(
    color: lightColorScheme.surface,
    surfaceTintColor: Colors.transparent,
    elevation: 1,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
  ),

  textTheme: const TextTheme(
    bodyMedium: TextStyle(),
    bodyLarge: TextStyle(),
    titleLarge: TextStyle(fontFamily: 'AritaBuri', fontWeight: FontWeight.w600),

  ),
  filledButtonTheme: FilledButtonThemeData(
    style: FilledButton.styleFrom(
      backgroundColor: AppColors.primary,
      foregroundColor: AppColors.primaryOn,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      padding: const EdgeInsets.symmetric(vertical: 12),
    ),
  ),

  outlinedButtonTheme: OutlinedButtonThemeData(
    style: OutlinedButton.styleFrom(
      side: BorderSide(color: AppColors.border),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      padding: const EdgeInsets.symmetric(vertical: 12),
    ),
  ),
  inputDecorationTheme: InputDecorationTheme(
    filled: true,
    fillColor: AppColors.inputBackground,
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: BorderSide(color: AppColors.border),
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: BorderSide(color: AppColors.border),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: BorderSide(color: AppColors.primary),
    ),
  ),
  chipTheme: ChipThemeData(
    selectedColor: AppColors.primary,
    backgroundColor: Colors.white,
    labelStyle: const TextStyle(
      fontWeight: FontWeight.w500,
    ),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(10),
    ),
  ),
);
