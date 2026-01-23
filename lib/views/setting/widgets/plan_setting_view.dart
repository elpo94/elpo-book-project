import 'package:flutter/material.dart';
import '../../../services/timer_setting_service.dart'; // SettingService가 정의된 곳
import '../../../theme/app_colors.dart';
import '../../../view_models/home/timer_vm.dart';
import '../../../widgets/confirm_dialog.dart';
import '../../home/widgets/timer/timer_setting_sheet.dart';

Future<void> showTimerSettingSheet(
    BuildContext context,
    TimerViewModel vm,
    ) async {
  vm.beginEdit();

  try {
    await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.background,
      // 상단 라운드 처리를 위한 모양 설정
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
      ),
      builder: (_) {
        return TimerSettingSheet(
          onConfirm: (duration) async {
            // 1. 타이머 VM에 값 전달
            vm.setTarget(duration);

            // 2. 로컬(SharedPreferences)에 기본값으로 저장
            await SettingService().saveDefaultTargetTime(duration.inMinutes);

            if (context.mounted) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('기본 목표가 ${duration.inMinutes}분으로 변경되었습니다.')),
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
            // 취소 컨펌 시 시트 닫기
            if (ok && context.mounted) Navigator.pop(context);
          },
        );
      },
    );
  } finally {
    vm.endEdit();
  }
}