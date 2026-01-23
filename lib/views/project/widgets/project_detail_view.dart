import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sabujak_application/views/project/widgets/project_crearte_view.dart';
import '../../../models/project.dart';
import '../../../view_models/project/project_vm.dart';
import '../../../theme/app_colors.dart';
import 'project_status.dart';

class ProjectDetailView extends StatefulWidget {
  final String projectId;
  const ProjectDetailView({super.key, required this.projectId});

  @override
  State<ProjectDetailView> createState() => _ProjectDetailViewState();
}

class _ProjectDetailViewState extends State<ProjectDetailView> {
  late ProjectStatus _currentStatus;
  bool _isInitialized = false;
  final TextEditingController _memoController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final projectVM = context.watch<ProjectViewModel>();
    final project = projectVM.projects.firstWhere(
          (p) => p.id == widget.projectId,
      orElse: () => ProjectModel.empty(),
    );

    if (!_isInitialized) {
      _currentStatus = project.status;
      _memoController.text = project.memo; // 메모 데이터 연동
      _isInitialized = true;
    }

    final dStatus = project.displayStatus;
    final bool isOverdue = dStatus == ProjectDisplayStatus.overdue;

    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        backgroundColor: AppColors.background,
        resizeToAvoidBottomInset: true, // 키보드 대응 활성화
        appBar: AppBar(
          actions: [
            IconButton(
              icon: const Icon(Icons.edit_note, size: 28, color: Color(0xFFB58A53)),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ProjectCreateView(initialProject: project),
                  ),
                );
              },
            ),
            const SizedBox(width: 12),
          ],
          title: const Text("사부작", style: TextStyle(color: AppColors.foreground, fontWeight: FontWeight.bold)),
          centerTitle: true,
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios, color: AppColors.foreground),
            onPressed: () => Navigator.pop(context),
          ),
        ),
        body: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(28),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildProjectHeader(project.name, project.description, isOverdue),
                    const SizedBox(height: 24),
                    _infoRow('하루 목표', project.plans.isNotEmpty ? project.plans.first : '설정 없음'),
                    _infoRow('작성 기간', "${_formatDate(project.startDate)} ~ ${_formatDate(project.endDate)}"),
                    const SizedBox(height: 32),
                    if (isOverdue) _buildOverdueWarning(),
                    const Text('프로젝트 상태', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 15)),
                    const SizedBox(height: 12),
                    _buildStatusSelector(),
                    const SizedBox(height: 32),
                    const Text('메모', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 15)),
                    const SizedBox(height: 10),
                    _buildMemoField(),
                    // 키보드가 메모장을 가리지 않도록 하단 여백 확보
                    SizedBox(height: MediaQuery.of(context).viewInsets.bottom > 0 ? 20 : 40),
                  ],
                ),
              ),
            ),
            _buildBottomButtons(project),
          ],
        ),
      ),
    );
  }

  Widget _buildProjectHeader(String title, String desc, bool isOverdue) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: isOverdue ? AppColors.statusOverdueBg : const Color(0xFFF3EDE2),
        borderRadius: BorderRadius.circular(20),
        border: isOverdue ? Border.all(color: AppColors.statusOverdue.withOpacity(0.3)) : null,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF5A4632))),
          const SizedBox(height: 6),
          Text(desc, style: const TextStyle(fontSize: 13, color: Color(0xFF8D7A65))),
        ],
      ),
    );
  }

  Widget _buildOverdueWarning() {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
      decoration: BoxDecoration(
        color: AppColors.statusOverdueBg,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Icon(Icons.error_outline, color: AppColors.statusOverdue, size: 20),
          const SizedBox(width: 8),
          Text("마감 기한이 지났습니다!",
              style: TextStyle(color: AppColors.statusOverdue, fontWeight: FontWeight.bold, fontSize: 13)),
        ],
      ),
    );
  }

  Widget _infoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(color: Color(0xFF8D7A65))),
          Text(value, style: const TextStyle(fontWeight: FontWeight.w600, color: Color(0xFF5A4632))),
        ],
      ),
    );
  }

  Widget _buildStatusSelector() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFF3EDE2).withOpacity(0.5),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          _statusToggleButton('예정', ProjectStatus.planned, AppColors.statusPlanned),
          const SizedBox(width: 8),
          _statusToggleButton('진행중', ProjectStatus.ongoing, AppColors.statusOngoing),
          const SizedBox(width: 8),
          _statusToggleButton('완료', ProjectStatus.done, AppColors.statusDone),
        ],
      ),
    );
  }

  Widget _statusToggleButton(String text, ProjectStatus status, Color color) {
    final isSelected = _currentStatus == status;
    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() => _currentStatus = status),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(
            color: isSelected ? color : Colors.transparent,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: color),
          ),
          child: Center(
            child: Text(text,
              style: TextStyle(color: isSelected ? Colors.white : color, fontWeight: FontWeight.bold, fontSize: 13),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildMemoField() => TextField(
    controller: _memoController,
    maxLines: 5,
    decoration: InputDecoration(
      hintText: '프로젝트 관련 메모를 남길 수 있어요',
      filled: true,
      fillColor: const Color(0xFFF3EDE2).withOpacity(0.5),
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide.none),
    ),
  );

  Widget _buildBottomButtons(ProjectModel project) {
    return Container(
      color: AppColors.background,
      padding: const EdgeInsets.fromLTRB(24, 10, 24, 20),
      child: SafeArea(
        top: false,
        child: Row(
          children: [
            Expanded(
              child: OutlinedButton(
                onPressed: () => Navigator.pop(context),
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  side: const BorderSide(color: Color(0xFFB58A53)),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                child: const Text('취소', style: TextStyle(color: Color(0xFFB58A53))),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: ElevatedButton(
                onPressed: () async {
                  await context.read<ProjectViewModel>().updateProjectPartially(
                    projectId: project.id,
                    status: _currentStatus,
                    memo: _memoController.text,
                  );
                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('상태와 메모가 저장되었습니다.')),
                    );
                    Navigator.pop(context);
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFB58A53),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                child: const Text('수정', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _formatDate(DateTime date) => "${date.year}.${date.month.toString().padLeft(2, '0')}.${date.day.toString().padLeft(2, '0')}";
}