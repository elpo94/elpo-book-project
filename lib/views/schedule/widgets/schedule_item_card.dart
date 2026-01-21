import 'package:flutter/material.dart';
import '../../../models/calendar_item.dart';
import '../../../theme/app_colors.dart';
import '../../project/widgets/project_status.dart';

class ScheduleItemCard extends StatelessWidget {
  final CalendarItem item;
  final VoidCallback? onTap;

  const ScheduleItemCard({
    super.key,
    required this.item,
    this.onTap,
  });


  @override
  Widget build(BuildContext context) {
    final displayStatus = effectiveStatus(
      status: item.status, // 저장된 상태 (planned, ongoing, done)
      deadline: item.date, // 캘린더 아이템의 날짜를 마감일로 판단
    );
    final dot = displayStatus.color;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap, // 상세 이동은 나중
        borderRadius: BorderRadius.circular(14),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(14),
          ),
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
