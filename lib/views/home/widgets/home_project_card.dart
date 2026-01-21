// home_project_card.dart
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../models/project.dart';

class HomeProjectCard extends StatelessWidget {
  final ProjectModel project;

  const HomeProjectCard({super.key, required this.project});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => context.push('/project-detail/${project.id}'),
      child: Container(
        width: 160,
        margin: const EdgeInsets.only(right: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: const Color(0xFFF3EDE2),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(project.name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15), maxLines: 1),
            const SizedBox(height: 6),
            Text(project.description, style: const TextStyle(fontSize: 12, color: Color(0xFF8D7A65)), maxLines: 2),
          ],
        ),
      ),
    );
  }
}