import 'package:flutter/material.dart';

enum AppButtonStyle {
  primary, // 설정 / Start / Stop : 갈색 filled + 흰 글씨
  outline, // 취소 : 기본 outline
  danger,  // Reset / 초기화 : 빨강 filled + 흰 글씨
}

class AppButtonColors {
  static const brown = Color(0xFF452829);
  static const danger = Color(0xFFD65C5C);
}

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
    final theme = Theme.of(context);

    switch (style) {
      case AppButtonStyle.primary:
        return FilledButton(
          onPressed: onPressed,
          style: FilledButton.styleFrom(
            padding: padding,
            backgroundColor: AppButtonColors.brown,
            foregroundColor: Colors.white,
            textStyle: const TextStyle(fontWeight: FontWeight.w700, fontSize: 16),
          ),
          child: Text(label),
        );

      case AppButtonStyle.danger:
        return FilledButton(
          onPressed: onPressed,
          style: FilledButton.styleFrom(
            padding: padding,
            backgroundColor: AppButtonColors.danger,
            foregroundColor: Colors.white,
            textStyle: const TextStyle(fontWeight: FontWeight.w700, fontSize: 16),
          ),
          child: Text(label),
        );

      case AppButtonStyle.outline:
        return OutlinedButton(
          onPressed: onPressed,
          style: OutlinedButton.styleFrom(
            padding: padding,
            foregroundColor: theme.colorScheme.onSurface,
            side: BorderSide(color: theme.colorScheme.outline),
            textStyle: const TextStyle(fontWeight: FontWeight.w700, fontSize: 16),
          ),
          child: Text(label),
        );
    }
  }
}
