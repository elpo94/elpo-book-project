import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../view_models/home/timer_vm.dart';
import '../../../../widgets/button_style.dart';
import '../../../../widgets/confirm_dialog.dart';
import 'show_timer_setting_sheet.dart';

enum TimerButtonKind {
  primary, // 설정 / Start / Stop
  reset,   // Reset (confirm)
}

class TimerButton extends StatelessWidget {
  final TimerViewModel vm; // ✅ vm 주입
  final TimerButtonKind kind;
  final bool compact;

  const TimerButton({
    super.key,
    required this.vm,
    required this.kind,
    this.compact = false,
  });

  EdgeInsets _pad() => compact
      ? const EdgeInsets.symmetric(horizontal: 18, vertical: 12)
      : const EdgeInsets.symmetric(horizontal: 22, vertical: 14);

  @override
  Widget build(BuildContext context) {
    // ✅ 더 이상 watch 안 함

    if (kind == TimerButtonKind.reset) {
      if (!vm.hasTarget) return const SizedBox.shrink();

      return AppActionButton(
        label: 'Reset',
        padding: _pad(),
        style: AppButtonStyle.danger,
        onPressed: () async {
          final ok = await showConfirmDialog(
            context,
            title: '타이머를 초기화할까요?',
            message: '누적된 시간이 00:00:00으로 돌아갑니다.\n이 작업은 되돌릴 수 없습니다.',
            cancelText: '취소',
            confirmText: '초기화',
            confirmColor: const Color(0xFFD65C5C),
          );

          if (ok) {
            vm.reset();
           // if (context.mounted) Navigator.pop(context); // 확장 화면 닫고 홈 복귀
          }
        },
      );
    }

    if (!vm.hasTarget) {
      return AppActionButton(
        label: '설정',
        padding: _pad(),
        style: AppButtonStyle.primary,
        onPressed: () => showTimerSettingSheet(context, vm),
      );
    }

    if (!vm.isRunning) {
      final canStart = vm.remaining > Duration.zero;

      return AppActionButton(
        label: 'Start',
        padding: _pad(),
        style: AppButtonStyle.primary,
        onPressed: canStart ? vm.start : null,
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
