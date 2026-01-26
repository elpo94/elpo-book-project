import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../view_models/home/timer_vm.dart';
import '../../../../widgets/app_button_style.dart';
import '../../../../widgets/button_style.dart';
import 'show_timer_setting_sheet.dart';

class TimerPrimaryButton extends StatelessWidget {
  final bool compact;

  const TimerPrimaryButton({super.key, this.compact = false});

  EdgeInsets _pad() => compact
      ? const EdgeInsets.symmetric(horizontal: 18, vertical: 12)
      : const EdgeInsets.symmetric(horizontal: 22, vertical: 14);

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<TimerViewModel>();

    // [논리 보강] 목표가 없거나, 시간이 0초일 때는 '설정' 버튼을 노출합니다.
    // 리셋 후 00:00:00 상태에서 'Start'가 비활성으로 남는 것을 방지합니다.
    if (!vm.hasTarget || vm.remaining <= Duration.zero) {
      return AppActionButton(
        label: '설정',
        padding: _pad(),
        style: AppButtonStyle.primary,
        // 홈 화면에서 호출하므로 시스템 설정(디폴트값)을 건드리지 않도록 false 전달
        onPressed: () => showTimerSettingSheet(context, vm, isSystemSetting: false),
      );
    }

    // 타이머가 멈춰있는 경우 (Start 노출)
    if (!vm.isRunning) {
      return AppActionButton(
        label: 'Start',
        padding: _pad(),
        style: AppButtonStyle.primary,
        // 이미 위에서 0초 체크를 했으므로 여기서는 안전하게 start를 연결합니다.
        onPressed: vm.start,
      );
    }

    // 타이머가 돌아가는 경우 (Stop 노출)
    return AppActionButton(
      label: 'Stop',
      padding: _pad(),
      style: AppButtonStyle.primary,
      onPressed: vm.stop,
    );
  }
}