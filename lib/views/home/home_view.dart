import 'package:elpo_book_project/views/home/widgets/home_timer_card.dart';
import 'package:elpo_book_project/views/home/widgets/memo_card.dart';
import 'package:elpo_book_project/views/home/widgets/today_plan_card.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: ListView(
            children: [
              SizedBox(height: 12),

              HomeTimerCard(
                  onTap: () {
                    context.push('/timer_landscape');
                  }
              ),

              SizedBox(height: 20),

              TodayPlanCard(),

              SizedBox(height: 20),

              MemoCard(),
            ],
          ),
        ),
      ),
    );
  }
}
