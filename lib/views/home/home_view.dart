
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:sabujak_application/views/home/widgets/home_project_card.dart';
import 'package:sabujak_application/views/home/widgets/home_selection.dart';
import 'package:sabujak_application/views/home/widgets/timer/home_timer_card.dart';
import 'package:sabujak_application/views/home/widgets/today_plan_card.dart';

import '../../view_models/project/project_vm.dart';

// home_view.dart
class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    final projects = context.watch<ProjectViewModel>().projects;

    return ListView(
      padding: const EdgeInsets.all(12),
      children: [
        HomeSection(child: HomeTimerCard(onTap: () => context.push('/timer'))),
        const HomeSection(title: '오늘 목표', child: TodayPlanCard()),
        HomeSection(
          title: '프로젝트',
          child: projects.isEmpty
              ? const Center(child: Text("진행 중인 프로젝트가 없습니다."))
              : SizedBox(
            height: 140,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: projects.length,
              itemBuilder: (context, index) => HomeProjectCard(project: projects[index]),
            ),
          ),
        ),
      ],
    );
  }
}