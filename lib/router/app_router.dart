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
final GlobalKey<NavigatorState> _rootNavigatorKey = GlobalKey<NavigatorState>();

final GoRouter appRouter = GoRouter(
  navigatorKey: _rootNavigatorKey,
  initialLocation: '/home',
  routes: [
    /// 1. 바텀바가 있는 탭 영역
    StatefulShellRoute.indexedStack(
      builder: (context, state, navigationShell) => MainShell(navigationShell: navigationShell),
      branches: [
        StatefulShellBranch(routes: [ GoRoute(path: '/home', builder: (_, __) => const HomeView()) ]),
        StatefulShellBranch(routes: [ GoRoute(path: '/project', builder: (_, __) => const ProjectView()) ]),
        StatefulShellBranch(routes: [ GoRoute(path: '/schedule', builder: (_, __) => const ScheduleView()) ]),
        StatefulShellBranch(routes: [ GoRoute(path: '/setting', builder: (_, __) => const SettingView()) ]),
      ],
    ),

    /// 2. 바텀바가 없는 전체 화면 영역 (Shell 밖으로 탈출)
    GoRoute(
      path: '/project/create',
      parentNavigatorKey: _rootNavigatorKey, // ✅ 루트 네비게이터를 써서 바텀바를 덮어버립니다.
      builder: (_, __) => const ProjectCreateView(),
    ),
    GoRoute(
      path: '/project/:id',
      parentNavigatorKey: _rootNavigatorKey, // ✅ 상세 페이지도 바텀바 없이 몰입!
      builder: (context, state) {
        final id = state.pathParameters['id']!;
        return ProjectDetailView(projectId: id);
      },
    ),
    GoRoute(
      path: '/timer',
      parentNavigatorKey: _rootNavigatorKey,
      builder: (_, __) => const TimerExpandView(),
    ),
  ],
);