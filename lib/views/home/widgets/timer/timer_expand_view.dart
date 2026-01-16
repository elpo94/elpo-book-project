import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../../../view_models/home/timer_vm.dart';
import 'timer_controls.dart';
import '../../../../widgets/confirm_dialog.dart';

class TimerExpandView extends StatefulWidget {
  const TimerExpandView({super.key});

  @override
  State<TimerExpandView> createState() => _TimerExpandViewState();
}

class _TimerExpandViewState extends State<TimerExpandView> {
  @override
  void initState() {
    super.initState();

    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);

    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
  }

  @override
  void dispose() {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);

    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    super.dispose();
  }

  Future<void> _handleReset(BuildContext context) async {
    final vm = context.read<TimerViewModel>();

    final ok = await showConfirmDialog(
      context,
      title: '타이머를 초기화할까요?',
      message: '누적된 시간이 00:00:00으로 돌아갑니다.\n되돌릴 수 없습니다.',
      cancelText: '취소',
      confirmText: '초기화',
      confirmColor: const Color(0xFFD65C5C),
    );

    if (!ok || !context.mounted) return;

    vm.reset();
    context.go('/home');
  }

  String _format(Duration d) {
    String two(int n) => n.toString().padLeft(2, '0');
    return '${two(d.inHours)}:${two(d.inMinutes.remainder(60))}:${two(d.inSeconds.remainder(60))}';
  }

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<TimerViewModel>();

    final display = vm.hasTarget ? vm.remaining : Duration.zero;

    return Scaffold(
      backgroundColor: const Color(0xFFF3E8DF),
      body: SafeArea(
        child: Stack(
          children: [
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

            Positioned(
              top: 6,
              left: 6,
              child: IconButton(
                icon: const Icon(Icons.keyboard_arrow_down_rounded, size: 40),
                onPressed: () => context.pop(),
              ),
            ),

            Positioned(
              left: 0,
              right: 0,
              bottom: 12,
              child: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 520),
                  child: TimerControls(
                    compact: false,
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    onReset: () => _handleReset(context),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
