import 'package:flutter/material.dart';

final lightColorScheme = ColorScheme.fromSeed(
  seedColor: const Color(0xFFF5C05A),
  brightness: Brightness.light,
  surface: const Color(0xFFFFFCF5),
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
);
