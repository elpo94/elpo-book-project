import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';

// ✅ 1. 뷰모델 임포트 확인 (클래스명: ProjectViewModel)
import '../../view_models/project/project_vm.dart';
// ✅ 2. ProjectCard 임포트 추가
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
    // 화면이 켜질 때 데이터를 불러옵니다.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // 뷰모델 클래스명이 ProjectViewModel인지 다시 확인하세요.
      context.read<ProjectViewModel>().fetchProjects();
    });
  }

  @override
  Widget build(BuildContext context) {
    // 뷰모델 타입 명시: Consumer<ProjectViewModel>
    return Consumer<ProjectViewModel>(
      builder: (context, vm, child) {
        // 로딩 상태 처리
        if (vm.isLoading && vm.projects.isEmpty) {
          return const Center(child: Text('잠시만 기다려 주세요...'));
        }

        // 데이터 없음 처리
        if (vm.projects.isEmpty) {
          return const Center(child: Text('프로젝트가 없습니다.'));
        }

        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: vm.projects.length,
          itemBuilder: (context, index) {
            final project = vm.projects[index];

            // ⭐ ProjectCard는 이제 project 모델 하나만 받으면 됩니다.
            // 기존의 title, description, period 등을 일일이 넘길 필요가 없습니다.
            return ProjectCard(
              project: project,
              onTap: () => context.push('/project/${project.id}'),
            );
          },
        );
      },
    );
  }
}