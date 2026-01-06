import 'package:flutter/material.dart';

import '../../view_models/home_vm.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<HomeViewModel>();
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              /// 타이머 카드
              Card(
                elevation: 1,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16)),
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("오늘의 집중시간",
                          style: Theme.of(context).textTheme.bodyLarge),
                      const SizedBox(height: 8),

                      Center(
                        child: Text(
                          "03:45:12",
                          style: const TextStyle(
                            fontSize: 36,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),

                      const SizedBox(height: 12),
                      const LinearProgressIndicator(value: 0.35),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 24),

              /// 오늘 일정
              const Text(
                "오늘 일정",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),

              const SizedBox(height: 12),

              Expanded(
                child: ListView(
                  children: const [
                    ListTile(
                      title: Text("📖 글쓰기 1시간"),
                    ),
                    ListTile(
                      title: Text("☕ 카페에서 책읽기"),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
