import 'package:flutter/material.dart';
import '../../../theme/app_colors.dart';
import '../../../view_models/project/project_create_vm.dart';
import '../widgets/project_date_picker.dart';

class ProjectFormFields extends StatelessWidget {
  final ProjectCreateViewModel vm;

  const ProjectFormFields({super.key, required this.vm});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildLabelField(
          label: "이름",
          controller: vm.titleController,
          hint: "예: 소설 1부 집필",
          isRequired: true,
          maxLength: 15,
        ),
        const SizedBox(height: 24),
        _buildLabelField(
          label: "설명",
          controller: vm.descriptionController,
          hint: "어떤 이야기인가요?",
          isMultiLine: true,
          maxLength: 50,
        ),
        const SizedBox(height: 24),
        _buildLabelField(
          label: "기간",
          controller: vm.periodController,
          hint: "날짜를 선택하세요",
          readOnly: true,
          isRequired: true,
          onTap: () async {
            final range = await showAppDateRangePicker(context);
            if (range != null) vm.setDateRange(range);
          },
        ),
        const SizedBox(height: 24),
        _buildLabelField(
          label: "목표",
          controller: vm.dailyGoalController,
          hint: "예: 하루 3시간 / 2,000자",
          textInputAction: TextInputAction.done,
          maxLength: 30,
        ),
      ],
    );
  }

  // 기존에 뷰에 있던 _buildLabelField 로직을 이쪽으로 옮겨왔습니다. [cite: 2026-02-04]
  Widget _buildLabelField({
    required String label,
    required TextEditingController controller,
    required String hint,
    bool isMultiLine = false,
    bool readOnly = false,
    bool isRequired = false,
    int? maxLength,
    VoidCallback? onTap,
    TextInputAction textInputAction = TextInputAction.next,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              label,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Color(0xFFB58A53),
              ),
            ),
            if (isRequired)
              const Text(
                " *",
                style: TextStyle(color: AppColors.error, fontSize: 14),
              ),
          ],
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          maxLines: isMultiLine ? 4 : 1,
          readOnly: readOnly,
          onTap: onTap,
          maxLength: maxLength,
          textInputAction: textInputAction,
          decoration: InputDecoration(
            hintText: hint,
            counterStyle: const TextStyle(fontSize: 12),
          ),
          validator: (value) {
            if (isRequired && (value == null || value.trim().isEmpty)) {
              return "$label을 입력해 주세요";
            }
            return null;
          },
        ),
      ],
    );
  }
}