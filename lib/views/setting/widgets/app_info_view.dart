import 'package:flutter/material.dart';
import '../../../theme/app_colors.dart';

class AppInfoView extends StatelessWidget {
  const AppInfoView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background, // 기존 테마 유지
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        // 안드로이드 친화적인 쉐브론 레프트 뒤로가기
        leading: IconButton(
          icon: const Icon(Icons.chevron_left, color: AppColors.foreground, size: 30),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          "앱 정보",
          style: TextStyle(
            color: AppColors.foreground,
            fontWeight: FontWeight.bold,
            fontSize: 17,
          ),
        ),
        centerTitle: true,
        actions: [
          // 배포 시 유용한 전체 닫기(X) 버튼
          IconButton(
            icon: const Icon(Icons.close, color: AppColors.foreground),
            onPressed: () => Navigator.of(context).popUntil((route) => route.isFirst),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSectionTitle("서비스 소개"),
            const SizedBox(height: 12),
            _buildDescriptionCard(
                "사부작은 '작은 일이나 재미있는 일을 조심스럽고 가볍게 자꾸 하는 모양'이라는 뜻을 담고 있습니다.\n\n"
                    "거창한 계획에 압도되기보다, 매일의 소중한 한 줄과 10분의 집중이 삶의 습관으로 스며들 수 있도록 돕습니다.\n\n"
                    "당신이 사부작거리는 모든 작은 순간들을 응원합니다." // 성주님의 교정 문구 반영
            ),
            const SizedBox(height: 32),

            _buildSectionTitle("제작 정보"),
            _buildInfoRow("버전", "1.0.0"),
            _buildInfoRow("제작자", "made by elpo94"), // 깃허브 ID 반영
            _buildInfoRow("문의처", "elpo@hanmail.net"), // 문의 메일 반영
            const SizedBox(height: 32),

            _buildSectionTitle("라이선스"),
            const SizedBox(height: 12),
            _buildLicenseTile(context),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.bold,
        color: Color(0xFFB58A53), // 테마에 맞춘 베이지/브라운 포인트
      ),
    );
  }

  Widget _buildDescriptionCard(String text) {
    return Container(
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.6), // 연한 배경
        borderRadius: BorderRadius.circular(24),
      ),
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 14,
          color: Color(0xFF5A4632), // 브라운 계열 글씨
          height: 1.7,
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(color: Color(0xFF8D7A65), fontSize: 14)),
          Text(value, style: const TextStyle(color: Color(0xFF5A4632), fontWeight: FontWeight.w600, fontSize: 14)),
        ],
      ),
    );
  }

  Widget _buildLicenseTile(BuildContext context) {
    return InkWell(
      onTap: () => showLicensePage(context: context),
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          border: Border.all(color: const Color(0xFFE1D5C7)),
          borderRadius: BorderRadius.circular(16),
        ),
        child: const Row(
          children: [
            Icon(Icons.description_outlined, size: 20, color: Color(0xFFB58A53)),
            SizedBox(width: 12),
            Text("오픈소스 라이선스 확인", style: TextStyle(color: Color(0xFF5A4632), fontSize: 14)),
            Spacer(),
            Icon(Icons.chevron_right, color: Color(0xFFB58A53)),
          ],
        ),
      ),
    );
  }
}