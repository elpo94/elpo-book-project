import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../view_models/schedule/schedule_vm.dart';
import 'schedule_item_card.dart';

class ScheduleItemList extends StatelessWidget {
  // ✅ 1. 외부(ScheduleView)에서 클릭 시 동작을 정의할 수 있게 인자를 추가합니다.
  final Function(String projectId) onCardTap;

  const ScheduleItemList({
    super.key,
    required this.onCardTap, // 필수 인자로 설정
  });

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
