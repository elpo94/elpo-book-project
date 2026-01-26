// lib/views/project/widgets/project_date_picker.dart
import 'package:flutter/material.dart';
import '../../../theme/app_colors.dart';

Future<DateTimeRange?> showAppDateRangePicker(BuildContext context) async {
  return await showDateRangePicker(
    context: context,
    initialEntryMode: DatePickerEntryMode.calendarOnly, // ⭐ 다이얼로그 없이 바로 달력만!
    firstDate: DateTime.now().subtract(const Duration(days: 365)),
    lastDate: DateTime.now().add(const Duration(days: 365 * 2)),
    saveText: '선택',
    helpText: '기간을 설정하세요',
    builder: (context, child) {
      return Theme(
        data: Theme.of(context).copyWith(
          colorScheme: const ColorScheme.light(
            primary: Color(0xFFB58A53),
            onPrimary: Colors.white,
            surface: AppColors.background,
            onSurface: AppColors.foreground,
            secondaryContainer: Color(0xFFE1D5C7),
          ),
          /// TODO: 바꿔야하나?
          textButtonTheme: TextButtonThemeData(
            style: TextButton.styleFrom(foregroundColor: const Color(0xFFB58A53)),
          ),
        ),
        child: child!,
      );
    },
  );
}