import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sabujak_application/theme/app_colors.dart';
import '../../../widgets/confirm_dialog.dart';
import '../../../view_models/home/home_vm.dart'; // 프로젝트 데이터를 관리하는 VM
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
        const SettingSectionTitle('데이터 관리'),
        const SizedBox(height: 8),
        SettingCard(
          children: [
            // lib/views/setting/widgets/data_setting_card.dart

            SettingTile(
              icon: Icons.delete_forever_rounded,
              title: '데이터 초기화',
              subtitle: '모든 데이터를 삭제', // 🔍 에러 해결: 필수 파라미터 추가
              titleColor: Colors.red,
              onTap: () async {
                final ok = await showConfirmDialog(
                  context,
                  title: '데이터 초기화',
                  message: '정말 모든 프로젝트와 설정 기록을 삭제할까요?\n이 작업은 되돌릴 수 없으며 앱이 초기화됩니다.',
                  confirmText: '전체 삭제',
                  confirmColor: const Color(0xFFD65C5C),
                );

                if (ok && context.mounted) {
                  // ✅ 서비스 호출 (실제 삭제 실행)
                  // final userId = context.read<UserViewModel>().userId;
                  // await ProjectService().clearAllUserData(userId);

                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('모든 데이터가 사부작히 삭제되었습니다.')),
                  );
                }
              },
            ),
          ],
        ),
      ],
    );
  }
}