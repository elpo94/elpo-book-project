import 'package:flutter/material.dart';
import '../../../models/project.dart';
import '../../services/network_service.dart';
import '../../views/project/widgets/project_status.dart';

class ProjectCreateViewModel extends ChangeNotifier {
  // 1. 상태 관리 (컨트롤러 및 날짜 데이터)
  final titleController = TextEditingController();
  final descriptionController = TextEditingController();
  final dailyGoalController = TextEditingController();
  final periodController = TextEditingController();
  final memoController = TextEditingController();
  final NetworkService _networkService = NetworkService();

  DateTime? _startDate;
  DateTime? _endDate;

  DateTime? get startDate => _startDate;
  DateTime? get endDate => _endDate;

  final List<bool> selectedDays = List.generate(7, (_) => false);
  final List<String> days = ['월', '화', '수', '목', '금', '토', '일'];

  //네트워크 체크
  Future<bool> checkConnection() async {
    return await _networkService.isConnected();
  }


  // 2. 날짜 범위 설정
  void setDateRange(DateTimeRange range) {
    _startDate = range.start;
    _endDate = range.end;
    periodController.text = "${_formatDate(range.start)} ~ ${_formatDate(range.end)}";
    notifyListeners();
  }

  // 3. 요일 선택 및 보정 로직
  void toggleDay(int index) {
    selectedDays[index] = !selectedDays[index];
    notifyListeners();
  }

  void ensureDaysSelected() {
    final bool hasSelection = selectedDays.any((element) => element == true);

    if (!hasSelection) {
      for (int i = 0; i < selectedDays.length; i++) {
        selectedDays[i] = true;
      }
      notifyListeners();
    }
  }

  // 4. 프로젝트 모델 생성 (핵심 로직 통합)
  ProjectModel? createProjectModel() {
    ensureDaysSelected();
    if (titleController.text.trim().isEmpty || _startDate == null || _endDate == null) {
      return null;
    }

    return ProjectModel(
      id: '',
      name: titleController.text.trim(),
      description: descriptionController.text,
      startDate: _startDate!,
      endDate: _endDate!,
      selectedDays: List.from(selectedDays),
      plans: [dailyGoalController.text],
      status: ProjectStatus.planned,
      createdAt: DateTime.now(),
      memo: memoController.text,
      isFavorite: false,
    );
  }

  // 5. 유틸리티 및 초기화
  String _formatDate(DateTime date) {
    return "${date.year}.${date.month.toString().padLeft(2, '0')}.${date.day.toString().padLeft(2, '0')}";
  }

  void loadProjectDays(List<bool> projectDays) {
    // 기존 리스트를 덮어쓰지 않고 값만 복사하여 독립성 유지
    for (int i = 0; i < selectedDays.length; i++) {
      selectedDays[i] = projectDays[i];
    }
    notifyListeners();
  }

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