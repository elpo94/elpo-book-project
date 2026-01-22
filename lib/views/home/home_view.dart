
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:sabujak_application/views/home/widgets/home_project_card.dart';
import 'package:sabujak_application/views/home/widgets/home_selection.dart';
import 'package:sabujak_application/views/home/widgets/timer/home_timer_card.dart';
import 'package:sabujak_application/views/home/widgets/today_plan_card.dart';

import '../../view_models/home/home_vm.dart';
class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {

    final vm = context.watch<HomeViewModel>();
    final projects = vm.ongoingProjects;

    return ListView(
      padding: const EdgeInsets.all(12),
      children: [
        HomeSection(child: HomeTimerCard(onTap: () => context.push('/timer'))),
        const HomeSection(title: '오늘 목표', child: TodayPlanCard()),


        HomeSection(
          title: '프로젝트',
          child: projects.isEmpty
              ? Container(
            height: MediaQuery.of(context).size.height * 0.15,
            alignment: Alignment.center,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "진행 중인 프로젝트가 없습니다.",
                  style: TextStyle(
                    fontSize: 15,
                    color: Colors.black.withOpacity(0.5),
                  ),
                ),
                const SizedBox(height: 6),
                const Text(
                  "아름답지 않나요? ✨", // 슬랙
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFFB58A53),
                  ),
                ),
              ],
            ),
          )
              : Column(
            children: projects.map((project) => Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: HomeProjectCard(project: project),
            )).toList(),
          ),
        ),
      ],
    );
  }
}