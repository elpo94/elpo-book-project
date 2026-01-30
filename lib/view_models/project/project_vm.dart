import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';


import '../../models/project.dart';
import '../../services/project_service.dart'; // 중복 해결된 깨끗한 서비스
import '../../services/project_store.dart';
import '../../services/auth_service.dart';   // 방금 정리한 인증 서비스
import '../../views/project/widgets/project_status.dart';
import '../../widgets/confirm_dialog.dart';

class ProjectViewModel extends ChangeNotifier {
  final ProjectService _projectService = ProjectService();
  final ProjectStore _projectStore;
  final AuthService _authService = AuthService();

  bool _isLoading = false;
  final String _sortBy = 'createdAt';

  List<ProjectModel> get projects => _projectStore.projects;
  bool get isLoading => _isLoading;

  ProjectViewModel(this._projectStore) {
    _projectStore.addListener(_onStoreChanged);
    fetchProjects();
  }

  void _onStoreChanged() {
    notifyListeners();
  }

  @override
  void dispose() {
    _projectStore.removeListener(_onStoreChanged);
    super.dispose();
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

  Future<bool> _checkOnline(BuildContext context) async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult.contains(ConnectivityResult.none)) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("현재 오프라인 상태입니다. 온라인 환경에서 시도해 주세요."),
            backgroundColor: Color(0xFFD65C5C),
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
      return false;
    }
    return true;
  }


  Future<void> requestDeleteProject(BuildContext context, String projectId) async {
    if (!await _checkOnline(context)) return;

    if (context.mounted) {
      final bool confirm = await showConfirmDialog(
        context,
        title: "프로젝트 삭제",
        message: "이 프로젝트를 영구적으로 삭제하시겠습니까?",
        confirmText: "삭제",
        confirmColor: const Color(0xFFD65C5C),
      );

      if (confirm == true) {
        await deleteProject(projectId); 
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("프로젝트가 정상적으로 삭제되었습니다.")),
          );
        }
      }
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