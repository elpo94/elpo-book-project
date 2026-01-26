import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../view_models/home/timer_vm.dart';
import 'setting_card.dart';
import 'setting_section_title.dart';
import 'setting_tile.dart';
import 'package:sabujak_application/views/home/widgets/timer/show_timer_setting_sheet.dart';
class PlanSettingCard extends StatelessWidget {
  const PlanSettingCard({super.key});

  @override
  Widget build(BuildContext context) {
    final timerVM = context.watch<TimerViewModel>();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SettingSectionTitle('목표 설정'),
        const SizedBox(height: 8),
        SettingCard(
          children: [
            SettingTile(
              icon: Icons.tune_rounded,
              title: '기본 목표 설정',
              subtitle: '현재 설정: ${timerVM.formattedSystemDefault}',
              onTap: () async {
                await showTimerSettingSheet(context, timerVM, isSystemSetting: true);
                timerVM.setupDuration();
              },
            ),
          ],
        ),
      ],
    );
  }
}