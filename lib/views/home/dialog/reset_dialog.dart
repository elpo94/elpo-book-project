import 'package:flutter/material.dart';

class ResetTimerDialog extends StatelessWidget {
  const ResetTimerDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text("타이머 초기화할까요?"),
      content: const Text("누적된 시간이 00:00으로 돌아갑니다."),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text("취소"),
        ),
        FilledButton(
          onPressed: () => Navigator.pop(context),
          child: const Text("초기화"),
        ),
      ],
    );
  }
}
