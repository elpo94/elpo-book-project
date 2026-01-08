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
              children: [
                Expanded(
                  child: Text(
                    goalTitle,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 16, // 여기서만 크기 조절
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                SizedBox(
                  width: 40, // 아이콘 영역 고정
                  child: IconButton(
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                    onPressed: () => context.push('/home/edit-plan'),
                    icon: const Icon(Icons.edit, size: 20),
                  ),
                ),
              ],
            )
          ]
        ),
      ),
    );
  }
}
