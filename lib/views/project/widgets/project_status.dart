import 'package:flutter/material.dart';

enum ProjectStatus { planned, ongoing, done }

extension ProjectStatusStyle on ProjectStatus {
  Color get color {
    switch (this) {
      case ProjectStatus.planned:
        return Colors.red;
      case ProjectStatus.ongoing:
        return Colors.blue;
      case ProjectStatus.done:
        return Colors.green;
    }
  }

  String get label {
    switch (this) {
      case ProjectStatus.planned:
        return '시작 전';
      case ProjectStatus.ongoing:
        return '진행 중';
      case ProjectStatus.done:
        return '마감';
    }
  }
}




