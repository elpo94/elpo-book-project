import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:sabujak_application/services/project_store.dart';
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
    await _getProjectRef(uid).doc(project.id).set(project.toMap());
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
}