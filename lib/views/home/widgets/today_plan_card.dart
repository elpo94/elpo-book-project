import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sabujak_application/theme/app_colors.dart';
import '../../../view_models/home/home_vm.dart';

class TodayPlanCard extends StatelessWidget {
  const TodayPlanCard({super.key});

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<HomeViewModel>();

    return Card(
      elevation: 0,
      color: const Color(0xFFF3EDE2), // 피그마 베이지 톤 반영
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    vm.todayPlan,
                    style: const TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: const Color(0xFFB58A53),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    "${vm.targetTime}분", // 목표 시간 표시
                    style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold),
                  ),
                ),
                const SizedBox(width: 8),
                IconButton(
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                  // ⭐ 여기서 _showEditSheet를 호출하도록 수정했습니다!
                  onPressed: () => _showEditSheet(context, vm),
                  icon: const Icon(Icons.edit, size: 20, color: Colors.black54),
                ),
              ],
            ),
            if (vm.planMemo.isNotEmpty) ...[
              const SizedBox(height: 12),
              Text(
                vm.planMemo, // 저장된 메모 표시
                style: const TextStyle(fontSize: 14, color: Color(0xFF8D7A65), height: 1.4),
              ),
            ],
          ],
        ),
      ),
    );
  }

  // --- 피그마 스타일 바텀시트 ---
  void _showEditSheet(BuildContext context, HomeViewModel vm) {
    final planController = TextEditingController(text: vm.todayPlan);
    final timeController = TextEditingController(text: vm.targetTime.toString());
    final memoController = TextEditingController(text: vm.planMemo);

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      elevation: 0,
      barrierColor: Colors.transparent,
      backgroundColor: AppColors.background,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
      ),
        builder: (context) => Theme(
          data: Theme.of(context).copyWith(
            // 여기서 M3의 색상 보정(Tint)을 꺼버립니다.
            canvasColor: Colors.transparent,
            colorScheme: Theme.of(context).colorScheme.copyWith(
              surfaceTint: Colors.transparent,
            ),
          ),
          child: Container(
        decoration: const BoxDecoration(
          color: AppColors.background, // 시트 배경색
          borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
        ),
        padding: EdgeInsets.only(
          left: 28, right: 28, top: 32,
          bottom: MediaQuery.of(context).viewInsets.bottom + 32,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("목표 수정하기", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            const SizedBox(height: 24),
            _buildInputLabel("오늘의 목표"),
            _buildTextField(planController, "예: 소설 1장 집필"),
            const SizedBox(height: 16),
            _buildInputLabel("목표 시간 (분)"),
            _buildTextField(timeController, "예: 60", isNumber: true),
            const SizedBox(height: 16),
            _buildInputLabel("메모"),
            _buildTextField(memoController, "집필 시 주의사항 등", maxLines: 3),
            const SizedBox(height: 32),
            SizedBox(
              width: double.infinity,
              height: 56,
              child: ElevatedButton(
                onPressed: () {
                  vm.updateAllPlanData(
                    plan: planController.text,
                    time: int.tryParse(timeController.text) ?? 0,
                    memo: memoController.text,
                  );
                  Navigator.pop(context);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFB58A53),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                ),
                child: const Text("저장하기", style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
              ),
            ),
          ],
        ),
      ),
    )
    );
  }

  Widget _buildInputLabel(String label) => Padding(
    padding: const EdgeInsets.only(bottom: 8, left: 4),
    child: Text(label, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Color(0xFF8D7A65))),
  );

  Widget _buildTextField(TextEditingController controller, String hint, {bool isNumber = false, int maxLines = 1}) {
    return TextField(
      controller: controller,
      keyboardType: isNumber ? TextInputType.number : TextInputType.text,
      maxLines: maxLines,
      decoration: InputDecoration(
        hintText: hint,
        filled: true,
        fillColor: const Color(0xFFF3EDE2),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide.none),
        contentPadding: const EdgeInsets.all(16),
      ),
    );
  }
}