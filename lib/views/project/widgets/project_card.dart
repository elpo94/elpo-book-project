import 'package:elpo_book_project/views/project/widgets/project_status.dart';
import 'package:elpo_book_project/views/project/widgets/project_status_badge.dart';
import 'package:flutter/material.dart';

class ProjectCard extends StatelessWidget {
  final String title;
  final String description;
  final String period;
  final String routine;
  final ProjectStatus status;
  final VoidCallback? onTap;

  const ProjectCard({
    super.key,
    required this.title,
    required this.description,
    required this.period,
    required this.routine,
    required this.status,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
    onTap: onTap,
    borderRadius: BorderRadius.circular(16),
    child:  Card(
      elevation: 1,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _Header(title: title, status: status),
            const SizedBox(height: 6),
            _Description(text: description),
            const SizedBox(height: 12),
            _MetaInfo(routine: routine, period: period),
          ],
        ),
      ),
    ),
    );
  }
}

class _Description extends StatelessWidget {
  final String text;

  const _Description({required this.text});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Text(
      text,
      style: theme.textTheme.bodySmall?.copyWith(
        color: theme.colorScheme.onSurface.withOpacity(0.6),
      ),
    );
  }
}


class _Header extends StatelessWidget {
  final String title;
  final ProjectStatus status;

  const _Header({
    required this.title,
    required this.status,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Text(
            title,
            style: theme.textTheme.bodyLarge?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        StatusChip(status: status),
      ],
    );
  }
}

class _MetaInfo extends StatelessWidget {
  final String routine;
  final String period;

  const _MetaInfo({
    required this.routine,
    required this.period,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final muted = theme.colorScheme.onSurface.withOpacity(0.6);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          routine,
          style: theme.textTheme.bodySmall,
        ),
        const SizedBox(height: 4),
        Text(
          period,
          style: theme.textTheme.bodySmall?.copyWith(color: muted),
        ),
      ],
    );
  }
}
