import 'package:flutter/material.dart';
import '../../../models/project.dart';
import './project_status.dart'; // ProjectDisplayStatus가 있는 경로
import './project_status_badge.dart';

class ProjectCard extends StatelessWidget {
  final ProjectModel project;
  final VoidCallback? onTap;

  const ProjectCard({
    super.key,
    required this.project,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    // 모델에서 지연 여부를 계산한 상태값을 가져옵니다.
    final displayStatus = project.displayStatus;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Card(
        elevation: 1,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 중복된 _Header 문제를 해결한 단일 호출
              _Header(title: project.name, displayStatus: displayStatus),
              const SizedBox(height: 6),
              _Description(text: project.description),
              const SizedBox(height: 12),
              _MetaInfo(
                routine: project.plans.isNotEmpty ? project.plans.first : '설정된 목표 없음',
                period: "${_formatDate(project.startDate)} ~ ${_formatDate(project.endDate)}",
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _formatDate(DateTime d) => "${d.year}.${d.month.toString().padLeft(2, '0')}.${d.day.toString().padLeft(2, '0')}";
}

// 🛑 에러 해결: _Header 클래스는 하나만 존재해야 합니다.
class _Header extends StatelessWidget {
  final String title;
  final ProjectDisplayStatus displayStatus;

  const _Header({required this.title, required this.displayStatus});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Text(
            title,
            style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
          ),
        ),
        // 계산된 표시 상태(지연 포함)를 뱃지에 전달
        ProjectStatusBadge(displayStatus: displayStatus),
      ],
    );
  }
}

class _Description extends StatelessWidget {
  final String text;
  const _Description({required this.text});

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      maxLines: 2,
      overflow: TextOverflow.ellipsis,
      style: TextStyle(
        fontSize: 13,
        color: Colors.black.withOpacity(0.6),
      ),
    );
  }
}

class _MetaInfo extends StatelessWidget {
  final String routine;
  final String period;

  const _MetaInfo({required this.routine, required this.period});

  @override
  Widget build(BuildContext context) {
    final mutedColor = Colors.black.withOpacity(0.5);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(routine, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500)),
        const SizedBox(height: 4),
        Text(period, style: TextStyle(fontSize: 12, color: mutedColor)),
      ],
    );
  }
}