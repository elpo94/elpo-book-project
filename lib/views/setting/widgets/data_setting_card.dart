import 'package:flutter/material.dart';
import '../../../theme/app_colors.dart';
import 'setting_card.dart';
import 'setting_section_title.dart';
import 'setting_tile.dart';

class DataSettingCard extends StatelessWidget {
  const DataSettingCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SettingSectionTitle('데이터'),
        const SizedBox(height: 8),
        SettingCard(
          children: [
            SettingTile(
              icon: Icons.delete_outline_rounded,
              iconColor: AppColors.error,
              title: '데이터 초기화',
              subtitle: '모든 데이터를 삭제',
              titleColor: AppColors.error,
              onTap: () {
                // TODO: 삭제 확인 다이얼로그 나중에 연결
              },
            ),
          ],
        ),
      ],
    );
  }
}
