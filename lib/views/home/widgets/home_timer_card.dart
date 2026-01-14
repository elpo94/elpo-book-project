import 'package:elpo_book_project/view_models/home/timer_vm.dart';
import 'package:elpo_book_project/views/home/dialog/reset_dialog.dart';
import 'package:elpo_book_project/views/home/widgets/timer_setting_sheet.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../widgets/confirm_dialog.dart';

class HomeTimerCard extends StatelessWidget {
  final VoidCallback? onTap;

  const HomeTimerCard({super.key, required this.onTap});

  String _format(Duration d) {
    String two(int n) => n.toString().padLeft(2, '0');
    final h = d.inHours;
    final m = d.inMinutes.remainder(60);
    final s = d.inSeconds.remainder(60);
    return '${two(h)}:${two(m)}:${two(s)}';
  }

  Future<void> _openSettingSheet(
    BuildContext context,
    TimerViewModel vm,
  ) async {
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

    final display = vm.isRunning
        ? vm.remaining
        : (vm.hasTarget ? vm.remaining : Duration.zero);
    final timeText = _format(display);

    final showReset = vm.hasTarget;

    return Hero(
      tag: 'timer-card-hero',
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () async {
            if (!vm.hasTarget) {
              await _openSettingSheet(context, vm);
              return;
            }
            onTap?.call(); // 확장 화면 이동
          },
          child: Card(
            elevation: 1,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  Text(
                    timeText,
                    style: const TextStyle(fontSize: 60, fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 16),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Left button (설정/Start/Stop)
                      if (!vm.hasTarget) ...[
                        FilledButton(
                          onPressed: () => _openSettingSheet(context, vm),
                          style: FilledButton.styleFrom(
                            backgroundColor: const Color(0xFF452829),
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 18,
                              vertical: 12,
                            ),
                          ),
                          child: Text(
                            "설정",
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                              fontSize: 16,
                            ),
                          ),
                        ),
                      ] else if (!vm.isRunning) ...[
                        FilledButton(
                          onPressed: vm.remaining == Duration.zero ? null : vm.start,
                          child: const Text("Start"),
                        ),
                      ] else ...[
                        FilledButton(onPressed: vm.stop, child: const Text("Stop")),
                      ],

                      const SizedBox(width: 12),

                      // Reset: 0일 때 숨김 / 설정중에도 사실상 숨김
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
                          child: const Text("Reset"),
                        ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
