import 'package:flutter/material.dart';

class MemoCard extends StatelessWidget {
  const MemoCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 1,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: SizedBox(
          width: double.infinity,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: const [
              Text(
                "메모",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),

              SizedBox(height: 8),

              Text("• 오늘 블로그 글 3구조 잡기"),
              Text("• 주말여행 동기 예약정리"),
              Text("• 대학 강연 자료손질 마무리"),
            ],
          ),
        ),
      ),
    );
  }
}
