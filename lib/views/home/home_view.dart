import 'package:elpo_book_project/views/home/widgets/home_selection.dart';
import 'package:elpo_book_project/views/home/widgets/timer/home_timer_card.dart';
import 'package:elpo_book_project/views/home/widgets/memo_card.dart';
import 'package:elpo_book_project/views/home/widgets/today_plan_card.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(12),
      children: [
        //타이머
        HomeSection(child: HomeTimerCard(onTap: () => context.push('/timer'))),

        const HomeSection(title: '오늘 목표', child: TodayPlanCard()),

        HomeSection(title: '프로젝트', child: Text('프로젝트 영역 (더미)')),
      ],
    );
  }
}
