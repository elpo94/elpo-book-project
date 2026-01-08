import 'package:elpo_book_project/views/project/widgets/project_card.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class ProjectView extends StatelessWidget {
  const ProjectView({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        ElevatedButton(
          onPressed: () {
            context.push('/project/1'); // 더미 id
          },
          child: const Text('프로젝트 디테일 보기 (더미)'),
        ),
        ProjectCard(),
        SizedBox(height: 12),
        ProjectCard(),
        SizedBox(height: 12),
        ProjectCard(),
      ],
    );
  }
}
