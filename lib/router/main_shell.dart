import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../theme/app_colors.dart';

class MainShell extends StatelessWidget {
  final StatefulNavigationShell navigationShell;

  const MainShell({
    super.key,
    required this.navigationShell,
  });

  @override
  Widget build(BuildContext context) {
    final currentIndex = navigationShell.currentIndex;

    // ✅ 프로젝트 탭에서만 FAB 표시
    final showProjectFab = currentIndex == 1;

    return Scaffold(
      extendBody: false,

      appBar: AppBar(
        title: const Text('사부작'),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Container(
            height: 1,
            color: AppColors.border.withOpacity(0.6),
          ),
        ),
      ),

      /// ⭐ 핵심 변화
      /// - child 대신 navigationShell
      /// - IndexedStack 기반으로 이미 존재하는 화면을 보여줌
      body: Material(
        color: AppColors.background,
        child: navigationShell,
      ),

      floatingActionButton: showProjectFab
          ? FloatingActionButton(
        onPressed: () => context.push('/project/create'),
        shape: const CircleBorder(),
        backgroundColor: Theme.of(context).colorScheme.primary,
        elevation: 3,
        child: Icon(
          Icons.edit,
          color: AppColors.foreground,
          size: 30,
        ),
      )
          : null,

      bottomNavigationBar: Theme(
        data: Theme.of(context).copyWith(
          splashFactory: NoSplash.splashFactory,
          highlightColor: Colors.transparent,
        ),
        child: BottomNavigationBar(
          enableFeedback: false,
          type: BottomNavigationBarType.fixed,

          /// ⭐ URL이 아니라 Shell 상태
          currentIndex: currentIndex,

          /// ⭐ context.go() 제거
          onTap: (index) {
            navigationShell.goBranch(
              index,
              initialLocation: index == currentIndex,
            );
          },

          selectedItemColor: AppColors.foreground,
          unselectedItemColor: AppColors.foreground.withOpacity(0.45),

          selectedIconTheme: const IconThemeData(size: 30),
          unselectedIconTheme: const IconThemeData(size: 24),

          selectedLabelStyle: const TextStyle(
            fontWeight: FontWeight.w800,
            fontSize: 12,
          ),
          unselectedLabelStyle: const TextStyle(
            fontWeight: FontWeight.w500,
            fontSize: 11,
          ),

          iconSize: 26,

          items: const [
            BottomNavigationBarItem(icon: Icon(Icons.home), label: '홈'),
            BottomNavigationBarItem(icon: Icon(Icons.book), label: '프로젝트'),
            BottomNavigationBarItem(icon: Icon(Icons.list), label: '일정'),
            BottomNavigationBarItem(icon: Icon(Icons.settings), label: '설정'),
          ],
        ),
      ),
    );
  }
}
