import 'package:flutter/foundation.dart';
import '../models/calendar_item.dart';

class ScheduleVM extends ChangeNotifier {
  DateTime focusedDay = DateTime.now();
  DateTime selectedDay = CalendarItem.normalizeDate(DateTime.now());

  /// UI용 더미
  final Map<DateTime, List<CalendarItem>> itemsByDay = {};

  ScheduleVM() {
    // 더미 데이터는 여기서 준비 (UI 전용)
    final today = CalendarItem.normalizeDate(DateTime.now());
    itemsByDay[today] = [
      CalendarItem(
        id: '1',
        title: '소설 1부 - 설정 메모',
        status: ProjectStatus.planned,
        date: today,
        note: '세계관 이름 후보 정리',
      ),
    ];
  }

  List<CalendarItem> itemsOf(DateTime day) {
    final key = CalendarItem.normalizeDate(day);
    return itemsByDay[key] ?? const [];
  }

  void selectDay(DateTime selected, DateTime focused) {
    selectedDay = CalendarItem.normalizeDate(selected);
    focusedDay = focused;
    notifyListeners();
  }

  void setFocusedDay(DateTime focused) {
    focusedDay = focused;
    notifyListeners();
  }
}
