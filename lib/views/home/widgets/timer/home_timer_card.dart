import 'package:elpo_book_project/view_models/home/timer_vm.dart';
import 'package:elpo_book_project/views/home/widgets/timer/show_timer_setting_sheet.dart';
import 'package:elpo_book_project/views/home/widgets/timer/timer_controls.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:elpo_book_project/widgets/button_style.dart';

import '../../../../widgets/confirm_dialog.dart';

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

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<TimerViewModel>();

    final display = vm.isRunning
        ? vm.remaining
        : (vm.hasTarget ? vm.remaining : Duration.zero);
    final canExpand = vm.hasTarget && !vm.isEditing;

    return HeroMode(
      enabled: canExpand, // 편집중에 히어로 비활성.
      child: Hero(
        tag: 'timer-card-hero',
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: () async {
              if (vm.isEditing) return;

              if (!vm.hasTarget) {
                await showTimerSettingSheet(context, vm);
                return;
              }

              onTap?.call();
            },
            child: Card(
              elevation: 1,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    Text(
                      _format(display),
                      style: const TextStyle(
                        fontSize: 60,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 16),

                    // ✅ 공통 컨트롤
                    TimerControls(
                      onReset: () async {
                        final ok = await showConfirmDialog(
                          context,
                          title: '타이머를 초기화할까요?',
                          message: '누적된 시간이 00:00:00으로 돌아갑니다.',
                          cancelText: '취소',
                          confirmText: '초기화',
                        );

                        if (ok) {
                          context.read<TimerViewModel>().reset();
                        }
                      },
                    ),

                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
