import 'package:flutter/material.dart';
import '../../models/project.dart';

// 서류보관소
class ProjectStore extends ChangeNotifier {
  List<ProjectModel> _projects = [];

  List<ProjectModel> get projects => _projects;

  // 수정
  void updateProjects(List<ProjectModel> newProjects) {
    _projects = newProjects;
    notifyListeners(); // 바로알림
  }

  // 부분 수정
  void updateSingleProject(ProjectModel updated) {
    final index = _projects.indexWhere((p) => p.id == updated.id);
    if (index != -1) {
      _projects[index] = updated;
      notifyListeners();
    }
  }
}