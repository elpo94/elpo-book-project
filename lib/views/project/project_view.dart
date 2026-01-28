import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';

import '../../models/project.dart';
import '../../view_models/project/project_vm.dart';
import '../../widgets/confirm_dialog.dart';
import 'widgets/project_card.dart';

class ProjectView extends StatefulWidget {
  const ProjectView({super.key});

  @override
  State<ProjectView> createState() => _ProjectViewState();
}

class _ProjectViewState extends State<ProjectView> {

  Future<void> _onDeleteProject(BuildContext context, ProjectModel project) async {
    final bool confirmed = await showConfirmDialog(
      context,
      title: '프로젝트 삭제',
      message: '이 프로젝트와 관련된 모든 기록이 삭제됩니다.\n정말 삭제하시겠습니까?',
      confirmText: '삭제',
      confirmColor: const Color(0xFFD65C5C),
    );

    if (confirmed && context.mounted) {
      await context.read<ProjectViewModel>().deleteProject(project.id);
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('프로젝트가 삭제되었습니다.')),
        );
      }
    }
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ProjectViewModel>().fetchProjects();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ProjectViewModel>(
      builder: (context, vm, child) {
        if (vm.isLoading && vm.projects.isEmpty) {
          return const Center(child: Text('잠시만 기다려 주세요...'));
        }

        if (vm.projects.isEmpty) {
          return const Center(child: Text('프로젝트가 없습니다.'));
        }

        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: vm.projects.length,
          itemBuilder: (context, index) {
            final project = vm.projects[index];

            return ProjectCard(
              project: project,
              onTap: () => context.push('/project/${project.id}'),
              onDelete: () => _onDeleteProject(context, project),
            );
          },
        );
      },
    );
  }
}