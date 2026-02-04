import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:sabujak_application/services/project_store.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/project.dart';
import '../views/project/widgets/project_status.dart';


class ProjectService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  CollectionReference _getProjectRef(String uid) {
    return _db.collection('users').doc(uid).collection('projects');
  }

  Future<void> addProject(ProjectModel project, {required String uid}) async {
    await _getProjectRef(uid).doc().set(project.toMap());
  }

  Future<void> fetchAndStore(ProjectStore store, {required String uid, String sortBy = 'createdAt'}) async {
    final snapshot = await _db.collection('users').doc(uid).collection('projects').orderBy(sortBy).get();
    final list = snapshot.docs.map((doc) =>
        ProjectModel.fromMap(doc.data() as Map<String, dynamic>, doc.id)).toList();
    store.updateProjects(list);
  }

  Future<void> updateProject(String uid, String projectId, Map<String, dynamic> data) async {
    await _getProjectRef(uid).doc(projectId).update(data);
  }

  Future<void> updateProjectStatusAndMemo(String uid, String projectId, ProjectStatus status, String memo) async {
    await _getProjectRef(uid).doc(projectId).update({
      'status': status.name,
      'memo': memo,
      'updatedAt': FieldValue.serverTimestamp(),
    });
  }

  Future<void> deleteProject(String uid, String projectId) async {
    await _getProjectRef(uid).doc(projectId).delete();
  }

  Future<void> clearAllUserData(String uid, ProjectStore store) async {
    final snapshot = await _getProjectRef(uid).get();
    final batch = _db.batch();
    for (var doc in snapshot.docs) {
      batch.delete(doc.reference);
    }
    await batch.commit();

    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();

    store.updateProjects([]);
  }
}