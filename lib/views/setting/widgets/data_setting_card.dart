// lib/views/setting/widgets/data_setting_card.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sabujak_application/views/setting/widgets/setting_card.dart';
import 'package:sabujak_application/views/setting/widgets/setting_section_title.dart';
import 'package:sabujak_application/views/setting/widgets/setting_tile.dart';
import '../../../services/auth_service.dart';
import '../../../services/project_store.dart';
import '../../../view_models/home/home_vm.dart';
import '../../../view_models/home/timer_vm.dart';
import '../../../widgets/confirm_dialog.dart';
import '../../../widgets/info_dialog.dart';


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
              icon: Icons.delete_sweep_outlined,
              iconColor: Colors.red,
              title: '데이터 초기화',
              titleColor: Colors.red,
              subtitle: "모든 데이터를 삭제합니다",
              onTap: () => _handleResetProcess(context),
            ),
          ],
        ),
      ],
    );
    // return Container(
    //   margin: const EdgeInsets.only(bottom: 16),
    //   decoration: BoxDecoration(
    //     color: const Color(0xFFF3EDE2),
    //     borderRadius: BorderRadius.circular(20),
    //   ),
    //   child: ListTile(
    //     contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
    //     leading: const Icon(Icons.delete_sweep_outlined, color: Color(0xFFD65C5C)),
    //     title: const Text(
    //       "데이터 초기화",
    //       style: TextStyle(color: Color(0xFFD65C5C), fontWeight: FontWeight.bold),
    //     ),
    //     subtitle: const Text("모든 데이터를 사부작히 삭제합니다"),
    //     trailing: const Icon(Icons.arrow_forward_ios, size: 16),
    //     onTap: () => _handleResetProcess(context),
    //   ),
    // );
  }

  // ✅ 통합 초기화 프로세스
  Future<void> _handleResetProcess(BuildContext context) async {
    // 1️⃣ 커스텀 확인 다이얼로그 호출
    final bool confirm = await showConfirmDialog(
      context,
      title: "데이터 초기화",
      message: "저장된 데이터가 영구적으로 삭제됩니다.\n정말로 초기화를 진행하시겠습니까?",
      confirmText: "초기화",
      confirmColor: const Color(0xFFD65C5C),
    );

    if (!confirm) return;

    // 2️⃣ 로딩 및 초기화 로직 실행
    if (context.mounted) {
      final uid = context.read<AuthService>().currentUserId;
      if (uid == null) return;

      try {
        await context.read<ProjectStore>().clearAll(uid);

        if (context.mounted) {
          context.read<HomeViewModel>().resetToDefault();

          await context.read<TimerViewModel>().resetToSystemDefault();

          // 3️⃣ 완료 정보 다이얼로그 호출
          if (context.mounted) {
            await showInfoDialog(
              context,
              title: "초기화 완료",
              message: "모든 데이터가 깔끔하게 정리되었습니다.",
            );
          }
        }
      } catch (e) {
        debugPrint("초기화 중 오류 발생: $e");
      }
    }
  }
}