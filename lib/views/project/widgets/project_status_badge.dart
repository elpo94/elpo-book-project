import 'package:flutter/material.dart';
import 'project_status.dart';

class ProjectStatusBadge extends StatelessWidget {
  final ProjectStatus status;
  final DateTime? deadline;

  const ProjectStatusBadge({
    super.key,
    required this.status,
    this.deadline,
  });

  @override
  Widget build(BuildContext context) {
    final display = effectiveStatus(
      status: status,
      deadline: deadline,
    );

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: display.backgroundColor, // AppColors tint 사용
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        display.label,
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w600,
          color: display.color,
        ),
      ),
    );
  }
}
