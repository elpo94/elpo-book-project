import 'package:flutter/material.dart';
import '../../../models/calendar_item.dart';
import '../../../theme/app_colors.dart';
import '../../project/widgets/project_status.dart';

class ScheduleItemCard extends StatelessWidget {
  final CalendarItem item;
  final VoidCallback? onTap;

  const ScheduleItemCard({super.key, required this.item, this.onTap});

  @override
  Widget build(BuildContext context) {
    final displayStatus = effectiveStatus(
      status: item.status,
      deadline: item.date,
    );

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: AppColors.border.withOpacity(0.5)),
          ),
          child: Row(
            children: [
              // 캘린더 점과 통일감을 주는 상태 마커
              Container(
                width: 4,
                height: 32,
                decoration: BoxDecoration(
                  color: displayStatus.color,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item.title,
                      style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: AppColors.foreground),
                    ),
                    const SizedBox(height: 4),
                    // 성주님이 원하신 일정(기간) 정보 추가
                    Text(
                      "${_formatDate(item.date)} 마감 예정",
                      style: const TextStyle(fontSize: 12, color: AppColors.mutedOn),
                    ),
                  ],
                ),
              ),
              // 우측 상태 배지
              _buildStatusBadge(displayStatus),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatusBadge(ProjectDisplayStatus status) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: status.backgroundColor,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        status.label,
        style: TextStyle(color: status.color, fontSize: 10, fontWeight: FontWeight.bold),
      ),
    );
  }

  String _formatDate(DateTime date) => "${date.year}.${date.month}.${date.day}";
}