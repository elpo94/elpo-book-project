import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomeViewModel extends ChangeNotifier {
  // 데이터 변수들
  String _todayPlan = "오늘의 목표를 설정하세요";
  int _targetTime = 0; // 목표 시간 (분 단위)
  String _planMemo = "";

  String get todayPlan => _todayPlan;

  int get targetTime => _targetTime;

  String get planMemo => _planMemo;

  HomeViewModel() {
    _loadAllData();
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