import 'package:flutter/material.dart';

class TodayPlanCard extends StatelessWidget {
  const TodayPlanCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 1,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: const [
                Text(
                  "오늘 목표",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                Icon(Icons.edit, size: 20),
              ],
            ),

            const SizedBox(height: 8),

            const Text("오늘 3시간 글쓰기"),

            const SizedBox(height: 6),

            const Text("이전 목표 횟수: 5회   진행: 3/5"),

            const SizedBox(height: 8),

            const LinearProgressIndicator(value: 0.6),
          ],
        ),
      ),
    );
  }
}
