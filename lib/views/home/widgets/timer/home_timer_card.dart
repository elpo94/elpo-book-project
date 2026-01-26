import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sabujak_application/theme/app_colors.dart';
import 'package:sabujak_application/views/home/widgets/timer/show_timer_setting_sheet.dart';
import 'package:sabujak_application/views/home/widgets/timer/timer_controls.dart';
import '../../../../view_models/home/timer_vm.dart';
import '../../../../widgets/confirm_dialog.dart';

class HomeTimerCard extends StatelessWidget {
  final VoidCallback? onTap;

  const HomeTimerCard({super.key, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<TimerViewModel>();

    // 1. 0초일 때를 판별합니다.
    final bool isZero = vm.remaining == Duration.zero;
    final bool canExpand = vm.hasTarget && !isZero && !vm.isEditing;

    return HeroMode(
      enabled: canExpand,
      child: Hero(
        tag: 'timer-card-hero',
        child: Card(
          color: AppColors.surface,
          elevation: 1,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          child: InkWell(
            borderRadius: BorderRadius.circular(16),
            onTap: () async {
              if (vm.isEditing) return;
              if (!vm.hasTarget || isZero) {
                // 0초일 때 클릭 시 설정 시트 호출
                await showTimerSettingSheet(context, vm, isSystemSetting: false);
                return;
              }
              onTap?.call();
            },
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    vm.formattedRemainingTime,
                    style: TextStyle(
                      fontSize: 60,
                      fontWeight: FontWeight.w600,
                      fontFamily: 'Pretendard',
                      color: AppColors.foreground,
                    ),
                  ),

                    const SizedBox(height: 16),
                    TimerControls(
                      onReset: () async {
                        final ok = await showConfirmDialog(
                          context,
                          title: '타이머를 초기화할까요?',
                          message: '누적된 시간이 00:00:00으로 돌아갑니다.',
                          cancelText: '취소',
                          //confirmText: '초기화',
                        );
                        if (ok) vm.reset();
                      },
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