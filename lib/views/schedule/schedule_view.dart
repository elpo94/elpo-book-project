import 'package:elpo_book_project/views/schedule/widgets/calender_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../theme/app_colors.dart';
import '../../view_models/schedule_vm.dart';
import 'widgets/schedule_item_list.dart';

class ScheduleView extends StatelessWidget {
  const ScheduleView({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => ScheduleVM(),
      child: Scaffold(
        backgroundColor: AppColors.background,
        appBar: AppBar(
          elevation: 0,
          backgroundColor: AppColors.background,
          foregroundColor: AppColors.foreground,
          centerTitle: true,
          title: const Text('캘린더'),
        ),
        body: const Padding(
          padding: EdgeInsets.all(20),
          child: Column(
            children: [
              CalendarWidget(),
              SizedBox(height: 12),
              ScheduleItemList(),
            ],
          ),
        ),
      ),
    );
  }
}
