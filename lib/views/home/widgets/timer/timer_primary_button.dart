import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../view_models/home/timer_vm.dart';
import '../../../../widgets/button_style.dart';
import 'timer_setting_sheet.dart';

class TimerPrimaryButton extends StatelessWidget {
  final EdgeInsets padding;
  final bool compact;

  const TimerPrimaryButton({
    super.key,
    required this.padding,
    this.compact = false,
  });

  Future<void> _openSettingSheet(BuildContext context, TimerViewModel vm) async {
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

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<TimerViewModel>();

    // ✅ 분기 정책
    final isSettingMode = !vm.hasTarget;
    final isStartMode = vm.hasTarget && !vm.isRunning;
    final isStopMode = vm.hasTarget && vm.isRunning;

    if (isSettingMode) {
      return AppActionButton(
        label: '설정',
        icon: Icons.edit, // 필요없으면 제거 가능
        onPressed: () => _openSettingSheet(context, vm),
        style: AppActionStyle.filled,
        padding: padding,
      );
    }

    if (isStartMode) {
      return AppActionButton(
        label: 'Start',
        onPressed: vm.remaining == Duration.zero ? null : vm.start,
        style: AppActionStyle.filled,
        padding: padding,
      );
    }

    // stop mode
    return AppActionButton(
      label: 'Stop',
      onPressed: vm.stop,
      style: AppActionStyle.filled,
      padding: padding,
    );
  }
}
