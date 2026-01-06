import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class TodayPlanCard extends StatelessWidget {
  const TodayPlanCard({super.key});

  @override
  Widget build(BuildContext context) {
    // 임시 더미 값 (나중에 ViewModel에서 받아오면 됨)
    const String goalTitle = "소설 루트 프로토콜 세계관 설정";
    const double progress = 0.45; // 45%

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
            /// 상단: 제목 + 수정 버튼
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  "오늘 목표",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                IconButton(
                  onPressed: () => context.push('/home/edit-plan'),
                  icon: const Icon(Icons.edit),
                ),
              ],
            ),

            const SizedBox(height: 8),

            /// 목표 문구
            Text(
              "목표 : $goalTitle",
              style: const TextStyle(fontSize: 14),
            ),

            const SizedBox(height: 4),

            /// 퍼센트 줄 (아래로 내린 부분)
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  "진행률",
                  style: TextStyle(fontSize: 12, color: Colors.grey),
                ),
                Text(
                  "${(progress * 100).round()}%",
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 8),

            /// 진행 바
            LinearProgressIndicator(
              value: progress,
              minHeight: 6,
              borderRadius: BorderRadius.circular(999),
            ),

            const SizedBox(height: 12),

          ],
        ),
      ),
    );
  }
}
