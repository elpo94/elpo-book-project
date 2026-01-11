import 'package:elpo_book_project/views/project/widgets/project_status.dart';
import 'package:elpo_book_project/views/project/widgets/project_status_button.dart';
import 'package:flutter/material.dart';

class ProjectStatusSelector extends StatelessWidget {
  final ProjectStatus value;
  final ValueChanged<ProjectStatus>? onChanged;

  const ProjectStatusSelector({
    super.key,
    required this.value,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(6),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceVariant,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: ProjectStatus.values.map((s) {
          return Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4),
              child: ProjectStatusButton(
                status: s,
                selected: s == value,
                onTap: onChanged == null ? null : () => onChanged!(s),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}
