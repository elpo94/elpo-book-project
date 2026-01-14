import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../view_models/home/timer_vm.dart';
import '../../../../widgets/button_style.dart';
import '../../../../widgets/confirm_dialog.dart';



class TimerResetButton extends StatelessWidget {
  final EdgeInsets padding;
  final bool enabled;

  const TimerResetButton({
    super.key,
    this.padding = const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
    this.enabled = true,
  });

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<TimerViewModel>();

    // 정책: 타겟 없으면 reset 안 보이게
    if (!vm.hasTarget) return const SizedBox.shrink();

    return AppActionButton(
      label: 'Reset',
      onPressed: !enabled
          ? null
          : () async {
        final ok = await showConfirmDialog(
          context,
          title: '타이머를 초기화할까요?',
          message: '누적된 시간이 00:00:00으로 돌아갑니다.\n이 작업은 되돌릴 수 없습니다.',
          cancelText: '취소',
          confirmText: '초기화',
          confirmColor: const Color(0xFFD65C5C),
        );

        if (ok) vm.reset();
      },
      style: AppActionStyle.outline, // or danger
      padding: padding,
    );
  }
}
