import 'package:flutter/material.dart';
import 'project_status.dart';

class ProjectStatusBadge extends StatelessWidget {
  final ProjectDisplayStatus displayStatus;

  const ProjectStatusBadge({super.key, required this.displayStatus});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: displayStatus.backgroundColor, // Extension의 붉은 배경색
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        displayStatus.label, // '지연' 출력
        style: TextStyle(
          color: displayStatus.color, // Extension의 붉은 텍스트색
          fontSize: 12,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}