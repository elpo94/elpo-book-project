import 'package:elpo_book_project/view_models/home/timer_vm.dart';
import 'package:elpo_book_project/views/home/widgets/timer_setting_sheet.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../widgets/confirm_dialog.dart';

class TimerControls extends StatelessWidget {
  final bool compact;
  final EdgeInsets padding;

  const TimerControls({
    super.key,
    this.compact = false,
    EdgeInsets? padding,
  }) : padding = padding ?? EdgeInsets.zero;

  Future<void> _openSettingSheet(BuildContext context, TimerViewModel vm) async {
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
  }

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<TimerViewModel>();

    // ✅ 정책: running 중에도 reset 가능
    final showReset = vm.hasTarget;

    // 버튼 패딩/크기 (홈 카드 / 확장 화면)
    final buttonPadding = compact
        ? const EdgeInsets.symmetric(horizontal: 18, vertical: 12)
        : const EdgeInsets.symmetric(horizontal: 22, vertical: 14);

    final fontSize = compact ? 16.0 : 16.0;

    return Padding(
      padding: padding,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // 1) 설정 / Start / Stop
          if (!vm.hasTarget) ...[
            FilledButton(
              onPressed: () => _openSettingSheet(context, vm),
              style: FilledButton.styleFrom(
                backgroundColor: const Color(0xFF452829),
                foregroundColor: Colors.white,
                padding: buttonPadding,
              ),
              child: Text(
                "설정",
                style: TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: fontSize,
                ),
              ),
            ),
          ] else if (!vm.isRunning) ...[
            FilledButton(
              onPressed: vm.remaining == Duration.zero ? null : vm.start,
              style: FilledButton.styleFrom(padding: buttonPadding),
              child: const Text("Start"),
            ),
          ] else ...[
            FilledButton(
              onPressed: vm.stop,
              style: FilledButton.styleFrom(padding: buttonPadding),
              child: const Text("Stop"),
            ),
          ],

          const SizedBox(width: 12),

          // 2) Reset (항상 가능 + confirm)
          if (showReset)
            OutlinedButton(
              onPressed: () async {
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
              style: OutlinedButton.styleFrom(
                padding: buttonPadding,
              ),
              child: const Text("Reset"),
            ),
        ],
      ),
    );
  }
}
