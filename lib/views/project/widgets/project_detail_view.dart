import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../models/project.dart';
import '../../../view_models/project/project_vm.dart';
import '../../../theme/app_colors.dart';
import 'project_status.dart'; // ProjectDisplayStatus가 정의된 곳

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

    // 1. 초기 상태 설정
    if (!_isInitialized) {
      _currentStatus = project.status;
      // _memoController.text = project.memo ?? ''; // 메모 필드 연동 시 주석 해제
      _isInitialized = true;
    }

    // 2. 표시용 상태 계산 (지연 여부 확인)
    final dStatus = project.displayStatus;
    final bool isOverdue = dStatus == ProjectDisplayStatus.overdue;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text("사부작", style: TextStyle(color: AppColors.foreground, fontWeight: FontWeight.bold)),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: AppColors.foreground),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(28),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 매개변수 3개로 수정 (이름, 설명, 지연여부)
            _buildProjectHeader(project.name, project.description, isOverdue),
            const SizedBox(height: 24),

            _infoRow('하루 목표', project.plans.isNotEmpty ? project.plans.first : '설정 없음'),
            _infoRow('작성 기간', "${_formatDate(project.startDate)} ~ ${_formatDate(project.endDate)}"),

            const SizedBox(height: 32),

            // 지연 상태일 때만 나타나는 경고 문구
            if (isOverdue) _buildOverdueWarning(),

            const Text('프로젝트 상태', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 15)),
            const SizedBox(height: 12),

            _buildStatusSelector(),

            const SizedBox(height: 32),
            const Text('메모', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 15)),
            const SizedBox(height: 10),
            _buildMemoField(),

            const Spacer(),
            _buildBottomButtons(),
          ],
        ),
      ),
    );
  }

  // --- 헬퍼 메서드 (에러 해결 핵심) ---

  // Header에 지연 상태 배경색 적용
  Widget _buildProjectHeader(String title, String desc, bool isOverdue) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: isOverdue ? AppColors.statusOverdueBg : const Color(0xFFF3EDE2),
        borderRadius: BorderRadius.circular(20),
        border: isOverdue ? Border.all(color: AppColors.statusOverdue.withValues(alpha: 0.3)) : null,
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

  // 지연 시 경고 위젯 추가
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
        color: const Color(0xFFF3EDE2).withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          _statusToggleButton('예정', ProjectStatus.planned, Colors.orange),
          const SizedBox(width: 8),
          _statusToggleButton('진행중', ProjectStatus.ongoing, Colors.blue),
          const SizedBox(width: 8),
          _statusToggleButton('완료', ProjectStatus.done, Colors.green),
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
      fillColor: const Color(0xFFF3EDE2).withValues(alpha: 0.5),
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide.none),
    ),
  );

  Widget _buildBottomButtons() {
    return Row(
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
            onPressed: () {
              // TODO: 업데이트 로직 연결
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFB58A53),
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
            child: const Text('수정', style: TextStyle(color: Colors.white)),
          ),
        ),
      ],
    );
  }

  String _formatDate(DateTime date) => "${date.year}.${date.month.toString().padLeft(2, '0')}.${date.day.toString().padLeft(2, '0')}";
}