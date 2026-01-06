import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:animations/animations.dart';

import '../views/home/home.dart';
import '../views/home/timer_detail.dart';
import '../views/project.dart';
import '../views/schedule.dart';
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
      ],
    ),
  ],
);
