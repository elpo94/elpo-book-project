import 'package:flutter/material.dart';

enum AppActionStyle { filled, outline, danger }

class AppActionButton extends StatelessWidget {
  final String label;
  final IconData? icon;
  final VoidCallback? onPressed;
  final AppActionStyle style;
  final EdgeInsets padding;

  const AppActionButton({
    super.key,
    required this.label,
    this.icon,
    this.onPressed,
    this.style = AppActionStyle.filled,
    this.padding = const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
  });

  @override
  Widget build(BuildContext context) {
    final baseText = Text(
      label,
      style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 16),
    );

    final child = icon == null
        ? baseText
        : Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 18),
        const SizedBox(width: 8),
        baseText,
      ],
    );

    switch (style) {
      case AppActionStyle.filled:
        return FilledButton(
          onPressed: onPressed,
          style: FilledButton.styleFrom(
            padding: padding,
            backgroundColor: const Color(0xFF452829),
            foregroundColor: Colors.white,
          ),
          child: child,
        );

      case AppActionStyle.outline:
        return OutlinedButton(
          onPressed: onPressed,
          style: OutlinedButton.styleFrom(
            padding: padding,
            foregroundColor: const Color(0xFF452829),
            side: const BorderSide(color: Color(0xFF452829)),
          ),
          child: child,
        );

      case AppActionStyle.danger:
        return FilledButton(
          onPressed: onPressed,
          style: FilledButton.styleFrom(
            padding: padding,
            backgroundColor: const Color(0xFFD65C5C),
            foregroundColor: Colors.white,
          ),
          child: child,
        );
    }
  }
}
