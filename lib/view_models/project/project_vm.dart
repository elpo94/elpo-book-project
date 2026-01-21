import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../../models/project.dart';
import '../../services/project_service.dart';
import '../../views/project/widgets/project_status.dart';

class ProjectViewModel extends ChangeNotifier {
  final ProjectService _projectService = ProjectService();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // 1. 상태 관리 변수 (중복 제거 완료)
  List<ProjectModel> _projects = [];
  bool _isLoading = false;
  String _sortBy = 'createdAt';

  // 2. Getters
  List<ProjectModel> get projects => _projects;
  bool get isLoading => _isLoading;
  String get sortBy => _sortBy;

  // 3. 프로젝트 목록 로드
  Future<void> fetchProjects() async {
    _setLoading(true);
    try {
      _projects = await _projectService.getProjects(sortBy: _sortBy);
    } catch (e) {
      debugPrint("목표 로드 실패: $e");
      rethrow;
    } finally {
      _setLoading(false);
    }
  }

  // 4. 프로젝트 생성 (통합 로직)
  Future<void> addProject(ProjectModel newProject) async {
    _setLoading(true);
    try {
      final docRef = await _firestore.collection('projects').add(newProject.toMap());
      final projectWithId = newProject.copyWith(id: docRef.id);

      _projects.insert(0, projectWithId);

      debugPrint("프로젝트 저장 완료: ${docRef.id}");
    } catch (e) {
      debugPrint("프로젝트 저장 실패: $e");
      rethrow;
    } finally {
      _setLoading(false);
    }
  }

  // 5. 정렬 기준 변경
  Future<void> updateSorting(String newSortBy) async {
    if (_sortBy == newSortBy) return;
    _sortBy = newSortBy;
    await fetchProjects();
  }

  // 6. 즐겨찾기 토글
  Future<void> toggleFavorite(ProjectModel project) async {
    try {
      await _projectService.toggleFavorite(project.id, project.isFavorite);
      await fetchProjects();
    } catch (e) {
      rethrow;
    }
  }

  // 로딩 상태 업데이트 공통 함수 (괄호 닫기 에러 해결)
  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }
  void deleteProject(String projectId) {
    _projects.removeWhere((p) => p.id == projectId);
    // Firestore 연동 중이라면 여기서 await _db.collection('projects').doc(projectId).delete();
    notifyListeners();
  }

  // lib/view_models/project/project_vm.dart

// ... 기존 fetchProjects, addProject 등은 유지 ...

  // 🚀 모든 필드를 수정할 수 있는 단일 통합 메서드
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
    _setLoading(true);
    try {
      // 1. Firestore 서버 데이터 업데이트
      await _firestore.collection('projects').doc(projectId).update({
        'name': name,
        'description': description,
        'startDate': startDate.toIso8601String(),
        'endDate': endDate.toIso8601String(),
        'plans': plans,
        'status': status.name,
        'memo': memo, // ⭐ DB에 메모 저장
        'updatedAt': FieldValue.serverTimestamp(),
      });

      // 2. 로컬 리스트(_projects) 동기화
      final index = _projects.indexWhere((p) => p.id == projectId);
      if (index != -1) {
        _projects[index] = _projects[index].copyWith(
          id: projectId,
          name: name,
          description: description,
          startDate: startDate,
          endDate: endDate,
          plans: plans,
          status: status,
          // ⭐ memo 필드가 모델에 있다면 여기에 추가하세요.
          // memo: memo,
        );
        notifyListeners(); // UI에 변경 알림
      }
      debugPrint("업데이트 성공: $projectId");
    } catch (e) {
      debugPrint("업데이트 실패: $e");
      rethrow;
    } finally {
      _setLoading(false);
    }
  }
  Future<void> updateProjectPartially({
    required String projectId,
    required ProjectStatus status,
    required String memo,
  }) async {
    try {
      // 1. 리스트에서 해당 프로젝트 찾기
      final index = _projects.indexWhere((p) => p.id == projectId);

      if (index != -1) {
        // 2. 해당 필드만 교체 (기존 데이터 복사하며 일부만 변경)
        _projects[index] = _projects[index].copyWith(
          status: status,
          memo: memo,
        );

        // TODO: Firebase 사용 시 여기서도 업데이트 로직 필요
        // await _db.collection('projects').doc(projectId).update({
        //   'status': status.name,
        //   'memo': memo,
        // });

        notifyListeners(); // UI에 변경 사실 알림
      }
    } catch (e) {
      debugPrint("부분 업데이트 실패: $e");
    }
  }

}