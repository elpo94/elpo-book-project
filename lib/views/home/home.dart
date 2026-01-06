import 'package:elpo_book_project/views/home/widget/home_timer_card.dart';
import 'package:elpo_book_project/views/home/widget/memo_card.dart';
import 'package:elpo_book_project/views/home/widget/today_goal_card.dart';
import 'package:flutter/material.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: ListView(
            children: const [
              SizedBox(height: 12),

              HomeTimerCard(),

              SizedBox(height: 20),

              TodayGoalCard(),

              SizedBox(height: 20),

              MemoCard(),
            ],
          ),
        ),
      ),
    );
  }
}
