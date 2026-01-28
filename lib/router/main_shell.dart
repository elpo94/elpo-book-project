import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

// ✅ 필요한 서비스 및 스토어 임포트 (프로젝트 경로에 맞게 확인해주세요)
import '../../services/auth_service.dart';
import '../../services/project_store.dart';
import '../theme/app_colors.dart';

class MainShell extends StatefulWidget {
  final StatefulNavigationShell navigationShell;

  const MainShell({
    super.key,
    required this.navigationShell,
  });

  @override
  State<MainShell> createState() => _MainShellState();
}

class _MainShellState extends State<MainShell> {
  @override
  void initState() {
    super.initState();
    // ⭐ [핵심] 앱이 시작될 때 딱 한 번, 파이어베이스 데이터를 싱크합니다.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _initializeAppData();
    });
  }

  Future<void> _initializeAppData() async {
    try {
      final authService = context.read<AuthService>();
      final projectStore = context.read<ProjectStore>();

      final uid = authService.currentUserId;
      if (uid != null && uid.isNotEmpty) {
        // 파이어베이스 -> 스토어(메모리) 데이터 로드
        await projectStore.fetchAndStore(uid);
      }
    } catch (e) {
      debugPrint("앱 초기 데이터 로드 실패: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    // 현재 GoRouter의 위치 정보
    final String location = GoRouterState.of(context).uri.toString();
    // 선택된 탭 인덱스
    final currentIndex = widget.navigationShell.currentIndex;

    // FAB 노출 조건: '프로젝트' 탭이면서 상세나 생성 페이지가 아닐 때만
    final bool showProjectFab = currentIndex == 1 &&
        !location.contains('detail') &&
        !location.contains('create');

    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
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
        body: Material(
          color: AppColors.background,
          child: widget.navigationShell,
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
            currentIndex: currentIndex,
            onTap: (index) {
              // Shell 기능을 활용하여 탭 전환 (동일 탭 클릭 시 초기 위치 이동 처리)
              widget.navigationShell.goBranch(
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
      ),
    );
  }
}