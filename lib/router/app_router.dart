import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../views/home/home_view.dart';
import '../views/home/widgets/timer/timer_expand_view.dart';

import '../views/project/project_view.dart';
import '../views/project/widgets/project_crearte_view.dart';
import '../views/project/widgets/project_detail_view.dart';

import '../views/schedule/schedule_view.dart';
import '../views/setting/setting_view.dart';

import '../views/setting/widgets/app_info_view.dart';
import 'main_shell.dart';
final GlobalKey<NavigatorState> _rootNavigatorKey = GlobalKey<NavigatorState>();

final GoRouter appRouter = GoRouter(
  navigatorKey: _rootNavigatorKey,
  initialLocation: '/home',
  routes: [
    GoRoute(
      path: '/',
      redirect: (_, __) => '/home',
    ),
    StatefulShellRoute.indexedStack(
      builder: (context, state, navigationShell) {
        var shellWidget=MainShell(navigationShell: navigationShell);
        //print('shellWidgetId:${shellWidget.hashCode}#${shellWidget.navigationShell.shellRouteContext.routerState.fullPath}');
        return shellWidget;
      },
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
      parentNavigatorKey: _rootNavigatorKey,
      builder: (_, __) => const ProjectCreateView(),
    ),
    GoRoute(
      path: '/project/:id',
      parentNavigatorKey: _rootNavigatorKey,
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
    GoRoute(
      path: '/app-info',
      parentNavigatorKey: _rootNavigatorKey, // Shell 밖에서 띄우기
      builder: (context, state) => const AppInfoView(),
    ),
  ],
);