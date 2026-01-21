import 'package:cloud_firestore/cloud_firestore.dart';
import '../views/project/widgets/project_status.dart';

class ProjectModel {
  final String id;
  final String name;
  final String description;
  final DateTime startDate;
  final DateTime endDate;
  final List<String> plans;
  final ProjectStatus status;
  final DateTime createdAt;
  final bool isFavorite;
  final String memo;

  ProjectModel({
    required this.id,
    required this.name,
    required this.description,
    required this.startDate,
    required this.endDate,
    required this.plans,
    required this.status,
    required this.createdAt,
    this.isFavorite = false,
    this.memo = '',
  });

  factory ProjectModel.empty() {
    return ProjectModel(
      id: '',
      name: '',
      description: '',
      startDate: DateTime.now(),
      endDate: DateTime.now().add(const Duration(days: 30)),
      status: ProjectStatus.planned,
      plans: [],
      createdAt: DateTime.now(),
    );
  }

  ProjectDisplayStatus get displayStatus =>
      effectiveStatus(
        status: status,
        deadline: endDate,
      );

  // Firestore에서 데이터를 가져올 때 (From Map)
  factory ProjectModel.fromMap(Map<String, dynamic> map, String docId) {
    return ProjectModel(
      id: docId,
      name: map['name'] ?? '',
      description: map['description'] ?? '',
      // String으로 저장했다면 parse, Timestamp라면 toDate() 사용
      startDate: map['startDate'] is Timestamp
          ? (map['startDate'] as Timestamp).toDate()
          : DateTime.tryParse(map['startDate'] ?? '') ?? DateTime.now(),
      endDate: map['endDate'] is Timestamp
          ? (map['endDate'] as Timestamp).toDate()
          : DateTime.tryParse(map['endDate'] ?? '') ?? DateTime.now(),
      plans: List<String>.from(map['plans'] ?? []),
      status: ProjectStatus.values.firstWhere(
            (e) => e.name == map['status'],
        orElse: () => ProjectStatus.planned,
      ),
      createdAt: (map['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
      isFavorite: map['isFavorite'] ?? false,
      memo: map['memo'] ?? '', // ⭐ memo 불러오기 추가
    );
  }

  // 2. Firestore에 데이터를 저장할 때 (To Map)
  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'description': description,
      'startDate': Timestamp.fromDate(startDate),
      'endDate': Timestamp.fromDate(endDate),
      'plans': plans,
      'status': status.name,
      'createdAt': createdAt,
      'isFavorite': isFavorite,
      'memo': memo, // ⭐ memo 저장 추가
    };
  }

  // 3. 객체의 일부 값만 바꿔서 복사할 때 (Copy With)
  ProjectModel copyWith({
    String? id,
    String? name,
    String? description,
    DateTime? startDate,
    DateTime? endDate,
    List<String>? plans,
    ProjectStatus? status,
    bool? isFavorite,
    String? memo, // ⭐ memo 파라미터 추가
  }) {
    return ProjectModel(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      plans: plans ?? this.plans,
      status: status ?? this.status,
      createdAt: this.createdAt,
      // 생성일은 유지
      isFavorite: isFavorite ?? this.isFavorite,
      memo: memo ?? this.memo, // ⭐ memo 값 할당
    );
  }
}

