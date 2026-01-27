import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../services/timer_setting_service.dart';
import '../../../theme/app_colors.dart';
import '../../../view_models/home/timer_vm.dart';
import '../../../widgets/confirm_dialog.dart';
import '../../home/widgets/timer/timer_setting_sheet.dart';

/// 헬퍼 함수: 타이머 설정 바텀시트를 노출하고 데이터 분리 저장 로직을 수행합니다.
Future<void> showTimerSettingSheet(
    BuildContext context,
    TimerViewModel vm, {
      required bool isSystemSetting,
    }) async {
  vm.beginEdit();

  try {
    await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.background,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
      ),
      builder: (sheetContext) {
        return TimerSettingSheet(
          // ⭐ [수정 핵심] 시트가 열릴 때 보여줄 초기 시간을 주입합니다.
          // 설정 페이지라면 시스템 기본값을, 홈 화면이라면 현재 세션의 타겟 시간을 보여줍니다.
          initialDuration: isSystemSetting ? vm.systemDefaultDuration : vm.targetDuration,

          onConfirm: (duration) async {
            Navigator.pop(sheetContext);

            vm.setTarget(duration);

            if (isSystemSetting) {
              await SettingService().saveSystemDefault(duration.inSeconds);
              // 설정 변경 후 뷰모델의 시스템 기본값 상태도 업데이트해줍니다.
              vm.updateSystemDefault(duration);
            } else {
              await SettingService().saveCurrentSession(duration.inSeconds);
            }

            if (context.mounted) {
              ScaffoldMessenger.of(context).hideCurrentSnackBar();
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(isSystemSetting
                      ? '기본 설정이 저장되었습니다.'
                      : '타이머가 ${vm.formattedTargetDuration}로 설정되었습니다.'),
                  duration: const Duration(seconds: 2),
                  behavior: SnackBarBehavior.floating,
                ),
              );
            }
          },
          onCancel: () async {
            final ok = await showConfirmDialog(
              context,
              title: '취소하시겠습니까?',
              message: '설정한 내용은 저장되지 않습니다.',
              cancelText: '계속 설정',
              confirmText: '취소',
            );
            if (ok && context.mounted) Navigator.pop(sheetContext);
          },
        );
      },
    );
  } finally {
    vm.endEdit();
  }
}

/// 설정 페이지에 표시될 타이머 플랜 설정 카드 위젯
class PlanSettingCard extends StatelessWidget {
  const PlanSettingCard({super.key});

  @override
  Widget build(BuildContext context) {
    // 뷰모델 구독
    final timerVM = context.watch<TimerViewModel>();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // 제목 섹션 (프로젝트 내부 위젯 사용 가정)
        const Text('목표 설정', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        Card(
          elevation: 0,
          color: AppColors.surface, // 테마 컬러 적용
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          child: ListTile(
            leading: const Icon(Icons.tune_rounded),
            title: const Text('기본 목표 설정'),
            subtitle: Text('현재 목표: ${timerVM.formattedTargetDuration}'),
            trailing: const Icon(Icons.chevron_right_rounded),
            onTap: () {
              // [중요] 설정 페이지이므로 isSystemSetting을 true로 전달
              showTimerSettingSheet(context, timerVM, isSystemSetting: true);
            },
          ),
        ),
      ],
    );
  }
}