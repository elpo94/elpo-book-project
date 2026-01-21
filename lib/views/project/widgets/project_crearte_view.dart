import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../models/project.dart';
import '../../../view_models/project/project_create_vm.dart';
import '../../../view_models/project/project_vm.dart';
import '../../../widgets/app_button_style.dart';
import '../../../widgets/button_style.dart';
import '../widgets/project_date_picker.dart';
import '../../../theme/app_colors.dart';

class ProjectCreateView extends StatefulWidget {
  final ProjectModel? initialProject; // ⭐ 데이터가 있으면 수정 모드

  const ProjectCreateView({super.key, this.initialProject});

  @override
  State<ProjectCreateView> createState() => _ProjectCreateViewState();
}

class _ProjectCreateViewState extends State<ProjectCreateView> {
  @override
  void initState() {
    super.initState();
    // 💡 화면이 켜질 때, 수정할 데이터가 있다면 VM의 컨트롤러에 미리 채워줍니다.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final vm = context.read<ProjectCreateViewModel>();
      if (widget.initialProject != null) {
        vm.titleController.text = widget.initialProject!.name;
        vm.descriptionController.text = widget.initialProject!.description;
        vm.dailyGoalController.text = widget.initialProject!.plans.isNotEmpty
            ? widget.initialProject!.plans.first : '';
        vm.memoController.text = widget.initialProject!.memo; // 모델에 메모가 있다면 추가

        // 날짜 세팅
        vm.setDateRange(DateTimeRange(
          start: widget.initialProject!.startDate,
          end: widget.initialProject!.endDate,
        ));
      } else {
        vm.clearFields(); // 신규 등록이면 비우기
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<ProjectCreateViewModel>();
    final double screenWidth = MediaQuery.of(context).size.width;
    final double hPadding = screenWidth > 600 ? screenWidth * 0.07 : 24.0;

    // 모드에 따른 텍스트 설정
    final bool isEditMode = widget.initialProject != null;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(isEditMode ? "프로젝트 수정" : "사부작 사부작",
            style: const TextStyle(color: AppColors.foreground, fontSize: 17, fontWeight: FontWeight.w600)),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.close, color: AppColors.foreground, size: 26),
            onPressed: () => Navigator.pop(context),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.symmetric(horizontal: hPadding, vertical: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildLabelField("이름", vm.titleController, "예: 소설 1부 집필"),
                  const SizedBox(height: 24),
                  _buildLabelField("설명", vm.descriptionController, "어떤 이야기인가요?", isMultiLine: true),
                  const SizedBox(height: 24),
                  _buildLabelField(
                    "기간",
                    vm.periodController,
                    "날짜를 선택하세요",
                    readOnly: true,
                    onTap: () async {
                      final range = await showAppDateRangePicker(context);
                      if (range != null) vm.setDateRange(range);
                    },
                  ),
                  const SizedBox(height: 24),
                  _buildLabelField("목표", vm.dailyGoalController, "예: 하루 3시간 / 2,000자"),
                  const SizedBox(height: 24),
                  _buildDaySelector(vm, screenWidth),
                ],
              ),
            ),
          ),
          _buildBottomActionButtons(context, vm, isEditMode),
        ],
      ),
    );
  }

  // --- 기존의 UI 메서드 (_buildLabelField, _buildDaySelector 등) ---

  Widget _buildLabelField(String label, TextEditingController controller, String hint,
      {bool isMultiLine = false, bool readOnly = false, VoidCallback? onTap}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Color(0xFFB58A53))),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          maxLines: isMultiLine ? 4 : 1,
          readOnly: readOnly,
          onTap: onTap,
          decoration: InputDecoration(
            hintText: hint,
            filled: true,
            fillColor: Colors.white.withOpacity(0.7),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
            contentPadding: const EdgeInsets.all(16),
          ),
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
                child: Text(vm.days[index],
                    style: TextStyle(
                        color: isSelected ? Colors.white : const Color(0xFF5A4632),
                        fontWeight: FontWeight.bold)),
              ),
            );
          }),
        ),
      ],
    );
  }

  Widget _buildBottomActionButtons(BuildContext context, ProjectCreateViewModel vm, bool isEditMode) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(24, 10, 24, 20),
        child: Row(
          children: [
            Expanded(child: AppActionButton(label: "취소", style: AppButtonStyle.outline, onPressed: () => Navigator.pop(context))),
            const SizedBox(width: 12),
            Expanded(
              child: AppActionButton(
                label: isEditMode ? "수정 완료" : "저장하기",
                style: AppButtonStyle.primary,
                onPressed: () async {
                  if (isEditMode) {
                    // ⭐ 수정 로직 실행
                    try {
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
                      if (context.mounted) Navigator.pop(context);
                    } catch (e) {
                      debugPrint("수정 실패: $e");
                    }
                  } else {
                    // 신규 저장 로직 (기존과 동일)
                    final newProject = vm.createProjectModel();
                    if (newProject != null) {
                      await context.read<ProjectViewModel>().addProject(newProject);
                      vm.clearFields();
                      if (context.mounted) Navigator.pop(context);
                    }
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}