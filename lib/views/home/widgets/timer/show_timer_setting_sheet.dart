import 'package:flutter/material.dart';
import 'package:sabujak_application/views/home/widgets/timer/timer_setting_sheet.dart';
import '../../../../services/timer_setting_service.dart';
import '../../../../theme/app_colors.dart';
import '../../../../view_models/home/timer_vm.dart';
import '../../../../widgets/confirm_dialog.dart';

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
          onConfirm: (duration) async {
            Navigator.pop(sheetContext);

            vm.setTarget(duration);

            if (isSystemSetting) {
              await SettingService().saveSystemDefault(duration.inSeconds);
            } else {
              await SettingService().saveCurrentSession(duration.inSeconds);
            }

            if (context.mounted) {
              ScaffoldMessenger.of(context).hideCurrentSnackBar();
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(isSystemSetting
                      ? '기본 목표 시간이 변경되었습니다.'
                      : '타이머 시간이 설정되었습니다.'),
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