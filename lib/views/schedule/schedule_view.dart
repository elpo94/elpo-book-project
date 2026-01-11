import 'package:flutter/material.dart';
import 'widgets/calender_widget.dart';
import 'widgets/schedule_item_list.dart';

class ScheduleView extends StatelessWidget {
  const ScheduleView({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
      children: const [
        CalendarWidget(),
        SizedBox(height: 12),
        ScheduleItemList(),
      ],
    );
  }
}
