import 'package:flutter/material.dart';
import '../../../models/project.dart';
import 'home_project_card.dart';
import 'home_selection.dart';

class HomeProjectSection extends StatelessWidget {
  final List<ProjectModel> projects;
  final Function(ProjectModel) onProjectTap;

  const HomeProjectSection({
    super.key,
    required this.projects,
    required this.onProjectTap
  });

  @override
  Widget build(BuildContext context) {
    return HomeSection(
      title: '프로젝트',
      child: projects.isEmpty ? _buildEmptyState() : _buildProjectList(),
    );
  }

  Widget _buildEmptyState() {
    return Container(
      height: 120,
      alignment: Alignment.center,
      child: const Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text("진행 중인 프로젝트가 없습니다.", style: TextStyle(fontSize: 14, color: Colors.black45)),
          SizedBox(height: 6),
          Text("아름답지 않나요? ✨", style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: Color(0xFFB58A53))),
        ],
      ),
    );
  }

  Widget _buildProjectList() {
    return Column(
      children: projects.map((project) => Padding(
        padding: const EdgeInsets.only(bottom: 12),
        child: HomeProjectCard(
          project: project,
          onTap: () => onProjectTap(project),
        ),
      )).toList(),
    );
  }
}