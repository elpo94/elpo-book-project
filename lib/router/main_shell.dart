import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../theme/app_colors.dart';

class MainShell extends StatelessWidget {
  final Widget child;
  const MainShell({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    final location = GoRouterState.of(context).uri.toString();

    return Scaffold(
      extendBody: true,

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

      body: child,

      floatingActionButton: location.startsWith('/project')
          ? FloatingActionButton(
        onPressed: () {
          context.push('/project/create');
        },
        shape: const CircleBorder(),
        backgroundColor: Theme.of(context).colorScheme.primary, // 노란 배경
        elevation: 3,
        child: Icon(
          Icons.edit,
          color: AppColors.foreground, // 브라운
          size: 30,
        ),
      )
          : null,

      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _index(location),
        onTap: (i) => _onTap(i, context),
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: '홈',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.book),
            label: '프로젝트',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.list),
            label: '일정',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: '설정',
          ),
        ],
      ),
    );
  }

  int _index(String uri) {
    if (uri.startsWith('/project')) return 1;
    if (uri.startsWith('/schedule')) return 2;
    if (uri.startsWith('/setting')) return 3;
    return 0;
  }

  void _onTap(int i, BuildContext context) {
    switch (i) {
      case 0:
        context.go('/home');
        break;
      case 1:
        context.go('/project');
        break;
      case 2:
        context.go('/schedule');
        break;
      case 3:
        context.go('/setting');
        break;
    }
  }
}
