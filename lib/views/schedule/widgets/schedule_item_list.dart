import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../theme/app_colors.dart';
import '../../../view_models/schedule_vm.dart';
import 'schedule_item_card.dart';

class ScheduleItemList extends StatelessWidget {
  const ScheduleItemList({super.key});

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<ScheduleVM>();
    final items = vm.itemsOf(vm.selectedDay);

    return Expanded(
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: AppColors.border, width: 0.8),
        ),
        padding: const EdgeInsets.all(12),
        child: items.isEmpty
            ? const Center(
          child: Text(
            '등록된 메모가 없어요.',
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: AppColors.mutedOn,
            ),
          ),
        )
            : ListView.separated(
          itemCount: items.length,
          separatorBuilder: (_, __) => const SizedBox(height: 8),
          itemBuilder: (context, index) {
            final item = items[index];
            return ScheduleItemCard(
              item: item,
              onTap: () {
                // 나중에 상세 이동 연결
              },
            );
          },
        ),
      ),
    );
  }
}
