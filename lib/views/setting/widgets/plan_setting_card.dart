import 'package:flutter/material.dart';
import 'package:sabujak_application/views/setting/widgets/plan_setting_view.dart';
import 'setting_card.dart';
import 'setting_section_title.dart';
import 'setting_tile.dart';

class PlanSettingCard extends StatelessWidget {
  const PlanSettingCard({super.key});

  @override
  Widget build(BuildContext context) {
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
              subtitle: '하루 목표 글쓰기 시간',
              onTap: () {
                SettingTile(
                  icon: Icons.tune_rounded,
                  title: '기본 목표 설정',
                  subtitle: '하루 목표 글쓰기 시간',
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const PlanSettingView(),
                      ),
                    );
                  },
                );
              },
            ),
          ],
        ),
      ],
    );
  }
}
