import 'package:flutter/material.dart';

class EditPlanView extends StatelessWidget {
  const EditPlanView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("목표 수정하기")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: ListView(
          children: [
            const Text("하루 목표"),
            const SizedBox(height: 6),
            TextField(
              decoration: InputDecoration(
                hintText: "예: 3시간 글쓰기",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),

            const SizedBox(height: 16),

            const Text("주간 빈도"),
            const SizedBox(height: 6),
            TextField(
              decoration: InputDecoration(
                hintText: "예: 5일",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),

            const SizedBox(height: 16),

            const Text("메모"),
            const SizedBox(height: 6),
            TextField(
              maxLines: 4,
              decoration: InputDecoration(
                hintText: "오늘 계획을 적어보세요",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),

            const SizedBox(height: 24),

            FilledButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text("저장"),
            )
          ],
        ),
      ),
    );
  }
}
