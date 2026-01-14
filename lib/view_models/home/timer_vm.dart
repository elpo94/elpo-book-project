import 'dart:async';
import 'package:flutter/foundation.dart';

class TimerViewModel extends ChangeNotifier {
  Duration targetDuration = Duration.zero;
  Duration remaining = Duration.zero;

  bool isRunning = false;
  Timer? _ticker;

  bool get hasTarget => targetDuration > Duration.zero;

  void setTarget(Duration duration) {
    targetDuration = duration;
    remaining = duration;
    notifyListeners();
  }

  void start() {
    if (isRunning) return;
    if (remaining <= Duration.zero) return;

    isRunning = true;
    notifyListeners();

    _ticker?.cancel();
    _ticker = Timer.periodic(const Duration(seconds: 1), (_) {
      if (!isRunning) return;

      if (remaining <= const Duration(seconds: 1)) {
        remaining = Duration.zero;
        stop(); // 자동 종료
        return;
      }

      remaining -= const Duration(seconds: 1);
      notifyListeners();
    });
  }

  void stop() {
    isRunning = false;
    _ticker?.cancel();
    _ticker = null;
    notifyListeners();
  }

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
