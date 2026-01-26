import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../models/project.dart';
import '../../../view_models/project/project_create_vm.dart';
import '../../../view_models/project/project_vm.dart';
import '../../../widgets/app_button_style.dart';
import '../../../widgets/button_style.dart';
import '../../../widgets/confirm_dialog.dart';
import '../widgets/project_date_picker.dart';
import '../../../theme/app_colors.dart';

class ProjectCreateView extends StatefulWidget {
  final ProjectModel? initialProject;

  const ProjectCreateView({super.key, this.initialProject});

  @override
  State<ProjectCreateView> createState() => _ProjectCreateViewState();
}

class _ProjectCreateViewState extends State<ProjectCreateView> {
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final vm = context.read<ProjectCreateViewModel>();
      if (widget.initialProject != null){
        vm.titleController.text = widget.initialProject!.name;
        vm.descriptionController.text = widget.initialProject!.description;
        vm.dailyGoalController.text = widget.initialProject!.plans.isNotEmpty
            ? widget.initialProject!.plans.first
            : '';
        vm.memoController.text = widget.initialProject!.memo;
        vm.loadProjectDays(widget.initialProject!.selectedDays);

        vm.setDateRange(DateTimeRange(
          start: widget.initialProject!.startDate,
          end: widget.initialProject!.endDate,
        ));
      } else {
        vm.clearFields();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<ProjectCreateViewModel>();
    final double screenWidth = MediaQuery.of(context).size.width;
    final double hPadding = screenWidth > 600 ? screenWidth * 0.07 : 24.0;
    final bool isEditMode = widget.initialProject != null;

    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        backgroundColor: AppColors.background,
        resizeToAvoidBottomInset: true,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.chevron_left, color: AppColors.foreground),
            onPressed: () => Navigator.pop(context),
          ),
          title: Text(isEditMode ? "프로젝트 수정" : "사부작 사부작"),
          centerTitle: true,
        ),
        body: Form(
          key: _formKey,
          child: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  padding: EdgeInsets.symmetric(horizontal: hPadding, vertical: 10),
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
                      // ✅ 요일 선택 섹션 (별표 제거)
                      _buildDaySelector(vm, screenWidth),
                      const SizedBox(height: 100),
                    ],
                  ),
                ),
              ),
              _buildBottomActionButtons(context, vm, isEditMode),
            ],
          ),
        ),
      ),
    );
  }

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
            Text(label, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Color(0xFFB58A53))),
            if (isRequired) const Text(" *", style: TextStyle(color: AppColors.error, fontSize: 14)),
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
            if (isRequired && (value == null || value.isEmpty)) {
              return "$label을 입력해 주세요";
            }
            return null;
          },
        ),
      ],
    );
  }

  Widget _buildDaySelector(ProjectCreateViewModel vm, double screenWidth) {
    double itemSize = (screenWidth - 120) / 7;
    if (itemSize > 45) itemSize = 45;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text("반복 요일", style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Color(0xFFB58A53))),
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
                  style: TextStyle(color: isSelected ? Colors.white : const Color(0xFF5A4632), fontWeight: FontWeight.bold),
                ),
              ),
            );
          }),
        ),
      ],
    );
  }

  Widget _buildBottomActionButtons(BuildContext context, ProjectCreateViewModel vm, bool isEditMode) {
    return Container(
      color: AppColors.background,
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(24, 10, 24, 20),
          child: Row(
            children: [
              Expanded(
                child: AppActionButton(
                  label: "취소",
                  style: AppButtonStyle.outline,
                  onPressed: () async {
                    final bool confirm = await showConfirmDialog(context, title: "작성 취소", message: "작성 중인 내용이 저장되지 않습니다.");
                    if (confirm == true && context.mounted) Navigator.pop(context);
                  },
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: AppActionButton(
                  label: isEditMode ? "수정 완료" : "저장하기",
                  style: AppButtonStyle.primary,
                  onPressed: () async {
                    // 1. 이름과 기간 필수 검증 (Form Validator 활용)
                    final bool isFormValid = _formKey.currentState?.validate() ?? false;

                    if (isFormValid) {
                      try {
                        // 2. 요일 미선택 시 자동 '매일' 처리 로직 (핵심)
                        if (!vm.selectedDays.contains(true)) {
                          for (int i = 0; i < vm.selectedDays.length; i++) {
                            vm.selectedDays[i] = true; // 화면상에서도 전체 선택으로 시각화
                          }
                        }

                        if (isEditMode) {
                          await context.read<ProjectViewModel>().updateProject(
                            projectId: widget.initialProject!.id,
                            name: vm.titleController.text,
                            description: vm.descriptionController.text,
                            startDate: vm.startDate ?? widget.initialProject!.startDate,
                            endDate: vm.endDate ?? widget.initialProject!.endDate,
                            plans: [vm.dailyGoalController.text],
                            status: widget.initialProject!.status,
                            memo: vm.memoController.text,
                            selectedDays: List.from(vm.selectedDays), // ✅ 요일 데이터 명시적 전달
                          );
                        } else {
                          // createProjectModel() 내부에서 이미 보정 로직이 돌아가도록 VM과 협의됨
                          final newProject = vm.createProjectModel();
                          if (newProject != null) {
                            await context.read<ProjectViewModel>().addProject(newProject);
                            vm.clearFields();
                          }
                        }
                        if (context.mounted) Navigator.pop(context);
                      } catch (e) {
                        debugPrint("처리 중 에러 발생: $e");
                      }
                    }
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}