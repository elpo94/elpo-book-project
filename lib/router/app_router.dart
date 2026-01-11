import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:animations/animations.dart';

import '../views/home/home_view.dart';
import '../views/home/edit_plan_view.dart';
import '../views/home/widgets/timer_detail.dart';

import '../views/project/project_view.dart';
import '../views/project/widgets/project_crearte_view.dart';
import '../views/project/widgets/project_detail_view.dart';

import '../views/schedule/schedule_view.dart';
import '../views/setting/setting_view.dart';

import 'main_shell.dart';

final GoRouter appRouter = GoRouter(
  initialLocation: '/home',
  routes: [
    ShellRoute(
      pageBuilder: (context, state, child) {
        return CustomTransitionPage(
          key: state.pageKey,
          child: MainShell(child: child),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return SharedAxisTransition(
              animation: animation,
              secondaryAnimation: secondaryAnimation,
              transitionType: SharedAxisTransitionType.scaled,
              child: child,
            );
          },
        );
      },
      routes: [
        // =========================
        // 탭 라우트 (BottomNav)
        // =========================
        GoRoute(
          path: '/home',
          name: 'home',
          builder: (_, __) => const HomeView(),
        ),
        GoRoute(
          path: '/project',
          name: 'project',
          builder: (_, __) => const ProjectView(),
        ),
        GoRoute(
          path: '/schedule',
          name: 'schedule',
          builder: (_, __) => const ScheduleView(),
        ),
        GoRoute(
          path: '/setting',
          name: 'setting',
          builder: (_, __) => const SettingView(),
        ),

        // =========================
        // 홈 관련
        // =========================
        GoRoute(
          path: '/timer',
          name: 'timer',
          builder: (_, __) => const TimerDetailView(),
        ),

        // 목표(플랜) 수정: 홈에서도 들어갈 수 있음
        GoRoute(
          path: '/home/edit-plan',
          name: 'homeEditPlan',
          builder: (_, __) => const EditPlanView(),
        ),

        // =========================
        // 프로젝트 관련
        // =========================
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

        /// ✅ 지금은 UI단계라 edit 화면이 없을 수 있음.
        /// 나중에 프로젝트 수정 화면 만들면 여기 builder만 갈아끼우면 됨.
        // GoRoute(
        //   path: '/project/:id/edit',
        //   name: 'projectEdit',
        //   builder: (context, state) {
        //     final id = state.pathParameters['id']!;
        //     return ProjectEditView(projectId: id);
        //   },
        // ),

        // =========================
        // 스케줄(캘린더) 관련
        // =========================
        /// ✅ 지금은 UI단계라 상세 화면 없어도 됨.
        /// 카드 클릭 라우팅 시작할 때 추가하면 됨.
        // GoRoute(
        //   path: '/schedule/:id',
        //   name: 'scheduleDetail',
        //   builder: (context, state) {
        //     final id = state.pathParameters['id']!;
        //     return ScheduleDetailView(itemId: id);
        //   },
        // ),

        // =========================
        // 세팅 관련
        // =========================
        /// ✅ 세팅에서 목표 수정으로 연결하고 싶으면 이 라우트 쓰면 됨
        GoRoute(
          path: '/setting/plan',
          name: 'settingPlan',
          builder: (_, __) => const EditPlanView(),
        ),
      ],
    ),
  ],
);
