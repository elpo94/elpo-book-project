import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import '../../view_models/project/project_vm.dart';
import 'widgets/project_card.dart';

class ProjectView extends StatefulWidget {
  const ProjectView({super.key});

  @override
  State<ProjectView> createState() => _ProjectViewState();
}

class _ProjectViewState extends State<ProjectView> {

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
              onDelete: () => vm.requestDeleteProject(
                context,
                project.id,
              ),
              onTap: () => context.push('/project/${project.id}'),
            );
          },
        );
      },
    );
  }
}