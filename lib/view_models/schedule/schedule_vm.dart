import 'package:flutter/material.dart';
import '../../models/calendar_item.dart';
import '../../models/project.dart';
import '../../services/project_service.dart';
import '../../services/project_store.dart';
import '../../services/auth_service.dart';
import '../../views/project/widgets/project_status.dart';

class ScheduleVM extends ChangeNotifier {
  final ProjectService _service = ProjectService();
  final ProjectStore _projectStore;
  final AuthService _authService = AuthService();

  DateTime focusedDay = DateTime.now();
  DateTime selectedDay = DateTime.now();

  ScheduleVM(this._projectStore) {
    _projectStore.addListener(_onStoreChanged);
    loadData();
  }

  void _onStoreChanged() {
    notifyListeners();
  }

  // ✅ 1. 데이터 로드 로직 (UID 확인 필수)
  Future<void> loadData() async {
    final uid = _authService.currentUserId;
    if (uid == null) return;

    try {
      await _service.fetchAndStore(_projectStore, uid: uid);
    } catch (e) {
      debugPrint("스케줄 데이터 로드 실패: $e");
    }
  }

  // ✅ 2. CalendarWidget이 간절히 찾고 있는 itemsOf 게터(또는 메서드)
  List<CalendarItem> itemsOf(DateTime day) {
    final targetDay = DateUtils.dateOnly(day);
    return _projectStore.projects.where((p) {
      final start = DateUtils.dateOnly(p.startDate);
      final end = DateUtils.dateOnly(p.endDate);
      // 프로젝트 기간 내에 해당 날짜가 포함되는지 확인
      return (targetDay.isAtSameMomentAs(start) || targetDay.isAfter(start)) &&
          (targetDay.isAtSameMomentAs(end) || targetDay.isBefore(end));
    }).map((p) => CalendarItem(
      id: p.id,
      title: p.name,
      status: p.status,
      date: p.endDate,
      projectId: p.id,
      note: p.memo,
    )).toList();
  }

  // ✅ 3. CalendarWidget이 찾고 있는 selectDay 메서드
  void selectDay(DateTime selected, DateTime focused) {
    selectedDay = selected;
    focusedDay = focused;
    notifyListeners();
  }

  @override
  void dispose() {
    _projectStore.removeListener(_onStoreChanged);
    super.dispose();
  }
}