import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../views/home/home_view.dart';
import '../views/home/edit_plan_view.dart';
import '../views/home/widgets/timer/timer_expand_view.dart';

import '../views/project/project_view.dart';
import '../views/project/widgets/project_crearte_view.dart';
import '../views/project/widgets/project_detail_view.dart';

import '../views/schedule/schedule_view.dart';
import '../views/setting/setting_view.dart';

import 'main_shell.dart';

final _rootNavigatorKey = GlobalKey<NavigatorState>();

final GoRouter appRouter = GoRouter(
  navigatorKey: _rootNavigatorKey,
  initialLocation: '/home',
  routes: [
    /// ✅ 탭 전용 Shell (상태 유지)
    StatefulShellRoute.indexedStack(
      builder: (context, state, navigationShell) {
        return MainShell(
          navigationShell: navigationShell,
        );
      },
      branches: [
        /// 홈 탭
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/home',
              name: 'home',
              builder: (_, __) => const HomeView(),
            ),
            GoRoute(
              path: '/home/edit-plan',
              name: 'homeEditPlan',
              builder: (_, __) => const EditPlanView(),
            ),
          ],
        ),

        /// 프로젝트 탭
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/project',
              name: 'project',
              builder: (_, __) => const ProjectView(),
            ),
            GoRoute(
              path: '/project/create',
              name: 'projectCreate',
              builder: (_, __) => const ProjectCreateView(),
            ),
            GoRoute(
              path: '/project/:id',
              name: 'projectDetail',
              builder: (context, state) {
                final id = state.pathParameters['id']!;
                return ProjectDetailView(projectId: id);
              },
            ),
          ],
        ),

        /// 일정 탭
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/schedule',
              name: 'schedule',
              builder: (_, __) => const ScheduleView(),
            ),
          ],
        ),

        /// 설정 탭
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/setting',
              name: 'setting',
              builder: (_, __) => const SettingView(),
            ),
            GoRoute(
              path: '/setting/plan',
              name: 'settingPlan',
              builder: (_, __) => const EditPlanView(),
            ),
          ],
        ),
      ],
    ),

    /// ✅ 탭과 무관한 전체 오버레이 화면
    GoRoute(
      path: '/timer',
      parentNavigatorKey: _rootNavigatorKey,
      builder: (_, __) => const TimerExpandView(),
    ),
  ],
);
