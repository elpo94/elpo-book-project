import 'package:elpo_book_project/views/home/widgets/timer/timer_reset_button.dart';
import 'package:flutter/material.dart';
import 'timer_primary_button.dart';

class TimerControls extends StatelessWidget {
  final bool compact;
  final EdgeInsets padding;

  const TimerControls({
    super.key,
    this.compact = false,
    this.padding = EdgeInsets.zero,
  });

  @override
  Widget build(BuildContext context) {
    final buttonPadding = compact
        ? const EdgeInsets.symmetric(horizontal: 18, vertical: 12)
        : const EdgeInsets.symmetric(horizontal: 22, vertical: 14);

    return Padding(
      padding: padding,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          TimerPrimaryButton(padding: buttonPadding, compact: compact),
          const SizedBox(width: 12),
          TimerResetButton(padding: buttonPadding),
        ],
      ),
    );
  }
}
