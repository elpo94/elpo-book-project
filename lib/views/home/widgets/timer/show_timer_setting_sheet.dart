import 'package:elpo_book_project/views/home/widgets/timer/timer_setting_sheet.dart';
import 'package:flutter/material.dart';
import '../../../../view_models/home/timer_vm.dart';

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
