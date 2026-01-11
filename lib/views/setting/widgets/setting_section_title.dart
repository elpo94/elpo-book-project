import 'package:flutter/material.dart';
import '../../../theme/app_colors.dart';

class SettingSectionTitle extends StatelessWidget {
  final String text;
  const SettingSectionTitle(this.text, {super.key});

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: const TextStyle(
        fontSize: 13,
        fontWeight: FontWeight.w700,
        color: AppColors.foreground,
      ),
    );
  }
}
