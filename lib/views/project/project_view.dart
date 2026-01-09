import 'package:elpo_book_project/views/project/widgets/project_card.dart';
import 'package:elpo_book_project/views/project/widgets/project_status.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class ProjectView extends StatelessWidget {
  const ProjectView({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        ProjectCard(
          title: '소설 1부',
          description: '판타지 소설 집필',
          period: '2025.01.12 ~ 2025.03.04',
          routine: '주 5회 · 하루 3시간',
          status: ProjectStatus.ongoing,
          onTap: () {
            context.push('/project/1'); // 더미 id
          },
        ),
      ],
    );
  }
}
