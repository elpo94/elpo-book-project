import 'package:flutter/material.dart';
import '../../../theme/app_colors.dart';
import '../../project/widgets/project_status.dart';

class ScheduleLegend extends StatelessWidget {
  const ScheduleLegend({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12), // 캘린더와 리스트 사이 적절한 간격
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: ProjectDisplayStatus.values.map((status) {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 7,
                  height: 7,
                  decoration: BoxDecoration(
                    color: status.color,
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: 4),
                Text(
                  status.label,
                  style: const TextStyle(
                    fontSize: 12,
                    color: AppColors.mutedOn,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }
}