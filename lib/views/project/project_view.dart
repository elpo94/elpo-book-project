import 'package:elpo_book_project/views/project/widgets/project_card.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class ProjectView extends StatelessWidget {
  const ProjectView({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: const [
        ProjectCard(),
        SizedBox(height: 12),
        ProjectCard(),
        SizedBox(height: 12),
        ProjectCard(),
      ],
    );
  }
}
