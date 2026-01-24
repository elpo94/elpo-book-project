import 'package:flutter/material.dart';
import '../../models/calendar_item.dart';
import '../../models/project.dart';
import '../../services/project_service.dart';
import '../../services/project_store.dart';
import '../../services/auth_service.dart'; // ✅ AuthService 추가
import '../../views/project/widgets/project_status.dart';

class ScheduleVM extends ChangeNotifier {
  final ProjectService _service = ProjectService();
  final ProjectStore _projectStore;
  final AuthService _authService = AuthService(); // ✅ 익명 로그인 주체

  DateTime focusedDay = DateTime.now();
  DateTime selectedDay = DateTime.now();

  ScheduleVM(this._projectStore) {
    _projectStore.addListener(_onStoreChanged);
    loadData(); // 초기 데이터 로드
  }

  List<ProjectModel> get _allProjects => _projectStore.projects;

  void _onStoreChanged() {
    notifyListeners();
  }

  // ✅ 데이터를 불러올 때도 현재 유저의 UID가 필요합니다.
  Future<void> loadData() async {
    final uid = _authService.currentUserId;
    if (uid == null) return; // UID가 없으면 대참사 방지

    try {
      // 서비스 레이어의 fetchAndStore 명칭과 인자에 맞게 uid를 전달합니다.
      await _service.fetchAndStore(_projectStore, uid: uid);
    } catch (e) {
      debugPrint("스케줄 데이터 로드 실패: $e");
    }
  }

  // ... (itemsOf, projectsInSelectedDay, selectDay 등 기존 로직은 유지)

  @override
  void dispose() {
    _projectStore.removeListener(_onStoreChanged);
    super.dispose();
  }
}