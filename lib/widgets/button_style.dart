import 'package:flutter/material.dart';
import 'package:elpo_book_project/theme/app_colors.dart';

import 'app_button_style.dart';

class AppActionButton extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;
  final EdgeInsets padding;
  final AppButtonStyle style;

  const AppActionButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.padding = const EdgeInsets.symmetric(horizontal: 22, vertical: 14),
    this.style = AppButtonStyle.primary,
  });

  @override
  Widget build(BuildContext context) {
    switch (style) {
      case AppButtonStyle.primary:
      // Start / Stop
        return FilledButton(
          onPressed: onPressed,
          child: Text(label),
        );

      case AppButtonStyle.outline:
      // Reset (피그마 기준)
        return OutlinedButton(
          onPressed: onPressed,
          style: OutlinedButton.styleFrom(
            backgroundColor: AppColors.buttonSecondaryBg,
            foregroundColor: AppColors.buttonSecondaryFg,
            side: const BorderSide(
              color: AppColors.buttonSecondaryBorder,
              width: 1,
            ),
            padding: padding,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(14),
            ),
            textStyle: const TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 15,
            ),
          ),
          child: Text(label),
        );

      case AppButtonStyle.danger:
      // (지금은 거의 안 쓰는 게 맞음)
        return FilledButton(
          onPressed: onPressed,
          style: FilledButton.styleFrom(
            backgroundColor: const Color(0xFFD65C5C),
            foregroundColor: Colors.white,
          ),
          child: Text(label),
        );
    }
  }
}
