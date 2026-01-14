import 'package:elpo_book_project/view_models/home/timer_vm.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class TimerExpandView extends StatefulWidget {
  const TimerExpandView({super.key});

  @override
  State<TimerExpandView> createState() => _TimerExpandViewState();
}

class _TimerExpandViewState extends State<TimerExpandView> {
  @override
  void initState() {
    super.initState();

    // ✅ 가로 고정
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);

    // ✅ 상태바/네비게이션바 숨김 (유튜브 느낌)
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
  }

  @override
  void dispose() {
    // ✅ 세로 복구
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);

    // ✅ 시스템 UI 복구
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);

    super.dispose();
  }

  String _format(Duration d) {
    String two(int n) => n.toString().padLeft(2, '0');
    final h = d.inHours;
    final m = d.inMinutes.remainder(60);
    final s = d.inSeconds.remainder(60);
    return '${two(h)}:${two(m)}:${two(s)}';
  }

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<TimerViewModel>();
    final display = vm.isRunning
        ? vm.remaining
        : (vm.hasTarget ? vm.remaining : Duration.zero);

    return Scaffold(
      backgroundColor: const Color(0xFFF3E8DF),
      body: SafeArea(
        // SafeArea는 남겨두되, immersive라 상단은 거의 안 보임
        child: Stack(
          children: [
            // ✅ 중앙 시간
            Center(
              child: Text(
                _format(display),
                style: const TextStyle(
                  fontSize: 110,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 1,
                ),
              ),
            ),

            // ✅ 접기(셰브론 다운) - 유튜브처럼 위쪽
            Positioned(
              top: 6,
              left: 6,
              child: IconButton(
                icon: const Icon(
                  Icons.keyboard_arrow_down_rounded,
                  size: 40,
                ),
                onPressed: () => context.pop(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
