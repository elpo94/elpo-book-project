import 'package:flutter/material.dart';
import '../../../../theme/app_colors.dart';
import '../../../../view_models/home/home_vm.dart';

void showTodayPlanEditSheet(BuildContext context, HomeViewModel vm) {
  final planController = TextEditingController(text: vm.todayPlan);
  final timeController = TextEditingController(text: vm.targetTime.toString());
  final memoController = TextEditingController(text: vm.planMemo);

  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (context) => StatefulBuilder(
      builder: (context, setModalState) => GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          child: Container(
            decoration: const BoxDecoration(
              color: AppColors.background,
              borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
            ),
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(28, 32, 28, 32),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "목표 수정하기",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: AppColors.foreground,
                    ),
                  ),
                  const SizedBox(height: 24),

                  // 1. 오늘의 목표 필드
                  _buildInputLabel("오늘의 목표"),
                  _buildTextField(planController, "예: 소설 1장 집필", maxLength: 30),
                  const SizedBox(height: 16),

                  // 2. 목표 시간 필드 (중복 제거 및 실시간 검증 통합)
                  _buildInputLabel("목표 시간 (분)"),
                  TextField(
                    controller: timeController,
                    keyboardType: TextInputType.number,
                    onChanged: (value) {
                      setModalState(() {}); // 에러 메시지 실시간 업데이트를 위해 필요
                    },
                    decoration: InputDecoration(
                      hintText: "예: 60",
                      filled: true,
                      fillColor: AppColors.surface,
                      // ✅ 숫자가 아닌 경우 에러 문구 표시
                      errorText: (timeController.text.isNotEmpty &&
                          int.tryParse(timeController.text) == null)
                          ? "숫자만 입력할 수 있어요"
                          : null,
                      errorStyle: const TextStyle(
                        color: Colors.redAccent,
                        fontSize: 12,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                        borderSide: BorderSide.none,
                      ),
                      contentPadding: const EdgeInsets.all(16),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // 3. 메모 필드
                  _buildInputLabel("메모"),
                  _buildTextField(
                    memoController,
                    "집필 시 주의사항 등",
                    maxLines: 3,
                    maxLength: 50,
                  ),
                  const SizedBox(height: 32),

                  // 저장 버튼
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
                        backgroundColor: AppColors.buttonPrimaryBg,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                      child: const Text(
                        "저장하기",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    ),
  );
}
Widget _buildTextField(
  TextEditingController controller,
  String hint, {
  bool isNumber = false,
  int maxLines = 1,
  int? maxLength,
}) {
  return TextField(
    controller: controller,
    keyboardType: isNumber ? TextInputType.number : TextInputType.text,
    maxLines: maxLines,
    maxLength: maxLength,
    decoration: InputDecoration(
      hintText: hint,
      filled: true,
      fillColor: AppColors.surface,
      counterStyle: const TextStyle(fontSize: 11, color: AppColors.mutedOn),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide.none,
      ),
      contentPadding: const EdgeInsets.all(16),
    ),
  );
}

Widget _buildInputLabel(String label) => Padding(
  padding: const EdgeInsets.only(bottom: 8, left: 4),
  child: Text(
    label,
    style: const TextStyle(
      fontSize: 14,
      fontWeight: FontWeight.w600,
      color: AppColors.mutedOn,
    ),
  ),
);
