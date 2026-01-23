import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
// TableCalendar의 자체 isSameDay를 사용하도록 변경
import 'package:table_calendar/table_calendar.dart';

import '../../../models/calendar_item.dart';
import '../../../theme/app_colors.dart';
import '../../../view_models/schedule/schedule_vm.dart';
import '../../project/widgets/project_status.dart';

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
        availableGestures: AvailableGestures.horizontalSwipe,

        // ✅ VM의 변수와 TableCalendar의 isSameDay 연결
        selectedDayPredicate: (day) => isSameDay(vm.selectedDay, day),

        onDaySelected: (selectedDay, focusedDay) {
          vm.selectDay(selectedDay, focusedDay);
        },

        onPageChanged: (focusedDay) {
          // ✅ 뷰모델에 명시적인 함수가 없다면 직접 할당 가능 (혹은 VM에 함수 추가)
          vm.selectDay(vm.selectedDay, focusedDay);
        },

        eventLoader: vm.itemsOf,

        headerStyle: HeaderStyle(
          titleCentered: true,
          formatButtonVisible: false,
          leftChevronIcon: const Icon(Icons.chevron_left_rounded),
          rightChevronIcon: const Icon(Icons.chevron_right_rounded),
          titleTextStyle: TextStyle(
            fontFamily: 'AritaBuri',
            fontSize: 16,
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

        rowHeight: 50,

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

          markerBuilder: (context, day, events) {
            if (events.isEmpty) return const SizedBox.shrink();

            final colors = events.take(3).map((e) {
              final display = effectiveStatus(
                status: e.status,
                deadline: e.date,
              );
              return display.color;
            }).toList();

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
}

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