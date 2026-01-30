import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
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
  }

  Future<void> _handleResetProcess(BuildContext context) async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult.contains(ConnectivityResult.none)) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("현재 오프라인 상태입니다. 온라인 환경에서 다시 시도해 주세요."),
            backgroundColor: Color(0xFFD65C5C),
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
      return;
    }

    final bool confirm = await showConfirmDialog(
      context,
      title: "데이터 초기화",
      message: "모든 데이터가 영구적으로 삭제됩니다.\n정말로 초기화를 진행하시겠습니까?",
      confirmText: "초기화",
      confirmColor: const Color(0xFFD65C5C),
    );

    if (!confirm) return;

    if (context.mounted) {
      final uid = context
          .read<AuthService>()
          .currentUserId;
      if (uid == null) return;

      try {
        await context.read<ProjectStore>().clearAll(uid);

        if (context.mounted) {
          context.read<HomeViewModel>().resetToDefault();
          await context.read<TimerViewModel>().resetToSystemDefault();

          if (context.mounted) {
            await showInfoDialog(
              context,
              title: "초기화 완료",
              message: "모든 데이터가 깔끔하게 정리되었습니다.",
            );

            if (context.mounted) {
              context.go('/home');
            }
          }
        }
      } catch (e) {
        debugPrint("초기화 중 오류 발생: $e");
      }
    }
  }
}