import 'package:flutter/material.dart';
import '../../../theme/app_colors.dart';
import 'app_info_view.dart';
import 'setting_card.dart';
import 'setting_section_title.dart';
import 'setting_tile.dart';

class InfoSettingCard extends StatelessWidget {
  const InfoSettingCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SettingSectionTitle('정보'),
        const SizedBox(height: 8),
        SettingCard(
          children: [
            SettingTile(
              icon: Icons.info_outline_rounded,
              title: '앱 정보',
              subtitle: '버전 1.0.0',
              showChevron: true, // 상세 페이지가 있으니 쉐브론을 켜주는 게 직관적입니다.
              onTap: () {
                // ✅ 아까 만든 쉐브론/클로즈가 있는 페이지로 이동
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const AppInfoView()),
                );
              },
            ),
          ],
        ),
        const SizedBox(height: 22),
        Center(
          child: Text(
            'ⓒ 2026 사부작',
            style: TextStyle(
              fontSize: 12,
              color: AppColors.mutedOn,
            ),
          ),
        ),
      ],
    );
  }
}