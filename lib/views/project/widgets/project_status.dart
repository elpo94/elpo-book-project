import 'package:flutter/material.dart';
import '../../../theme/app_colors.dart';

/// 저장되는 상태 (DB/모델에 저장)
enum ProjectStatus {
  planned,   // 예정(시작 전)
  ongoing,   // 진행중
  done,      // 완료
}

/// UI 표시용 상태 (지연 포함)
enum ProjectDisplayStatus {
  planned,
  ongoing,
  done,
  overdue, // 지연
}

extension ProjectStatusX on ProjectStatus {
  String get label => switch (this) {
    ProjectStatus.planned => '예정',
    ProjectStatus.ongoing => '진행중',
    ProjectStatus.done => '완료',
  };

  Color get color => switch (this) {
    ProjectStatus.planned => AppColors.statusPlanned,
    ProjectStatus.ongoing => AppColors.statusOngoing,
    ProjectStatus.done => AppColors.statusDone,
  };

  Color get backgroundColor => switch (this) {
    ProjectStatus.planned => AppColors.statusPlannedBg,
    ProjectStatus.ongoing => AppColors.statusOngoingBg,
    ProjectStatus.done => AppColors.statusDoneBg,
  };
}

extension ProjectDisplayStatusX on ProjectDisplayStatus {
  String get label => switch (this) {
    ProjectDisplayStatus.planned => '예정',
    ProjectDisplayStatus.ongoing => '진행중',
    ProjectDisplayStatus.done => '완료',
    ProjectDisplayStatus.overdue => '지연',
  };

  Color get color => switch (this) {
    ProjectDisplayStatus.planned => AppColors.statusPlanned,
    ProjectDisplayStatus.ongoing => AppColors.statusOngoing,
    ProjectDisplayStatus.done => AppColors.statusDone,
    ProjectDisplayStatus.overdue => AppColors.statusOverdue,
  };

  Color get backgroundColor => switch (this) {
    ProjectDisplayStatus.planned => AppColors.statusPlannedBg,
    ProjectDisplayStatus.ongoing => AppColors.statusOngoingBg,
    ProjectDisplayStatus.done => AppColors.statusDoneBg,
    ProjectDisplayStatus.overdue => AppColors.statusOverdueBg,
  };
}

/// overdue는 저장 상태가 아니라 "표시 상태"로 파생한다.
ProjectDisplayStatus effectiveStatus({
  required ProjectStatus status,
  required DateTime? deadline,
  DateTime? now,
}) {
  final today = now ?? DateTime.now();

  // deadline 없는 프로젝트는 지연 개념 없음
  if (deadline == null) {
    return switch (status) {
      ProjectStatus.planned => ProjectDisplayStatus.planned,
      ProjectStatus.ongoing => ProjectDisplayStatus.ongoing,
      ProjectStatus.done => ProjectDisplayStatus.done,
    };
  }

  final deadlineDay = DateTime(deadline.year, deadline.month, deadline.day);
  final todayDay = DateTime(today.year, today.month, today.day);

  final isOverdue = deadlineDay.isBefore(todayDay) && status != ProjectStatus.done;

  if (isOverdue) return ProjectDisplayStatus.overdue;

  return switch (status) {
    ProjectStatus.planned => ProjectDisplayStatus.planned,
    ProjectStatus.ongoing => ProjectDisplayStatus.ongoing,
    ProjectStatus.done => ProjectDisplayStatus.done,
  };
}
