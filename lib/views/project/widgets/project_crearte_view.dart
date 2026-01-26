import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../models/project.dart';
import '../../../services/auth_service.dart';
import '../../../view_models/project/project_create_vm.dart';
import '../../../view_models/project/project_vm.dart';
import '../../../widgets/app_button_style.dart';
import '../../../widgets/button_style.dart';
import '../../../widgets/confirm_dialog.dart';
import '../widgets/project_date_picker.dart';
import '../../../theme/app_colors.dart';
import 'package:sabujak_application/services/auth_service.dart';

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
      if (widget.initialProject != null) {
        vm.titleController.text = widget.initialProject!.name;
        vm.descriptionController.text = widget.initialProject!.description;
        vm.dailyGoalController.text = widget.initialProject!.plans.isNotEmpty
            ? widget.initialProject!.plans.first
            : '';
        vm.memoController.text = widget.initialProject!.memo;
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
        ),
        // ✅ Form으로 감싸서 필수 입력을 한 번에 검종합니다.
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
                        isRequired: true, // ✅ 필수
                        maxLength: 15,    // ✅ 글자수 제한
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
                        isRequired: true, // ✅ 필수
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
    TextInputAction textInputAction = TextInputAction.next, // ✅ 기본은 '다음'으로 이동
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(label, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Color(0xFFB58A53))),
            if (isRequired) const Text(" *", style: TextStyle(color: AppColors.error, fontSize: 14)), // 필수 표시
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
          style: const TextStyle(fontSize: 16),
          decoration: InputDecoration(
            hintText: hint,

            counterStyle: const TextStyle(
              fontSize: 11,
              color: AppColors.mutedOn,
            ),
          ),
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
              // 1️⃣ 취소 버튼: 작성 중인 데이터가 날아갈 수 있으므로 다이얼로그 노출
              Expanded(
                child: AppActionButton(
                  label: "취소",
                  style: AppButtonStyle.outline,
                  onPressed: () async {
                    final bool confirm = await showConfirmDialog(
                      context,
                      title: "작성 취소",
                      message: "작성 중인 내용이 저장되지 않습니다. 정말 취소하시겠어요?",
                    );
                    if (confirm == true && context.mounted) {
                      Navigator.pop(context);
                    }
                  },
                ),
              ),
              const SizedBox(width: 12),

              // 2️⃣ 저장/수정 버튼: 유효성 검사 후 서버(Firebase)와 통신
              Expanded(
                child: AppActionButton(
                  label: isEditMode ? "수정 완료" : "저장하기",
                  style: AppButtonStyle.primary,
                  onPressed: () async {
                    final bool isFormValid = _formKey.currentState?.validate() ?? false;
                    final bool isDaySelected = vm.selectedDays.contains(true);

                    if (isFormValid && isDaySelected) {
                      try {
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
                          );
                        } else {
                          final newProject = vm.createProjectModel();
                          if (newProject != null) {
                            // ✅ addProject에도 인자를 넘기지 않습니다. (VM 내부에서 처리)
                            await context.read<ProjectViewModel>().addProject(newProject);
                            vm.clearFields();
                          }
                        }

                        if (context.mounted) Navigator.pop(context); // 성공 시 화면 닫기
                      } catch (e) {
                        debugPrint("처리 중 에러 발생: $e");
                      }
                    } else if (!isDaySelected) {
                      // 요일을 선택하지 않았을 때의 피드백
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text("반복 요일을 하나 이상 선택해 주세요.")),
                      );
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