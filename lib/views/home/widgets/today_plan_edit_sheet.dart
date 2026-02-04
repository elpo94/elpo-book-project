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
        child: Container(
          constraints: BoxConstraints(
            maxHeight: MediaQuery.of(context).size.height * 0.9,
          ),
          decoration: const BoxDecoration(
            color: AppColors.background,
            borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
          ),
          child: Padding(
            padding: EdgeInsets.only(
              bottom: MediaQuery.of(context).viewInsets.bottom,
            ),
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(24, 12, 24, 32),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: Container(
                        width: 36, height: 4,
                        margin: const EdgeInsets.only(bottom: 24),
                        decoration: BoxDecoration(
                          color: AppColors.mutedOn.withValues(alpha: 0.08),
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                    ),

                    _buildInputLabel("오늘의 목표"),
                    _buildCompactTextField(
                      planController,
                      "예: 소설 1장 집필",
                      maxLength: 30,
                    ),
                    const SizedBox(height: 20),

                    _buildInputLabel("목표 시간 (분)"),
                    TextField(
                      controller: timeController,
                      keyboardType: TextInputType.number,
                      onChanged: (value) => setModalState(() {}),
                      style: const TextStyle(fontSize: 15, color: AppColors.foreground),
                      decoration: InputDecoration(
                        hintText: "예: 60",
                        hintStyle: TextStyle(color: AppColors.mutedOn.withValues(alpha: 0.5)),
                        filled: true,
                        fillColor: AppColors.surface,
                        errorText: (timeController.text.isNotEmpty && int.tryParse(timeController.text) == null)
                            ? "숫자만 가능해요"
                            : null,
                        errorStyle: const TextStyle(height: 0.8, fontSize: 11, color: AppColors.error),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(14),
                            borderSide: BorderSide.none
                        ),
                        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 15),
                      ),
                    ),
                    const SizedBox(height: 20),

                    _buildInputLabel("메모"),
                    _buildCompactTextField(
                        memoController,
                        "주의사항 등",
                        maxLines: 3,
                        maxLength: 50
                    ),
                    const SizedBox(height: 28),

                    SizedBox(
                      width: double.infinity,
                      height: 56,
                      child: ElevatedButton(
                        onPressed: () { },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.buttonPrimaryBg,
                          foregroundColor: AppColors.buttonPrimaryFg,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                          elevation: 0,
                        ),
                        child: const Text(
                            "저장하기",
                            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)
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
    ),
  );
}

Widget _buildInputLabel(String label) => Padding(
  padding: const EdgeInsets.only(bottom: 8, left: 4),
  child: Text(label, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: AppColors.mutedOn)),
);

Widget _buildCompactTextField(TextEditingController controller, String hint, {int maxLines = 1, int? maxLength}) {
  return TextField(
    controller: controller,
    maxLines: maxLines,
    maxLength: maxLength,
    style: const TextStyle(fontSize: 15),
    decoration: InputDecoration(
      hintText: hint,
      filled: true,
      fillColor: AppColors.surface,
      counterText: "",
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
    ),
  );
}