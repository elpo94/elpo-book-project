import 'package:flutter/material.dart';
import '../../models/calendar_item.dart';
import '../../models/project.dart';
import '../../services/project_service.dart';
import '../../services/project_store.dart';

class ScheduleVM extends ChangeNotifier {
  final ProjectService _service = ProjectService();
  final ProjectStore _projectStore; // ✅ 서류함 추가

  DateTime focusedDay = DateTime.now();
  DateTime selectedDay = DateTime.now();

  // ✅ 생성자에서 Store를 받습니다.
  ScheduleVM(this._projectStore) {
    loadData();
  }

  // 이제 내부에 리스트를 따로 두지 않고 Store의 것을 가져다 씁니다.
  List<ProjectModel> get _allProjects => _projectStore.projects;

  Future<void> loadData() async {
    // 직접 getProjects()를 호출하지 않고 서비스가 Store에 채우게 시킵니다.
    await _service.fetchAndStore(_projectStore);
  }

  List<CalendarItem> itemsOf(DateTime day) {
    final targetDay = DateTime(day.year, day.month, day.day); // 시간 오차 제거

    return _projectStore.projects
        .where((p) {
      // ✅ 종료일만 체크하는 대신, 시작일과 종료일 사이인지 확인합니다.
      final start = DateTime(p.startDate.year, p.startDate.month, p.startDate.day);
      final end = DateTime(p.endDate.year, p.endDate.month, p.endDate.day);

      return (targetDay.isAtSameMomentAs(start) || targetDay.isAfter(start)) &&
          (targetDay.isAtSameMomentAs(end) || targetDay.isBefore(end));
    })
        .map((p) => CalendarItem(
      id: p.id,
      title: p.name,
      status: p.status,
      date: p.endDate, // 리스트 표시용 날짜
      projectId: p.id,
    ))
        .toList();
  }

  // 선택된 날짜에 진행 중인 프로젝트 필터링
  List<ProjectModel> get projectsInSelectedDay {
    return _allProjects.where((p) {
      final start = DateUtils.dateOnly(p.startDate);
      final end = DateUtils.dateOnly(p.endDate);
      final target = DateUtils.dateOnly(selectedDay);
      return (target.isAtSameMomentAs(start) || target.isAfter(start)) &&
          (target.isAtSameMomentAs(end) || target.isBefore(end));
    }).toList();
  }

  void selectDay(DateTime selected, DateTime focused) {
    selectedDay = selected;
    focusedDay = focused;
    notifyListeners();
  }
}

// 두 날짜가 같은 날인지 확인 (시간 제외)
bool isSameDay(DateTime? a, DateTime? b) {
  if (a == null || b == null) return false;
  return a.year == b.year && a.month == b.month && a.day == b.day;
}