import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:table_calendar/table_calendar.dart';

import '../../../models/calendar_item.dart';
import '../../../theme/app_colors.dart';
import '../../../view_models/schedule/schedule_vm.dart';

class CalendarWidget extends StatelessWidget {
  const CalendarWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<ScheduleVM>();

    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppColors.border, width: 0.8),
        boxShadow: const [
          BoxShadow(
            blurRadius: 10,
            offset: Offset(0, 3),
            color: Color(0x14000000),
          ),
        ],
      ),
      child: TableCalendar<CalendarItem>(
        locale: 'ko_KR',
        firstDay: DateTime.utc(2020, 1, 1),
        lastDay: DateTime.utc(2035, 12, 31),
        focusedDay: vm.focusedDay,

        // ✅ 좌우 스와이프 월 이동 기본 동작
        availableGestures: AvailableGestures.horizontalSwipe,

        // ✅ 선택일 표시
        selectedDayPredicate: (day) => isSameDay(vm.selectedDay, day),

        // ✅ 선택일 변경 -> VM으로 위임
        onDaySelected: (selectedDay, focusedDay) {
          vm.selectDay(selectedDay, focusedDay);
        },

        // ✅ 월 이동 -> VM에 focusedDay 반영
        onPageChanged: (focusedDay) {
          vm.setFocusedDay(focusedDay);
        },

        // ✅ 더미/실제 데이터 연결 지점
        eventLoader: vm.itemsOf,

        headerStyle: HeaderStyle(
          titleCentered: true,
          formatButtonVisible: false,
          leftChevronIcon: const Icon(Icons.chevron_left_rounded),
          rightChevronIcon: const Icon(Icons.chevron_right_rounded),
          titleTextStyle: TextStyle(
            fontFamily: 'AritaBuri',
            fontSize: 16, // 기존 14 -> 16
            fontWeight: FontWeight.w600,
            color: AppColors.foreground,
          ),
        ),

        daysOfWeekStyle: const DaysOfWeekStyle(
          weekdayStyle: TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
          weekendStyle: TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
        ),

        calendarStyle: const CalendarStyle(
          outsideDaysVisible: false,
          cellMargin: EdgeInsets.symmetric(horizontal: 4, vertical: 6),
          selectedTextStyle: TextStyle(fontSize: 15, fontWeight: FontWeight.w700),
          todayTextStyle: TextStyle(fontSize: 15, fontWeight: FontWeight.w700),
        ),

        rowHeight: 50, // 기존보다 조금만

        calendarBuilders: CalendarBuilders(
          defaultBuilder: (context, day, focusedDay) {
            return _DayCell(
              day: day,
              isSelected: false,
              isToday: isSameDay(day, DateTime.now()),
            );
          },

          selectedBuilder: (context, day, focusedDay) {
            return _DayCell(
              day: day,
              isSelected: true,
              isToday: false,
            );
          },

          todayBuilder: (context, day, focusedDay) {
            return _DayCell(
              day: day,
              isSelected: isSameDay(day, vm.selectedDay),
              isToday: true,
            );
          },

          // ✅ 캘린더 점(마커)
          markerBuilder: (context, day, events) {
            if (events.isEmpty) return const SizedBox.shrink();

            // 최대 3개만 표시 (예정/진행/완료/지연 혼합 가능)
            final colors = events
                .take(3)
                .map((e) => _statusDotColor(e.status))
                .toList();

            return Positioned(
              bottom: 10,
              left: 0,
              right: 0,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: colors
                    .map(
                      (c) => Container(
                    width: 5,
                    height: 5,
                    margin: const EdgeInsets.symmetric(horizontal: 2),
                    decoration: BoxDecoration(
                      color: c,
                      shape: BoxShape.circle,
                    ),
                  ),
                )
                    .toList(),
              ),
            );
          },
        ),
      ),
    );
  }

  Color _statusDotColor(ProjectStatus status) {
    return switch (status) {
      ProjectStatus.planned => AppColors.statusPlanned, // 오렌지
      ProjectStatus.ongoing => AppColors.statusOngoing, // 블루
      ProjectStatus.done => AppColors.statusDone, // 그린
      ProjectStatus.overdue => AppColors.statusOverdue, // 레드
    };
  }
}

/// 날짜 셀만 따로 분리 (파일 길이 줄이기 + 책임 분리)
class _DayCell extends StatelessWidget {
  final DateTime day;
  final bool isSelected;
  final bool isToday;

  const _DayCell({
    required this.day,
    required this.isSelected,
    required this.isToday,
  });

  @override
  Widget build(BuildContext context) {
    final selectedBg = AppColors.calendarSelected;
    final todayBorder = AppColors.calendarSelected.withOpacity(0.55);

    return Container(
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: isSelected ? selectedBg : Colors.transparent,
        borderRadius: BorderRadius.circular(12),
        border: (!isSelected && isToday) ? Border.all(color: todayBorder) : null,
      ),
      child: Align(
        alignment: const Alignment(0, -0.4),
        child: Text(
          '${day.day}',
          style: TextStyle(
            fontSize: 16,
            fontWeight: isSelected ? FontWeight.w800 : FontWeight.w600,
            color: isSelected ? AppColors.calendarSelectedOn : AppColors.foreground,
          ),
        ),
      ),
    );
  }
}

