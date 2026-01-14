import 'package:elpo_book_project/view_models/home/timer_vm.dart';
import 'package:elpo_book_project/views/home/widgets/timer_controls.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomeTimerCard extends StatelessWidget {
  final VoidCallback? onTap;

  const HomeTimerCard({super.key, required this.onTap});

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
    final canExpand = vm.hasTarget && !vm.isEditing;

    return HeroMode(
      enabled: canExpand, // 편집중에 히어로 비활성.
      child: Hero(
        tag: 'timer-card-hero',
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: onTap,
            child: Card(
              elevation: 1,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    Text(
                      _format(display),
                      style: const TextStyle(
                        fontSize: 60,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 16),

                    // ✅ 공통 컨트롤
                    const TimerControls(compact: true),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
