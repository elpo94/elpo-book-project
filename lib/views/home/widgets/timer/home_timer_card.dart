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
    final bool isZero = vm.remaining == Duration.zero;

    // [중요] 뿌연 현상 해결을 위해 Hero를 잠시 제거하고 Material로 감쌉니다.
    return Material(
      color: Colors.transparent,
      child: Card(
        elevation: 1,
        color: AppColors.background,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: () async {
            if (vm.isEditing) return;

            if (!vm.hasTarget || isZero) {
              // [메서드명 확인] showTimerSettingSheet 호출 (isSystemSetting: false)
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
                    // 0초일 때 흐릿하게 보이게 하려면 투명도를 조절합니다.
                    color: isZero ? AppColors.foreground.withOpacity(0.3) : AppColors.foreground,
                  ),
                ),
                // 0초가 아닐 때만 컨트롤러 노출, 0초면 숨김
                if (!isZero) ...[
                  const SizedBox(height: 16),
                  TimerControls(
                    onReset: () async {
                      final ok = await showConfirmDialog(
                        context,
                        title: '타이머를 초기화할까요?',
                        message: '누적된 시간이 00:00:00으로 돌아갑니다.',
                        cancelText: '취소',
                        confirmText: '초기화',
                      );
                      if (ok) vm.reset();
                    },
                  ),
                ] else
                  const SizedBox(height: 64),
              ],
            ),
          ),
        ),
      ),
    );
  }
}