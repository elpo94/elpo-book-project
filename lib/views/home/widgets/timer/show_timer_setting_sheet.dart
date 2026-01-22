import 'package:flutter/material.dart';
import '../../../../theme/app_colors.dart';
import '../../../../view_models/home/timer_vm.dart';
import '../../../../widgets/confirm_dialog.dart';
import 'timer_setting_sheet.dart';

Future<void> showTimerSettingSheet(
    BuildContext context,
    TimerViewModel vm,
    ) async {
  vm.beginEdit();

  try {
    await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      barrierColor: Colors.transparent,
      backgroundColor: AppColors.background,
      builder: (_) {
        return TimerSettingSheet(
          onConfirm: vm.setTarget,
          onCancel: () async {
            final ok = await showConfirmDialog(
              context,
              title: '취소하시겠습니까?',
              message: '설정한 내용은 저장되지 않습니다.',
              cancelText: '계속 설정',
              confirmText: '취소',
            );
            if (ok && context.mounted) Navigator.pop(context);
          },
        );
      },
    );
  } finally {
    vm.endEdit();
  }
}
