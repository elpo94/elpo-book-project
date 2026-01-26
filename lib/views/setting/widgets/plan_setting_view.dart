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
      required bool isSystemSetting, // [추가] 필수 매개변수
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
      builder: (sheetContext) { // [수정] 언더바(_) 대신 sheetContext로 명시
        return TimerSettingSheet(
          onConfirm: (duration) async {
            // 1. 시트를 즉시 닫아 내비게이션 락 방지
            Navigator.pop(sheetContext);

            // 2. 뷰모델 상태 업데이트 (현재 세션 반영)
            vm.setTarget(duration);

            // 3. 진입 경로에 따른 물리 저장소 분리 (SettingService)
            if (isSystemSetting) {
              // 설정 페이지 진입 시: 앱 전체 기본 목표값 변경
              await SettingService().saveSystemDefault(duration.inSeconds);
            } else {
              // 홈 화면 진입 시: 이번 세션에만 사용할 임시 시간 저장
              await SettingService().saveCurrentSession(duration.inSeconds);
            }

            // 4. 사용자 피드백 안내
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
            // 시트 컨텍스트를 사용하여 닫기
            if (ok && context.mounted) Navigator.pop(sheetContext);
          },
        );
      },
    );
  } finally {
    // 시트가 닫히면 항상 편집 상태 종료
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