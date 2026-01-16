import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../view_models/home/timer_vm.dart';
import 'timer_primary_button.dart';
import 'timer_reset_button.dart';

class TimerControls extends StatelessWidget {
  final bool compact;
  final EdgeInsets padding;
  final VoidCallback onReset;

  const TimerControls({
    super.key,
    this.compact = false,
    this.padding = EdgeInsets.zero,
    required this.onReset,
  });

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<TimerViewModel>();

    return Padding(
      padding: padding,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          TimerPrimaryButton(compact: compact),
          const SizedBox(width: 12),
          if (vm.hasTarget)
            TimerResetButton(
              compact: compact,
              onPressed: onReset,
            ),
        ],
      ),
    );
  }
}
