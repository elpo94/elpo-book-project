import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/project.dart';

class ProjectService {
  // 1. Firestore 인스턴스 초기화
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  late final CollectionReference _projectsRef;

  ProjectService() {
    _projectsRef = _db.collection('projects').withConverter<ProjectModel>(
      // ✅ fromMap -> fromFirestore로 변경
      fromFirestore: (snapshot, _) =>
          ProjectModel.fromMap(snapshot.data()!, snapshot.id),
      // ✅ toMap -> toFirestore로 변경
      toFirestore: (project, _) => project.toMap(),
    );
  }

  // 2. 프로젝트 생성 (Create)
  Future<void> createProject(ProjectModel project) async {
    try {
      await _projectsRef.add(project);
    } catch (e) {
      throw Exception('프로젝트 생성 실패: $e');
    }
  }

  // 3. 프로젝트 목록 가져오기 (Read - 정렬 포함)
  // sortBy: 'createdAt' (생성순), 'endDate' (임박순)
  Future<List<ProjectModel>> getProjects({String sortBy = 'createdAt'}) async {
    try {
      // 생성순은 내림차순(최신순), 임박순은 오름차순(가까운순)으로 정렬
      bool descending = (sortBy == 'createdAt');

      QuerySnapshot querySnapshot = await _projectsRef
          .orderBy(sortBy, descending: descending)
          .get();

      return querySnapshot.docs.map((doc) => doc.data() as ProjectModel).toList();
    } catch (e) {
      throw Exception('목록 로드 실패: $e');
    }
  }

  // 4. 즐겨찾기 상태 변경 (Update)
  Future<void> toggleFavorite(String docId, bool currentStatus) async {
    try {
      await _projectsRef.doc(docId).update({
        'isFavorite': !currentStatus,
      });
    } catch (e) {
      throw Exception('즐겨찾기 업데이트 실패: $e');
    }
  }

  // 5. 프로젝트 삭제 (Delete)
  Future<void> deleteProject(String docId) async {
    try {
      await _projectsRef.doc(docId).delete();
    } catch (e) {
      throw Exception('프로젝트 삭제 실패: $e');
    }
  }
}