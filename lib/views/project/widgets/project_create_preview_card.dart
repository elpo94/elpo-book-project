import 'package:flutter/material.dart';

class ProjectCreatePreviewCard extends StatelessWidget {
  const ProjectCreatePreviewCard({super.key});

  @override
  Widget build(BuildContext context) {
    final days = ["월","화","수","목","금","토","일"];

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
            /// 제목
            const Text(
              "새 프로젝트 만들기",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 12),

            /// 설명 (더미)
            const Text(
              "프로젝트 목표와 반복 요일을 설정할 수 있어요",
              style: TextStyle(fontSize: 13, color: Colors.grey),
            ),

            const SizedBox(height: 16),

            /// 요일 선택 (비활성 더미)
            Row(
              children: List.generate(7, (index) {
                return Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 1),
                    child: ChoiceChip(
                      label: Center(child: Text(days[index])),
                      selected: false,           // 전부 false (더미)
                      onSelected: null,          // 비활성
                    ),
                  ),
                );
              }),
            ),
          ],
        ),
      ),
    );
  }
}
