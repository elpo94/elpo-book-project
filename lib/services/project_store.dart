// lib/services/project_store.dart
import 'package:flutter/material.dart';
import '../models/project.dart';
import 'project_service.dart';

class ProjectStore extends ChangeNotifier {
  final ProjectService _service = ProjectService();
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

  //  3. 서버 데이터 가져오기 및 저장 통합 메소드
  Future<void> fetchAndStore(String uid) async {
    if (uid.isEmpty) return;
    try {
      await _service.fetchAndStore(this, uid: uid);
    } catch (e) {
      debugPrint("Store 데이터 동기화 실패: $e");
    }
  }

  Future<void> clearAll(String uid) async {
    try {
      // 1. 서비스에게 서버와 로컬 데이터를 다 지우라고 시킵니다.
      await _service.clearAllUserData(
          uid, this); // 'this'를 넘겨 Store의 리스트도 비우게 함

      // 2. 이미 서비스 안에서 store.updateProjects([])를 호출하겠지만,
      // 여기서 한 번 더 확실히 상태를 알릴 수 있습니다.
      notifyListeners();
    } catch (e) {
      debugPrint("데이터 초기화 실패: $e");
    }
  }
}