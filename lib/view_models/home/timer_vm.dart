import 'dart:async';
import 'package:flutter/foundation.dart';

class TimerViewModel extends ChangeNotifier {
  Duration targetDuration = Duration.zero;
  Duration remaining = Duration.zero;
  bool _justReset = false;
  bool get justReset => _justReset;


  bool isRunning = false;
  Timer? _ticker;

  bool _isEditing = false;
  bool get isEditing => _isEditing;
  bool get hasTarget => targetDuration > Duration.zero;

  /* =======================
   * Edit mode
   * ======================= */

  void beginEdit() {
    _isEditing = true;
    notifyListeners();
  }

  void endEdit() {
    _isEditing = false;
    notifyListeners();
  }

  /* =======================
   * Setup
   * ======================= */

  void setTarget(Duration duration) {
    targetDuration = duration;
    remaining = duration;
    notifyListeners();
  }

  /* =======================
   * Timer control (public)
   * ======================= */

  void start() {
    if (isRunning) return;
    if (remaining <= Duration.zero) return;

    _startInternal();
    notifyListeners();
  }

  void stop() {
    _stopInternal();
    notifyListeners();
  }

  void reset() {
    _stopInternal();
    targetDuration = Duration.zero;
    remaining = Duration.zero;

    _justReset = true;
    notifyListeners();
  }

  //이벤트 후 초기화
  void consumeResetEvent() {
    _justReset = false;
  }



  /* =======================
   * Internal helpers
   * ======================= */

  void _startInternal() {
    isRunning = true;

    _ticker?.cancel();
    _ticker = Timer.periodic(const Duration(seconds: 1), (_) {
      if (!isRunning) return;

      if (remaining <= const Duration(seconds: 1)) {
        remaining = Duration.zero;
        _stopInternal(); // 내부 종료
        notifyListeners(); // 종료 결과 알림
        return;
      }

      remaining -= const Duration(seconds: 1);
      notifyListeners();
    });
  }

  void _stopInternal() {
    isRunning = false;
    _ticker?.cancel();
    _ticker = null;
  }

  @override
  void dispose() {
    _ticker?.cancel();
    super.dispose();
  }
}
