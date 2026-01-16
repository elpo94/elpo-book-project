import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../view_models/home/timer_vm.dart';
import 'timer_button.dart';

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
    final vm = context.watch<TimerViewModel>();

    return Padding(
      padding: padding,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          TimerButton(
            vm: vm,
            kind: TimerButtonKind.primary,
            compact: compact,
          ),
          const SizedBox(width: 12),
          TimerButton(
            vm: vm,
            kind: TimerButtonKind.reset,
            compact: compact,
          ),
        ],
      ),
    );
  }
}
