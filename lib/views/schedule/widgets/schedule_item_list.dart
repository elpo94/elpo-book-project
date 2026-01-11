import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../view_models/schedule_vm.dart';
import 'schedule_item_card.dart';

class ScheduleItemList extends StatelessWidget {
  const ScheduleItemList({super.key});

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<ScheduleVM>();
    final items = vm.itemsOf(vm.selectedDay);

    if (items.isEmpty) {
      return const _EmptyState();
    }

    return Column(
      children: [
        for (final item in items) ...[
          ScheduleItemCard(item: item),
          const SizedBox(height: 10),
        ],
      ],
    );
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Text(
        '선택한 날짜에 등록된 일정이 없어요',
        style: Theme.of(context).textTheme.bodySmall,
      ),
    );
  }
}
