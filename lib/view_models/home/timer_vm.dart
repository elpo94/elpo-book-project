import 'dart:async';
import 'package:flutter/foundation.dart';

class TimerViewModel extends ChangeNotifier {
  Duration targetDuration = Duration.zero;
  Duration remaining = Duration.zero;

  bool isRunning = false;
  Timer? _ticker;

  bool _isEditing = false;
  bool get isEditing => _isEditing;
  bool get hasTarget => targetDuration > Duration.zero;

  void beginEdit() {
    _isEditing = true;
    notifyListeners();
  }

  void endEdit() {
    _isEditing = false;
    notifyListeners();
  }

  void setTarget(Duration duration) {
    targetDuration = duration;
    remaining = duration;
    notifyListeners();
  }

  void start() {
    if (isRunning || remaining <= Duration.zero) return;

    isRunning = true;
    notifyListeners();

    _ticker?.cancel();
    _ticker = Timer.periodic(const Duration(seconds: 1), (_) {
      if (!isRunning) return;

      if (remaining <= const Duration(seconds: 1)) {
        remaining = Duration.zero;
        stop();
        return;
      }

      remaining -= const Duration(seconds: 1);
      notifyListeners();
    });
  }

  void stop() {
    if (!isRunning) return;
    isRunning = false;
    _ticker?.cancel();
    _ticker = null;
    notifyListeners();
  }

  /// ✅ reset은 "완전 초기 상태"로 되돌림
  void reset() {
    stop();
    targetDuration = Duration.zero;
    remaining = Duration.zero;
    notifyListeners();
  }

  @override
  void dispose() {
    _ticker?.cancel();
    super.dispose();
  }
}
