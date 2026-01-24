// lib/services/project_store.dart
import 'package:flutter/material.dart';
import '../models/project.dart';
import 'project_service.dart'; // ✅ 서비스를 임포트해야 합니다.

class ProjectStore extends ChangeNotifier {
  final ProjectService _service = ProjectService(); // ✅ 서비스 인스턴스 생성
  List<ProjectModel> _projects = [];

  List<ProjectModel> get projects => _projects;

  // 1. 전체 데이터 업데이트 (벨 울림)
  void updateProjects(List<ProjectModel> newProjects) {
    _projects = newProjects;
    notifyListeners();
  }

  // 2. 단일 데이터 업데이트
  Future<bool> updateSingleProject(ProjectModel updated) async {
    final index = _projects.indexWhere((p) => p.id == updated.id);
    if (index != -1) {
      _projects[index] = updated;
      notifyListeners();
      return true;
    }
    return false;
  }

  // ✅ 3. 서버 데이터 가져오기 및 저장 통합 메소드
  Future<void> fetchAndStore() async {
    try {
      await _service.fetchAndStore(this, uid: '');
    } catch (e) {
      debugPrint("Store 데이터 동기화 실패: $e");
    }
  }
}