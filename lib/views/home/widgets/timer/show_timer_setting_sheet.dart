import 'package:flutter/material.dart';
import '../../../../view_models/home/timer_vm.dart';
import 'timer_setting_sheet.dart';

Future<void> showTimerSettingSheet(
    BuildContext context,
    TimerViewModel vm,
    ) async {
  vm.beginEdit();

  try {
    await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      showDragHandle: false,
      builder: (_) => TimerSettingSheet(
        initial: vm.targetDuration == Duration.zero
            ? const Duration(minutes: 15)
            : vm.targetDuration,
        onConfirm: (d) => vm.setTarget(d),
      ),
    );
  } finally {
    vm.endEdit();
  }
}
