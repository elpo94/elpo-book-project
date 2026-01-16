import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../view_models/home/timer_vm.dart';
import '../../../../widgets/app_button_style.dart';
import '../../../../widgets/button_style.dart';
import 'show_timer_setting_sheet.dart';

class TimerPrimaryButton extends StatelessWidget {
  final bool compact;

  const TimerPrimaryButton({super.key, this.compact = false});

  EdgeInsets _pad() => compact
      ? const EdgeInsets.symmetric(horizontal: 18, vertical: 12)
      : const EdgeInsets.symmetric(horizontal: 22, vertical: 14);

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<TimerViewModel>();

    if (!vm.hasTarget) {
      return AppActionButton(
        label: '설정',
        padding: _pad(),
        style: AppButtonStyle.primary,
        onPressed: () => showTimerSettingSheet(context, vm),
      );
    }

    if (!vm.isRunning) {
      return AppActionButton(
        label: 'Start',
        padding: _pad(),
        style: AppButtonStyle.primary,
        onPressed: vm.remaining > Duration.zero ? vm.start : null,
      );
    }

    return AppActionButton(
      label: 'Stop',
      padding: _pad(),
      style: AppButtonStyle.primary,
      onPressed: vm.stop,
    );
  }
}
