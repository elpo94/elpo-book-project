import 'package:flutter/material.dart';
import '../../../models/calendar_item.dart';
import '../../../theme/app_colors.dart';

class ScheduleItemCard extends StatelessWidget {
  final CalendarItem item;
  final VoidCallback? onTap;

  const ScheduleItemCard({
    super.key,
    required this.item,
    this.onTap,
  });

  Color _dotColor(ProjectStatus status) {
    return switch (status) {
      ProjectStatus.planned => AppColors.statusPlanned,
      ProjectStatus.inProgress => AppColors.statusOngoing,
      ProjectStatus.done => AppColors.statusDone,
      ProjectStatus.overdue => AppColors.statusOverdue,
    };
  }

  @override
  Widget build(BuildContext context) {
    final dot = _dotColor(item.status);

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap, // 상세 이동은 나중
        borderRadius: BorderRadius.circular(14),
        child: Container(
          decoration: BoxDecoration(
            color: AppColors.secondary,
            borderRadius: BorderRadius.circular(14),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
          child: Row(
            children: [
              Container(
                width: 8,
                height: 8,
                decoration: BoxDecoration(
                  color: dot,
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item.title,
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                        color: AppColors.foreground,
                      ),
                    ),
                    if (item.note != null && item.note!.isNotEmpty) ...[
                      const SizedBox(height: 4),
                      Text(
                        item.note!,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          color: AppColors.mutedOn,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              const Icon(Icons.chevron_right_rounded, size: 20),
            ],
          ),
        ),
      ),
    );
  }
}
