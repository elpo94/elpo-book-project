import 'package:flutter/material.dart';
import '../../models/calendar_item.dart';
import '../../models/project.dart';
import '../../services/project_service.dart';
import '../../services/project_store.dart';
import '../../views/project/widgets/project_status.dart';

class ScheduleVM extends ChangeNotifier {
  final ProjectService _service = ProjectService();
  final ProjectStore _projectStore;

  DateTime focusedDay = DateTime.now();
  DateTime selectedDay = DateTime.now();

  ScheduleVM(this._projectStore) {
    _projectStore.addListener(_onStoreChanged);
    loadData();
  }

  List<ProjectModel> get _allProjects => _projectStore.projects;

  void _onStoreChanged() {
    notifyListeners();
  }

  Future<void> loadData() async {
    await _service.fetchAndStore(_projectStore);
  }

  List<CalendarItem> itemsOf(DateTime day) {
    final targetDay = DateUtils.dateOnly(day);
    final today = DateUtils.dateOnly(DateTime.now());

    return _projectStore.projects.where((p) {
      final start = DateUtils.dateOnly(p.startDate);
      final end = DateUtils.dateOnly(p.endDate);

      final isInRange = (targetDay.isAtSameMomentAs(start) || targetDay.isAfter(start)) &&
          (targetDay.isAtSameMomentAs(end) || targetDay.isBefore(end));

      final isOverdueAndVisibleToday = targetDay.isAtSameMomentAs(today) &&
          end.isBefore(today) &&
          p.status != ProjectStatus.done;

      return isInRange || isOverdueAndVisibleToday;
    }).map((p) => CalendarItem(
      id: p.id,
      title: p.name,
      status: p.status,
      date: p.endDate,
      projectId: p.id,
      note: p.memo,
    )).toList();
  }

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

  @override
  void dispose() {
    _projectStore.removeListener(_onStoreChanged);
    super.dispose();
  }
}