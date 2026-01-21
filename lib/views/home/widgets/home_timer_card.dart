
import 'package:flutter/material.dart';

import '../dialog/reset_dialog.dart';

class HomeTimerCard extends StatelessWidget {
  final VoidCallback? onTap;

  const HomeTimerCard({super.key, this.onTap});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 1,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Text(
              "03:45:12",
              style: TextStyle(fontSize: 60, fontWeight: FontWeight.w600),
            ),

            const SizedBox(height: 16),

            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                FilledButton(
                  onPressed: () {},
                  style: FilledButton.styleFrom(
                    foregroundColor: Colors.white, // 👈 글씨색
                  ),
                  child: const Text("Start"),
                ),

                const SizedBox(width: 12),

                OutlinedButton(
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (_) => const ResetTimerDialog(title: '타이머를 초기화할까요?',),
                    );
                  },
                  child: const Text("Reset"),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
