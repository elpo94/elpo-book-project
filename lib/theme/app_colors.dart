import 'package:flutter/material.dart';

class AppColors {

  // Base
  static const background = Color(0xFFFFFCF5);
  static const foreground = Color(0xFF3A2B1A);

  // Surfaces
  static const surface = Color(0xFFF3E9D2);
  static const surfaceOn = Color(0xFF3A2B1A);

  // Primary
  static const primary = Color(0xFFF5C05A);
  static const primaryOn = Color(0xFF3A2B1A);

  // Secondary
  static const secondary = Color(0xFFE2D6C5);
  static const secondaryOn = Color(0xFF3A2B1A);

  // Muted
  static const muted = Color(0xFFE2D6C5);
  static const mutedOn = Color(0xFF5A4632);

  // Accent
  static const accent = Color(0xFF6C8A4A);
  static const accentOn = Color(0xFFFFFCF5);

  // Error
  static const error = Color(0xFFD4183D);
  static const errorOn = Color(0xFFFFFFFF);

  // Border / Input
  static const border = Color(0xFFE1D5C7);
  static const inputBackground = Color(0xFFF3F3F5);

  // Others
  static const switchBackground = Color(0xFFCBCED4);

  // Status colors
  static const Color statusPlanned = Color(0xFFF4A261);   // 예정(오렌지/앰버)
  static const Color statusOngoing = Color(0xFF2D9CDB);   // 진행중(블루)
  static const Color statusDone = Color(0xFF27AE60);      // 완료(그린)
  static const Color statusOverdue = Color(0xFFEB5757);   // 지연(레드)

  // 상태 배경용 틴트 - badge/chip 배경에 쓰기 좋음
  static Color statusPlannedBg = const Color(0xFFF4A261).withOpacity(0.18);
  static Color statusOngoingBg = const Color(0xFF2D9CDB).withOpacity(0.16);
  static Color statusDoneBg = const Color(0xFF27AE60).withOpacity(0.16);
  static Color statusOverdueBg = const Color(0xFFEB5757).withOpacity(0.16);
}
