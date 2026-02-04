import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../models/project.dart';
import '../../../view_models/project/project_create_vm.dart';
import '../../../view_models/project/project_vm.dart';
import '../widgets/project_date_picker.dart';
import '../../../widgets/confirm_dialog.dart';
import '../../../theme/app_colors.dart';

class ProjectCreateView extends StatefulWidget {
  final ProjectModel? initialProject;

  const ProjectCreateView({super.key, this.initialProject});

  @override
  State<ProjectCreateView> createState() => _ProjectCreateViewState();
}

class _ProjectCreateViewState extends State<ProjectCreateView> {
  final _formKey = GlobalKey<FormState>();
  bool _isSaving = false; // 연타 방지 플래그 [cite: 2026-02-04]

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final vm = context.read<ProjectCreateViewModel>();
      if (widget.initialProject != null) {
        vm.titleController.text = widget.initialProject!.name;
        vm.descriptionController.text = widget.initialProject!.description;
        vm.dailyGoalController.text = widget.initialProject!.plans.isNotEmpty
            ? widget.initialProject!.plans.first
            : '';
        vm.memoController.text = widget.initialProject!.memo;
        vm.loadProjectDays(widget.initialProject!.selectedDays);

        vm.setDateRange(
          DateTimeRange(
            start: widget.initialProject!.startDate,
            end: widget.initialProject!.endDate,
          ),
        );
      } else {
        vm.clearFields();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<ProjectCreateViewModel>();
    final double screenWidth = MediaQuery
        .of(context)
        .size
        .width;
    final double hPadding = screenWidth > 600 ? screenWidth * 0.07 : 24.0;
    final bool isEditMode = widget.initialProject != null;

    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        backgroundColor: AppColors.background,
        resizeToAvoidBottomInset: true,
        appBar: null, // ✅ 상태바 침범 해결을 위해 AppBar 제거
        body: SafeArea(
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                _buildCustomHeader(context, isEditMode), // ✅ 커스텀 헤더 호출
                Expanded(
                  child: SingleChildScrollView(
                    padding: EdgeInsets.symmetric(
                      horizontal: hPadding,
                      vertical: 10,
                    ),
                    child: Column(
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
                        const SizedBox(height: 24),
                        _buildDaySelector(vm, screenWidth),
                        const SizedBox(height: 40),
                      ],
                    ),
                  ),
                ),
                _buildBottomActionButtons(
                  context,
                  vm,
                  isEditMode,
                ), // ✅ 하단 버튼 호출
              ],
            ),
          ),
        ),
      ),
    );
  }

  // 1. 상단 커스텀 헤더
  Widget _buildCustomHeader(BuildContext context, bool isEditMode) {
    return Container(
      height: 56,
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: Row(
        children: [
          IconButton(
            icon: const Icon(
              Icons.chevron_left,
              color: AppColors.foreground,
              size: 30,
            ),
            onPressed: () => Navigator.pop(context),
          ),
          Expanded(
            child: Text(
              isEditMode ? "프로젝트 수정" : "사부작 사부작",
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.bold,
                color: AppColors.foreground,
              ),
            ),
          ),
          const SizedBox(width: 48),
        ],
      ),
    );
  }

  // 2. 입력 필드 라벨 및 텍스트 폼
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
          decoration: InputDecoration(hintText: hint),
          validator: (value) {
            if (isRequired && (value == null || value
                .trim()
                .isEmpty)) {
              return "$label을 입력해 주세요";
            }
            return null;
          },
        ),
      ],
    );
  }

  // 3. 요일 선택 섹션
  Widget _buildDaySelector(ProjectCreateViewModel vm, double screenWidth) {
    double itemSize = (screenWidth - 120) / 7;
    if (itemSize > 45) itemSize = 45;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "반복 요일",
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: Color(0xFFB58A53),
          ),
        ),
        const SizedBox(height: 12),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: List.generate(7, (index) {
            final isSelected = vm.selectedDays[index];
            return GestureDetector(
              onTap: () => vm.toggleDay(index),
              child: Container(
                width: itemSize,
                height: itemSize,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: isSelected ? const Color(0xFFB58A53) : Colors.white,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  vm.days[index],
                  style: TextStyle(
                    color: isSelected ? Colors.white : const Color(0xFF5A4632),
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            );
          }),
        ),
      ],
    );
  }

  // 4. 하단 액션 버튼
  Widget _buildBottomActionButtons(BuildContext context,
      ProjectCreateViewModel vm,
      bool isEditMode,) {
    return Container(
      color: AppColors.background,
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(24, 10, 24, 20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.cloud_off, size: 14, color: Color(0xFFB58A53)),
                  SizedBox(width: 6),
                  Text(
                    "오프라인 상태에서도 로컬에 저장 후 온라인 시 자동 연동됩니다.",
                    style: TextStyle(fontSize: 11, color: Color(0xFFB58A53)),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: _isSaving
                          ? null
                          : () async {
                        final bool confirm = await showConfirmDialog(
                          context,
                          title: "작성 취소",
                          message: "작성 중인 내용이 저장되지 않습니다.",
                        );
                        if (confirm == true && context.mounted)
                          Navigator.pop(context);
                      },
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        side: const BorderSide(color: Color(0xFFB58A53)),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text(
                        "취소",
                        style: TextStyle(color: Color(0xFFB58A53)),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                        onPressed: _isSaving ? null : () async {
                          if (_formKey.currentState?.validate() ?? false) {
                            // 1. 네트워크상태 확인
                            final bool isOnline = await vm.checkConnection();

                            // 2. 오프라인일 때만 스낵바 노출
                            if (!isOnline && context.mounted) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text("오프라인 상태입니다. 나중에 동기화됩니다."),
                                  duration: Duration(seconds: 2),
                                ),
                              );
                            }

                            setState(() => _isSaving = true);
                            try {
                            } finally {
                              if (mounted) setState(() => _isSaving = false);
                            }
                          }
                        },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFB58A53),
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        disabledBackgroundColor: const Color(
                            0xFFDCC8B0),
                      ),
                      child: _isSaving
                          ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          color: Colors.white,
                          strokeWidth: 2,
                        ),
                      )
                          : Text(
                        isEditMode ? "수정 완료" : "저장하기",
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}