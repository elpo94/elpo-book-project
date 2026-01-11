// lib/models/calendar_item.dart
import 'package:flutter/foundation.dart';

/// 캘린더(달력)에서 하루에 표시될 항목의 상태.
/// - UI에서는 이 status를 기준으로 점(●) 색/배지 등을 매핑한다.
enum ProjectStatus {
  planned,     // 예정
  ongoing,  // 진행
  done,        // 완료
  overdue,     // 지연
}

extension ProjectStatusX on ProjectStatus {
  String get label => switch (this) {
    ProjectStatus.planned => '예정',
    ProjectStatus.ongoing => '진행중',
    ProjectStatus.done => '완료',
    ProjectStatus.overdue => '지연',
  };
}

/// 캘린더에 표시되는 데이터 단위.
/// - 달력 셀 하단 점(●) 표기
/// - 선택 날짜 하단 카드 리스트 출력
/// - 카드 클릭 시 상세 페이지 이동(id / projectId 기반)
@immutable
class CalendarItem {
  /// 고유 id (db key, uuid 등)
  final String id;

  /// 달력/리스트에 보이는 제목 (예: "소설 1부", "플롯 수정")
  final String title;

  /// 상세 메모/설명 (옵션)
  final String? note;

  /// 프로젝트에 귀속된 항목이면 연결 (옵션)
  final String? projectId;

  /// 항목 상태 (점/배지 표현 기준)
  final ProjectStatus status;

  /// 캘린더에서 속한 날짜
  /// - 반드시 yyyy-mm-dd normalize 상태로 저장/사용을 권장
  final DateTime date;

  const CalendarItem({
    required this.id,
    required this.title,
    required this.status,
    required this.date,
    this.note,
    this.projectId,
  });

  /// 달력 key / 비교를 위해 시간 제거 (yyyy-mm-dd로 normalize)
  static DateTime normalizeDate(DateTime d) => DateTime(d.year, d.month, d.day);

  CalendarItem copyWith({
    String? id,
    String? title,
    String? note,
    String? projectId,
    ProjectStatus? status,
    DateTime? date,
  }) {
    return CalendarItem(
      id: id ?? this.id,
      title: title ?? this.title,
      note: note ?? this.note,
      projectId: projectId ?? this.projectId,
      status: status ?? this.status,
      date: date ?? this.date,
    );
  }
}
