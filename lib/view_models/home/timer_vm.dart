import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:sabujak_application/services/timer_setting_service.dart';

class TimerViewModel extends ChangeNotifier {
  final SettingService _timerservice;

  Duration targetDuration = Duration.zero;
  Duration remaining = Duration.zero;

  Duration _systemDefaultDuration = Duration.zero;
  String get formattedSystemDefault => _formatToKorean(_systemDefaultDuration);

  bool isRunning = false;
  Timer? _ticker;

  bool _isEditing = false;
  bool get isEditing => _isEditing;
  bool get hasTarget => targetDuration > Duration.zero;

  TimerViewModel(this._timerservice) {
    setupDuration();
  }

  // ---------------------------------------------------------------------------
  // 1. 포맷팅 논리 (중앙 집중화)
  // ---------------------------------------------------------------------------

  String get formattedTargetDuration => _formatToKorean(targetDuration);
  String get formattedRemainingTime => _formatToDigital(remaining);

  String _formatToKorean(Duration d) {
    final hours = d.inHours;
    final minutes = d.inMinutes.remainder(60);
    final seconds = d.inSeconds.remainder(60);

    final List<String> parts = [];
    if (hours > 0) parts.add('$hours시간');
    if (minutes > 0) parts.add('$minutes분');
    if (seconds > 0 || parts.isEmpty) parts.add('$seconds초');

    return parts.join(' ');
  }

  String _formatToDigital(Duration d) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final h = twoDigits(d.inHours);
    final m = twoDigits(d.inMinutes.remainder(60));
    final s = twoDigits(d.inSeconds.remainder(60));
    return '$h:$m:$s';
  }

  // ---------------------------------------------------------------------------
  // 2. 타이머 제어 및 데이터 관리
  // ---------------------------------------------------------------------------

  Future<void> setupDuration() async {
    final int systemDefault = await _timerservice.getSystemDefault();
    _systemDefaultDuration = Duration(seconds: systemDefault);

    int? sessionTime = await _timerservice.getCurrentSession();

    if (sessionTime != null) {
      targetDuration = Duration(seconds: sessionTime);
    } else {
      targetDuration = _systemDefaultDuration;
    }

    remaining = targetDuration;
    notifyListeners();
  }

  void updateSystemDefault(Duration newDefault) {
    _systemDefaultDuration = newDefault;
    notifyListeners();
  }

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

  void reset() {
    stop();
    remaining = Duration.zero;
    notifyListeners();
  }

  @override
  void dispose() {
    _ticker?.cancel();
    super.dispose();
  }
}