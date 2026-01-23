import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sabujak_application/views/setting/widgets/plan_setting_view.dart';
import '../../../view_models/home/timer_vm.dart';
import 'setting_card.dart';
import 'setting_section_title.dart';
import 'setting_tile.dart';

class PlanSettingCard extends StatelessWidget {
  const PlanSettingCard({super.key});

  @override
  Widget build(BuildContext context) {
    // 설정을 위해 TimerViewModel을 가져옵니다.
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
              subtitle: '목표 시간',
              onTap: () {
                // ✅ 페이지 이동 대신 바텀 시트를 바로 띄웁니다.
                showTimerSettingSheet(context, timerVM);
              },
            ),
          ],
        ),
      ],
    );
  }
}