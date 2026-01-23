import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sabujak_application/views/home/widgets/home_project_section.dart';
import 'package:sabujak_application/views/home/widgets/home_selection.dart';
import 'package:sabujak_application/views/home/widgets/timer/home_timer_card.dart';
import 'package:sabujak_application/views/home/widgets/today_plan_card.dart';

import '../../view_models/home/home_vm.dart';
import '../project/widgets/project_detail_view.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<HomeViewModel>();
    final projects = vm.ongoingProjects;

    return ListView(
      padding: const EdgeInsets.all(12),
      children: [
        HomeTimerCard(onTap: () {}),
        const SizedBox(height: 24),

        const HomeSection(title: '오늘 목표', child: TodayPlanCard()),
        const SizedBox(height: 24),

        HomeProjectSection(
          projects: projects,
          onProjectTap: (project) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ProjectDetailView(projectId: project.id),
              ),
            );
          },
        ),
      ],
    );
  }
}
