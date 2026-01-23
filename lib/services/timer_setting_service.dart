import 'package:shared_preferences/shared_preferences.dart';

class SettingService {
  static const String _keyTargetTime = 'default_target_time_minutes';

  // 기본 목표 시간 저장 (단위: 분)
  Future<void> saveDefaultTargetTime(int minutes) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_keyTargetTime, minutes);
  }

  // 기본 목표 시간 불러오기 (설정 없으면 기본 60분)
  Future<int> getDefaultTargetTime() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt(_keyTargetTime) ?? 60;
  }
}