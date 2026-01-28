import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../models/project.dart';
import '../../services/auth_service.dart';
import '../../services/project_service.dart';
import '../../services/project_store.dart';
import '../../views/project/widgets/project_status.dart';

class HomeViewModel extends ChangeNotifier {
  final ProjectStore _projectStore;
  final ProjectService _projectService = ProjectService();
  final AuthService _authService = AuthService();

  String _todayPlan = "오늘의 목표를 설정하세요";
  int _targetTime = 0;
  String _planMemo = "";

  //
  HomeViewModel(this._projectStore) {
    _projectStore.addListener(_onStoreChanged);
    _loadAllData();
    _initialize();
  }

  String get todayPlan => _todayPlan;
  int get targetTime => _targetTime;
  String get planMemo => _planMemo;

  void _onStoreChanged() {
    notifyListeners();
  }

  Future<void> _initialize() async {
    try {
      final String? uid = _authService.currentUserId;
      if (uid != null && uid.isNotEmpty && _projectStore.projects.isEmpty) {
        await _projectStore.fetchAndStore(uid);
      }
    } catch (e) {
      debugPrint("HomeViewModel 초기화 오류: $e");
    }
  }

  void _onProjectStoreChanged() {
    notifyListeners(); //
  }

  @override
  void dispose() {
    _projectStore.removeListener(_onProjectStoreChanged);
    super.dispose();
  }


  List<ProjectModel> get ongoingProjects {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);

    return _projectStore.projects.where((project) {
      final isWithinRange = (project.startDate.isBefore(today) || project.startDate.isAtSameMomentAs(today)) &&
          (project.endDate.isAfter(today) || project.endDate.isAtSameMomentAs(today));

      final isUnfinishedOverdue = project.endDate.isBefore(today) && project.status != ProjectStatus.done;

      return isWithinRange || isUnfinishedOverdue;
    }).toList();
  }

  // 모든 데이터 로드
  Future<void> _loadAllData() async {
    final prefs = await SharedPreferences.getInstance();
    _todayPlan = prefs.getString('today_plan') ?? "오늘의 목표를 설정하세요";
    _targetTime = prefs.getInt('target_time') ?? 0;
    _planMemo = prefs.getString('plan_memo') ?? "";
    notifyListeners();
  }

  // 통합 저장 로직
  Future<void> updateAllPlanData({
    required String plan,
    required int time,
    required String memo,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('today_plan', plan);
    await prefs.setInt('target_time', time);
    await prefs.setString('plan_memo', memo);

    _todayPlan = plan;
    _targetTime = time;
    _planMemo = memo;
    notifyListeners();
  }
}