import 'package:flutter/material.dart';

class ResetTimerDialog extends StatelessWidget {
  final String title;
  const ResetTimerDialog({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    return AlertDialog(
      backgroundColor: const Color(0xFFFFF8EE),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),

      insetPadding: const EdgeInsets.symmetric(
        horizontal: 28,
        vertical: 24,
      ),

      contentPadding: const EdgeInsets.fromLTRB(20, 12, 20, 8),

      title:  Text(
        title,
        textAlign: TextAlign.center,
        style: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 18,
          color: Color(0xFF3A2B1A),
        ),
      ),

      content: const Text(
        "누적된 시간이 00:00으로 돌아갑니다.\n이 작업은 되돌릴 수 없습니다.",
        textAlign: TextAlign.center,
        style: TextStyle(
          color: Color(0xFF5A4632),
          fontSize: 14,
        ),
      ),

      actionsPadding: const EdgeInsets.fromLTRB(20, 10, 20, 16),

      actions: [
        SizedBox(
          width: width * 0.6,   // 🔥 기기 크기에 따라 조절됨
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [

              /// 취소 버튼
              Expanded(
                child: OutlinedButton(
                  onPressed: () => Navigator.pop(context),
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    backgroundColor: const Color(0xFFF3E9D2),
                    side: const BorderSide(color: Color(0xFFE1D5C7)),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                  child: const Text(
                    "취소",
                    style: TextStyle(
                      color: Color(0xFF5A4632),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),

              const SizedBox(width: 12),

              /// 초기화 버튼
              Expanded(
                child: FilledButton(
                  onPressed: () => Navigator.pop(context),
                  style: FilledButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    backgroundColor: Color(0xFFD65C5C),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                  child: const Text(
                    "초기화",
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
