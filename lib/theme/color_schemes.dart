import 'package:flutter/material.dart';
import 'app_colors.dart';

final lightColorScheme = ColorScheme(
  brightness: Brightness.light,

  surface: AppColors.background,
  onSurface: AppColors.foreground,

  surfaceTint: Colors.transparent,
  surfaceContainer: AppColors.muted,

  primary: AppColors.primary,
  onPrimary: AppColors.primaryOn,

  secondary: AppColors.secondary,
  onSecondary: AppColors.secondaryOn,

  tertiary: AppColors.accent,
  onTertiary: AppColors.accentOn,

  error: AppColors.error,
  onError: AppColors.errorOn,

  outline: AppColors.border,
  outlineVariant: AppColors.switchBackground,
);
