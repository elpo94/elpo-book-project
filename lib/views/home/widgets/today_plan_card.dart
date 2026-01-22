import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../theme/app_colors.dart';
import '../../../../view_models/home/home_vm.dart';
import 'today_plan_edit_sheet.dart'; // ✅ 분리된 시트 임포트

class TodayPlanCard extends StatelessWidget {
  const TodayPlanCard({super.key});

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<HomeViewModel>();

    return Card(
      elevation: 0,
      color: AppColors.surface, // ✅ 테마의 surface 색상 적용
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(24),
        side: const BorderSide(color: AppColors.border, width: 0.8), // ✅ 미세한 테두리
      ),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    vm.todayPlan,
                    style: const TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.bold,
                      color: AppColors.foreground,
                    ),
                  ),
                ),
                _buildTimeBadge("${vm.targetTime}분"),
                const SizedBox(width: 8),
                IconButton(
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                  onPressed: () => showTodayPlanEditSheet(context, vm), // ✅ 분리된 함수 호출
                  icon: const Icon(Icons.edit, size: 20, color: Colors.black54),
                ),
              ],
            ),
            if (vm.planMemo.isNotEmpty) ...[
              const SizedBox(height: 12),
              Text(
                vm.planMemo,
                style: const TextStyle(
                  fontSize: 14,
                  color: AppColors.mutedOn,
                  height: 1.5,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildTimeBadge(String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: AppColors.buttonPrimaryBg,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        label,
        style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold),
      ),
    );
  }
}