import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class MainShell extends StatelessWidget {
  final Widget child;
  const MainShell({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    final location = GoRouterState.of(context).uri.toString();

    return Scaffold(
      extendBody: true, // 바텀네비 이게 문젠가?
      body: child, //
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
