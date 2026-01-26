import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';


import '../../models/project.dart';
import '../../services/project_service.dart'; // 중복 해결된 깨끗한 서비스
import '../../services/project_store.dart';
import '../../services/auth_service.dart';   // 방금 정리한 인증 서비스
import '../../views/project/widgets/project_status.dart';

class ProjectViewModel extends ChangeNotifier {
  // ✅ 빨간 줄 해결: 클래스들이 위 임포트를 통해 인식됩니다.
  final ProjectService _projectService = ProjectService();
  final ProjectStore _projectStore; // 생성자에서 주입받음
  final AuthService _authService = AuthService();

  bool _isLoading = false;
  final String _sortBy = 'createdAt';

  List<ProjectModel> get projects => _projectStore.projects;
  bool get isLoading => _isLoading;

  // 생성자: 'this._projectStore' 에러 해결
  ProjectViewModel(this._projectStore) {
    fetchProjects();
  }
  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  // 1. 읽기: fetchAndStore 활용
  Future<void> fetchProjects() async {
    final uid = _authService.currentUserId;
    if (uid == null) return;

    _setLoading(true);
    try {
      await _projectService.fetchAndStore(_projectStore, uid: uid, sortBy: _sortBy);
    } catch (e) {
      debugPrint("데이터 로드 실패: $e");
    } finally {
      _setLoading(false);
    }
  }

  // 2. 추가: addProject 활용
  Future<void> addProject(ProjectModel newProject) async {
    final uid = _authService.currentUserId;
    if (uid == null) return;

    _setLoading(true);
    try {
      await _projectService.addProject(newProject, uid: uid);
      await fetchProjects();
    } catch (e) {
      debugPrint("추가 실패: $e");
    } finally {
      _setLoading(false);
    }
  }

  // 3. 전체 수정: updateProject 활용
  Future<void> updateProject({
    required String projectId,
    required String name,
    required String description,
    required DateTime startDate,
    required DateTime endDate,
    required List<String> plans,
    required ProjectStatus status,
    required String memo,
    required List<bool> selectedDays,
  }) async {
    final uid = _authService.currentUserId;
    if (uid == null) return;

    try {
      final data = {
        'name': name,
        'description': description,
        'startDate': Timestamp.fromDate(startDate),
        'endDate': Timestamp.fromDate(endDate),
        'plans': plans,
        'status': status.name,
        'memo': memo,
        'selectedDays': selectedDays,
        'updatedAt': FieldValue.serverTimestamp(),
      };

      await _projectService.updateProject(uid, projectId, data);
      await fetchProjects();
    } catch (e) {
      debugPrint("프로젝트 업데이트 실패: $e");
      rethrow;
    }
  }

  // 4. 부분 수정: updateProjectStatusAndMemo 활용
  Future<void> updateProjectPartially({
    required String projectId,
    required ProjectStatus status,
    required String memo,
  }) async {
    final uid = _authService.currentUserId;
    if (uid == null) return;

    try {
      await _projectService.updateProjectStatusAndMemo(uid, projectId, status, memo);

      final updated = projects.firstWhere((p) => p.id == projectId).copyWith(
        status: status,
        memo: memo,
      );

      if (await _projectStore.updateSingleProject(updated)) {
        notifyListeners();
      }
    } catch (e) {
      debugPrint("업데이트 실패: $e");
    }
  }

  // 5. 삭제: deleteProject 활용
  Future<void> deleteProject(String projectId) async {
    final uid = _authService.currentUserId;
    if (uid == null) return;

    try {
      await _projectService.deleteProject(uid, projectId);
      await fetchProjects();
    } catch (e) {
      debugPrint("삭제 실패: $e");
    }
  }
}