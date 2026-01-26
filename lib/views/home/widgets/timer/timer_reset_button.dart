import 'package:flutter/material.dart';
import '../../../../widgets/app_button_style.dart';
import '../../../../widgets/button_style.dart';

class TimerResetButton extends StatelessWidget {
  final bool compact;
  final VoidCallback? onPressed;

  const TimerResetButton({
    super.key,
    this.compact = false,
    this.onPressed,
  });

  EdgeInsets get _padding => compact
      ? const EdgeInsets.symmetric(horizontal: 18, vertical: 12)
      : const EdgeInsets.symmetric(horizontal: 22, vertical: 14);

  @override
  Widget build(BuildContext context) {
    return AppActionButton(
      label: '초기화',
      onPressed: onPressed,
      padding: _padding,
      style: AppButtonStyle.outline, // ✅ 핵심
    );
  }
}
