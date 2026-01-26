import 'package:shared_preferences/shared_preferences.dart';


class SettingService {
  static const String _keySystemDefault = 'system_default_seconds';
  static const String _keyCurrentSession = 'current_session_seconds';

  // 디폴트값
  Future<void> saveSystemDefault(int seconds) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_keySystemDefault, seconds);
  }

  Future<int> getSystemDefault() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt(_keySystemDefault) ?? 7200; // 초기값 2시간
  }
  // 홈 타이머
  Future<void> saveCurrentSession(int seconds) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_keyCurrentSession, seconds);
  }

  Future<int?> getCurrentSession() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt(_keyCurrentSession); // 값이 없으면 null 반환
  }
}