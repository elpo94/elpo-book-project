// lib/views/setting/widgets/data_setting_card.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import 'package:sabujak_application/theme/app_colors.dart';
import 'package:sabujak_application/services/auth_service.dart';
import 'package:sabujak_application/services/project_store.dart';
import '../../../widgets/confirm_dialog.dart';
import 'setting_card.dart';
import 'setting_section_title.dart';
import 'setting_tile.dart';
import 'package:sabujak_application/widgets/info_dialog.dart';

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
            SettingTile(
              icon: Icons.delete_forever_rounded,
              title: '데이터 초기화',
              subtitle: '모든 데이터를 삭제',
              titleColor: Colors.red,
              onTap: () async {
                // 1️⃣ [Confirm] 정말 삭제할지 묻기
                final bool ok = await showConfirmDialog(
                  context,
                  title: '데이터 초기화',
                  message: '정말 모든 프로젝트와 설정 기록을 삭제할까요?\n이 작업은 되돌릴 수 없으며 앱이 초기화됩니다.',
                  confirmText: '전체 삭제',
                  confirmColor: const Color(0xFFD65C5C), // 삭제의 위험성을 알리는 레드톤
                );

                if (ok && context.mounted) {
                  try {
                    final uid = context.read<AuthService>().currentUserId;
                    final store = context.read<ProjectStore>();

                    if (uid != null) {
                      // 실제 데이터 삭제 수행 (Service + Store + SharedPrefs)
                      await store.clearAll(uid);

                      if (context.mounted) {
                        // 2️⃣ [Info] 삭제가 완료되었음을 알림
                        await showInfoDialog(
                          context,
                          title: '초기화 완료',
                          message: '모든 데이터가 사부작히 삭제되었습니다.\n새로운 마음으로 시작해 보세요!',
                          confirmText: '확인',
                        );

                        // 3️⃣ [Redirect] 다이얼로그가 닫히면 홈으로 이동
                        if (context.mounted) {
                          context.go('/home');
                        }
                      }
                    }
                  } catch (e) {
                    debugPrint("초기화 실패: $e");
                  }
                }
              },
            ),
          ],
        ),
      ],
    );
  }
}