import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:animations/animations.dart';

import '../views/home/edit_plan_view.dart';
import '../views/home/home_view.dart';
import '../views/home/widgets/timer_detail.dart';
import '../views/project/project_view.dart';
import '../views/project/widgets/project_crearte_view.dart';
import '../views/project/widgets/project_detail_view.dart';
import '../views/schedule/schedule_view.dart';
import '../views/setting.dart';
import 'main_shell.dart';

final GoRouter appRouter = GoRouter(
  initialLocation: '/home',

  routes: [
    ShellRoute(
      pageBuilder: (context, state, child) {
        return CustomTransitionPage(
          child: MainShell(child: child),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return SharedAxisTransition(
              animation: animation,
              secondaryAnimation: secondaryAnimation,
              transitionType: SharedAxisTransitionType.scaled, // 넘어가는방법
              child: child,
            );
          },
        );
      },
      routes: [
        //홈
        GoRoute(
          path: '/home',
          name: 'home',
          builder: (context, state) => const HomeView(),
        ),
        GoRoute(
          path: '/project',
          name: 'project',
          builder: (context, state) => const ProjectView(),
        ),
        GoRoute(
          path: '/schedule',
          name: 'schedule',
          builder: (context, state) => const ScheduleView(),
        ),
        GoRoute(
          path: '/setting',
          name: 'setting',
          builder: (context, state) => const SettingView(),
        ),
        GoRoute(
          path: '/timer',
          builder: (context, state) => const TimerDetailView(),
        ),
        GoRoute(
          path: '/home/edit-plan',
          builder: (_, __) => const EditPlanView(),
        ),

        //프로젝트
        GoRoute(
          path: '/project',
          builder: (context, state) => const ProjectView(),
        ),
        GoRoute(
          path: '/project/edit',
          builder: (context, state) => const EditPlanView(),
        ),
        GoRoute(
          path: '/project/create',
          builder: (context, state) => const ProjectCreateView(),
        ),
        GoRoute(
          path: '/project/:id', // id는 더미. 바꿔야 함.
          builder: (context, state) {
            final id = state.pathParameters['id']!;
            return ProjectDetailView(projectId: id);
          },
        ),

        //스케줄러

        //세팅

      ],
    ),
  ],
);
