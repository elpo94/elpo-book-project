import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:sabujak_application/services/project_store.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/project.dart';
import '../views/project/widgets/project_status.dart';

// lib/services/project_service.dart

class ProjectService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  // 유저별 고유 경로: users/{uid}/projects
  CollectionReference _getProjectRef(String uid) {
    return _db.collection('users').doc(uid).collection('projects');
  }

  // 1. 추가 (addProject로 통일)
  Future<void> addProject(ProjectModel project, {required String uid}) async {
    await _getProjectRef(uid).doc().set(project.toMap());
  }

  // 2. 읽기 (fetchAndStore로 통일)
  Future<void> fetchAndStore(ProjectStore store, {required String uid, String sortBy = 'createdAt'}) async {
    final snapshot = await _db.collection('users').doc(uid).collection('projects').orderBy(sortBy).get();
    final list = snapshot.docs.map((doc) =>
        ProjectModel.fromMap(doc.data() as Map<String, dynamic>, doc.id)).toList();
    store.updateProjects(list);
  }

  // 3. 전체 수정 (updateProject)
  Future<void> updateProject(String uid, String projectId, Map<String, dynamic> data) async {
    await _getProjectRef(uid).doc(projectId).update(data);
  }

  // 4. 부분 수정 (updateProjectStatusAndMemo)
  Future<void> updateProjectStatusAndMemo(String uid, String projectId, ProjectStatus status, String memo) async {
    await _getProjectRef(uid).doc(projectId).update({
      'status': status.name,
      'memo': memo,
      'updatedAt': FieldValue.serverTimestamp(),
    });
  }

  // 5. 삭제 (deleteProject)
  Future<void> deleteProject(String uid, String projectId) async {
    await _getProjectRef(uid).doc(projectId).delete();
  }

  // ✅ 6. 전체 데이터 초기화 (신규 추가)
  Future<void> clearAllUserData(String uid, ProjectStore store) async {
    // 1️⃣ Firestore 데이터 일괄 삭제
    final snapshot = await _getProjectRef(uid).get();
    final batch = _db.batch();
    for (var doc in snapshot.docs) {
      batch.delete(doc.reference);
    }
    await batch.commit();

    // 2️⃣ 로컬 설정값(SharedPreferences) 전체 삭제
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear(); // 👈 오늘의 목표, 타이머 기본값 등이 모두 날아갑니다.

    // 3️⃣ 메모리(ProjectStore) 동기화
    store.updateProjects([]);
  }
}