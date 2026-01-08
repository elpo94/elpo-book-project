import 'package:elpo_book_project/views/home/widgets/home_selection.dart';
import 'package:elpo_book_project/views/home/widgets/home_timer_card.dart';
import 'package:elpo_book_project/views/home/widgets/memo_card.dart';
import 'package:elpo_book_project/views/home/widgets/today_plan_card.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../project/widgets/project_create_preview_card.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          //타이머
          HomeSection(
            child: HomeTimerCard(
              onTap: () {
                context.push('/timer_landscape');
              },
            ),
          ),

          const HomeSection(
            title: '오늘 목표',
            child: TodayPlanCard(),
          ),

          const HomeSection(
            title: '프로젝트',
            child: ProjectCreatePreviewCard(),
          ),

        ],
      )
    );
  }
}
