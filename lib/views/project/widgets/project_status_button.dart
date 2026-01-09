import 'package:flutter/material.dart';
import 'project_status.dart';

class ProjectStatusButton extends StatelessWidget {
  final ProjectStatus status;
  final bool selected;
  final VoidCallback? onTap;

  const ProjectStatusButton({
    super.key,
    required this.status,
    required this.selected,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final color = status.color;

    return Expanded(
      child: OutlinedButton(
        style: OutlinedButton.styleFrom(
          backgroundColor: selected ? color : null,
          foregroundColor: selected ? Colors.white : color,
          side: BorderSide(color: color),
        ),
        onPressed: onTap,
        child: Text(status.label),
      ),
    );
  }
}
