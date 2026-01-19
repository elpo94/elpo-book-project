import 'package:flutter/material.dart';

class HomeViewModel extends ChangeNotifier {
  bool isRunning = false;

  void toggle() {
    isRunning = !isRunning;
    notifyListeners();
  }
}
