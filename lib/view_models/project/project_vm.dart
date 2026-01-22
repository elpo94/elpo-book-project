
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../../models/project.dart';
import '../../services/project_service.dart';
import '../../services/project_store.dart';
import '../../views/project/widgets/project_status.dart';

class ProjectViewModel extends ChangeNotifier {
  final ProjectService _projectService = ProjectService();
  final ProjectStore _projectStore; // 중앙 서류함을 주입받습니다.

  bool _isLoading = false;
  String _sortBy = 'createdAt';

  // 이제 데이터는 내 리스트가 아니라 Store의 리스트를 보여줍니다.
  List<ProjectModel> get projects => _projectStore.projects;
  bool get isLoading => _isLoading;

  // 생성자에서 Store를 전달받습니다. (Provider의 ProxyProvider 등 활용)
  ProjectViewModel(this._projectStore) {
    fetchProjects();
  }

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  // 기존 getProjects 호출 대신 서비스의 fetchAndStore를 사용합니다.
  Future<void> fetchProjects() async {
    _setLoading(true);
    try {
      // 서비스가 데이터를 긁어와서 Store(서류함)에 자동으로 채워넣습니다.
      await _projectService.fetchAndStore(_projectStore, sortBy: _sortBy);
    } catch (e) {
      debugPrint("데이터 로드 실패: $e");
    } finally {
      _setLoading(false);
    }
  }

  Future<void> addProject(ProjectModel newProject) async {
    _setLoading(true);
    try {
      // 1. 서버에 추가
      await _projectService.createProject(newProject);
      // 2. 추가 성공 후, 서비스가 서버 데이터를 가져와서 Store(서류함)에 붓게 합니다.
      await _projectService.fetchAndStore(_projectStore);
    } catch (e) {
      debugPrint("추가 실패: $e");
    } finally {
      _setLoading(false);
    }
  }

  Future<void> updateProject({
    required String projectId,
    required String name,
    required String description,
    required DateTime startDate,
    required DateTime endDate,
    required List<String> plans,
    required ProjectStatus status,
    required String memo,
  }) async {
    try {
      // 1. 서버에 보낼 데이터 뭉치 만들기
      final data = {
        'name': name,
        'description': description,
        'startDate': Timestamp.fromDate(startDate),
        'endDate': Timestamp.fromDate(endDate),
        'plans': plans,
        'status': status.name,
        'memo': memo,
        'updatedAt': FieldValue.serverTimestamp(),
      };

      // 2. 서비스를 통해 서버 업데이트
      await _projectService.updateProject(projectId, data);

      // 3. 서버 성공 후 중앙 서류함(Store)의 데이터도 즉시 갱신 (스무스한 전환)
      await fetchProjects();
    } catch (e) {
      debugPrint("프로젝트 업데이트 실패: $e");
      rethrow;
    }
  }

  // 부분 업데이트 (상세 페이지용)
  Future<void> updateProjectPartially({
    required String projectId,
    required ProjectStatus status,
    required String memo,
  }) async {
    try {
      // 1. 서버 업데이트 시도
      await _projectService.updateProjectStatusAndMemo(projectId, status, memo);

      // 2. 서버 성공 후 Store의 메모리 데이터만 즉시 교체 (스무스한 갈아끼우기)
      final updated = projects.firstWhere((p) => p.id == projectId).copyWith(
        status: status,
        memo: memo,
      );
      _projectStore.updateSingleProject(updated);
    } catch (e) {
      debugPrint("업데이트 실패: $e");
    }
  }

  // 삭제 로직
  Future<void> deleteProject(String projectId) async {
    try {
      await _projectService.deleteProject(projectId);
      await fetchProjects(); // 삭제 후 Store 최신화
    } catch (e) {
      debugPrint("삭제 실패: $e");
    }
  }
}