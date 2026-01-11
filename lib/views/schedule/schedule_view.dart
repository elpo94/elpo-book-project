import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../theme/app_colors.dart';
import '../../view_models/schedule_vm.dart';


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
          title: const Text('캘린더'),
          centerTitle: true,
          foregroundColor: AppColors.foreground,
        ),
        body: const Padding(
          padding: EdgeInsets.all(20),
          child: Column(
            children: [
              CalendarWidget(),
              SizedBox(height: 12),
              CalendarMemoList(),
            ],
          ),
        ),
      ),
    );
  }
}
