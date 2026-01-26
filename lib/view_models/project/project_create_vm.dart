import 'package:flutter/material.dart';
import '../../../models/project.dart';
import '../../views/project/widgets/project_status.dart';

class ProjectCreateViewModel extends ChangeNotifier {
  // 1. 상태 관리 (데이터)
  final titleController = TextEditingController();
  final descriptionController = TextEditingController();
  final dailyGoalController = TextEditingController();
  final periodController = TextEditingController();
  final memoController = TextEditingController();

  DateTime? _startDate;
  DateTime? _endDate;

  DateTime? get startDate => _startDate;
  DateTime? get endDate => _endDate;

  final List<bool> selectedDays = List.generate(7, (_) => false);
  final List<String> days = ['월', '화', '수', '목', '금', '토', '일'];

  // 2. 비즈니스 로직: 날짜 범위 설정 (하나로 통합) ⭐
  void setDateRange(DateTimeRange range) {
    _startDate = range.start;
    _endDate = range.end;

    // 화면에 표시될 텍스트 업데이트
    periodController.text = "${_formatDate(range.start)} ~ ${_formatDate(range.end)}";

    notifyListeners();
  }

  // 3. 비즈니스 로직: 요일 선택
  void toggleDay(int index) {
    selectedDays[index] = !selectedDays[index];
    notifyListeners();
  }

  String _formatDate(DateTime date) {
    return "${date.year}.${date.month.toString().padLeft(2, '0')}.${date.day.toString().padLeft(2, '0')}";
  }

  // 4. 비즈니스 로직: 초기화
  void clearFields() {
    titleController.clear();
    descriptionController.clear();
    dailyGoalController.clear();
    periodController.clear();
    memoController.clear();
    _startDate = null;
    _endDate = null;
    for (int i = 0; i < selectedDays.length; i++) {
      selectedDays[i] = false;
    }
    notifyListeners();
  }

  // 5. 비즈니스 로직: 프로젝트 모델 생성 ⭐ (에러 수정됨)
  ProjectModel? createProjectModel() {
    if (titleController.text.isEmpty || _startDate == null || _endDate == null) return null;

    return ProjectModel(
      id: '', // 👈 Firestore가 생성할 것이므로 일단 비워둡니다.
      name: titleController.text,
      description: descriptionController.text,
      startDate: _startDate!,
      endDate: _endDate!,
      status: ProjectStatus.planned,
      plans: [dailyGoalController.text],
      createdAt: DateTime.now(),
      memo: memoController.text,
    );
  }

  @override
  void dispose() {
    titleController.dispose();
    descriptionController.dispose();
    dailyGoalController.dispose();
    periodController.dispose();
    memoController.dispose();
    super.dispose();
  }
}