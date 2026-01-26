import 'package:flutter/material.dart';
import 'package:sabujak_application/views/schedule/widgets/calender_legend.dart';
import '../project/widgets/project_detail_view.dart';
import 'widgets/calender_widget.dart';
import 'widgets/schedule_item_list.dart';

class ScheduleView extends StatelessWidget {
  const ScheduleView({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      ///TOTO : 전체 캘린더를 접는 기능은 고려해볼 것. 프로젝트 많아지면 필요할지도.
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
      children: [
        const CalendarWidget(),
        const ScheduleLegend(),
        const SizedBox(height: 12),
        ScheduleItemList(
          onCardTap: (projectId) {
            if (projectId.isNotEmpty) {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ProjectDetailView(projectId: projectId),
                ),
              );
            }
          },
        ),
      ],
    );
  }
}
