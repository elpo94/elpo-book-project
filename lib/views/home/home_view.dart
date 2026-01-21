
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:sabujak_application/views/home/widgets/home_selection.dart';
import 'package:sabujak_application/views/home/widgets/timer/home_timer_card.dart';
import 'package:sabujak_application/views/home/widgets/today_plan_card.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(12),
      children: [
        //타이머
        HomeSection(child: HomeTimerCard(onTap: () => context.push('/timer'))),

        const HomeSection(title: '오늘 목표', child: TodayPlanCard()),

        // 3. 프로젝트 (실제 리스트 연동)
        HomeSection(
          title: '프로젝트',
          child: projects.isEmpty
              ? const Center(child: Text("진행 중인 프로젝트가 없습니다.")) //
              : SizedBox(
            height: 140, // 카드 높이에 맞춰 조절
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: projects.length,
              itemBuilder: (context, index) {
                final project = projects[index];
                return _buildProjectItem(context, project);
              },
            ),
          ),
        ),
      ],
    );
  }

  // 개별 프로젝트 카드 위젯 (피그마 스타일)
  Widget _buildProjectItem(BuildContext context, dynamic project) {
    return GestureDetector(
      onTap: () {
        // 상세 페이지로 이동 (ID 전달)
        context.push('/project-detail/${project.id}');
        // 💡 GoRouter 사용 시 라우트 설정이 필요합니다.
        // Navigator라면 Navigator.push(context, MaterialPageRoute(builder: (context) => ProjectDetailView(projectId: project.id)));
      },
      child: Container(
        width: 160, // 카드 너비
        margin: const EdgeInsets.only(right: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: const Color(0xFFF3EDE2), // 사부작 베이지
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              project.name,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 6),
            Text(
              project.description,
              style: const TextStyle(fontSize: 12, color: Color(0xFF8D7A65)),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}