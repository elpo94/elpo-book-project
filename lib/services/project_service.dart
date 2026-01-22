import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:sabujak_application/services/project_store.dart';
import '../models/project.dart';
import '../views/project/widgets/project_status.dart';

class ProjectService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  late final CollectionReference _projectsRef;

  ProjectService() {
    _projectsRef = _db.collection('projects').withConverter<ProjectModel>(
      fromFirestore: (snapshot, _) => ProjectModel.fromMap(snapshot.data()!, snapshot.id),
      toFirestore: (project, _) => project.toMap(),
    );
  }

  // ✅ 프로젝트 목록 가져오기 및 스토어 저장
  Future<void> fetchAndStore(ProjectStore store, {String sortBy = 'createdAt'}) async {
    bool descending = (sortBy == 'createdAt');
    final querySnapshot = await _projectsRef.orderBy(sortBy, descending: descending).get();
    final list = querySnapshot.docs.map((doc) => doc.data() as ProjectModel).toList();
    store.updateProjects(list);
  }

  // ✅ 프로젝트 전체 수정 (이미지 속 updateProject 대응)
  Future<void> updateProject(String id, Map<String, dynamic> data) async {
    await _projectsRef.doc(id).update(data);
  }

  // ✅ 프로젝트 생성
  Future<void> createProject(ProjectModel project) async {
    await _projectsRef.add(project);
  }

  // ✅ 부분 업데이트 (상태 및 메모)
  Future<void> updateProjectStatusAndMemo(String id, ProjectStatus status, String memo) async {
    await _projectsRef.doc(id).update({
      'status': status.name,
      'memo': memo,
      'updatedAt': FieldValue.serverTimestamp(),
    });
  }

  // ✅ 프로젝트 삭제
  Future<void> deleteProject(String id) async {
    await _projectsRef.doc(id).delete();
  }
}