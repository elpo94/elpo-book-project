import 'package:flutter/material.dart';

import '../../../theme/app_colors.dart';

class AppInfoView extends StatelessWidget {
  const AppInfoView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(title: const Text("앱 정보")),
      body: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("사부작", style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            Text("버전 1.0.0", style: TextStyle(color: AppColors.mutedOn)),
            SizedBox(height: 20),
            Text("당신의 사부작거리는 모든 순간을 응원합니다."),
          ],
        ),
      ),
    );
  }
}