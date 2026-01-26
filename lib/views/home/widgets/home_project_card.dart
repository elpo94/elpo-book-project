// lib/views/home/widgets/home_project_card.dart
import 'package:flutter/material.dart';
import '../../../models/project.dart';
import '../../../theme/app_colors.dart';

class HomeProjectCard extends StatelessWidget {
  final ProjectModel project;
  final VoidCallback? onTap;

  const HomeProjectCard({super.key, required this.project, this.onTap});

  @override
  Widget build(BuildContext context) {
    // 진행률 계산 로직 (기존 유지)
    final totalDays = project.endDate.difference(project.startDate).inDays + 1;
    final elapsedDays = DateTime.now().difference(project.startDate).inDays + 1;
    final progress = (elapsedDays / totalDays).clamp(0.0, 1.0);

    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day); // 시간 제외 날짜만 계산
    final endDay = DateTime(project.endDate.year, project.endDate.month, project.endDate.day);

    final difference = endDay.difference(today).inDays;

    String dDayText;
    if (difference > 0) {
      dDayText = "D-$difference";
    } else if (difference == 0) {
      dDayText = "D-Day";
    } else {
      dDayText = "종료";
    }

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: AppColors.border.withOpacity(0.5),
            width: 0.8,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              project.name,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.foreground),
            ),
            const SizedBox(height: 4),
            Text(
              project.description,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(fontSize: 13, color: AppColors.mutedOn.withOpacity(0.8)),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "${_format(project.startDate)} - ${_format(project.endDate)}",
                  style: const TextStyle(fontSize: 11, color: AppColors.mutedOn),
                ),
                // ✅ [수정] % 대신 D-Day 텍스트 노출
                Text(
                  dDayText,
                  style: const TextStyle(
                      fontSize: 12, // D-Day는 조금 더 잘 보이게 살짝 키웠습니다.
                      fontWeight: FontWeight.bold,
                      color: AppColors.buttonPrimaryBg
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: LinearProgressIndicator(
                value: progress,
                backgroundColor: Colors.white.withOpacity(0.5),
                valueColor: const AlwaysStoppedAnimation<Color>(AppColors.buttonPrimaryBg),
                minHeight: 6,
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _format(DateTime d) => "${d.month}/${d.day}";
}