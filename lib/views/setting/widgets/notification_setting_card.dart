import 'package:flutter/material.dart';
import '../../../theme/app_colors.dart';
import '../../../widgets/info_dialog.dart';
import 'setting_card.dart';
import 'setting_section_title.dart';
import 'setting_tile.dart';

class NotificationSettingCard extends StatelessWidget {
  const NotificationSettingCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SettingSectionTitle('알림'),
        const SizedBox(height: 8),
        SettingCard(
          children: [
            SettingTile(
              icon: Icons.notifications_none_rounded,
              title: '알림 설정',
              subtitle: '글쓰기 알림 시간 관리',
              onTap: () =>
                  showInfoDialog(
                    context,
                    title: '알림 설정',
                    message: '준비중입니다.\n추후 업데이트 예정이에요.',
                  ),
            ),

          ],
        ),
      ],
    );
  }
}
