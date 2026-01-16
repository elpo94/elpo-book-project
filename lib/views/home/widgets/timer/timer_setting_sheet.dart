import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';


class TimerSettingSheet extends StatefulWidget {
  final void Function(Duration) onConfirm;
  final VoidCallback onCancel;

  const TimerSettingSheet({
    super.key,
    required this.onConfirm,
    required this.onCancel,
  });

  @override
  State<TimerSettingSheet> createState() => _TimerSettingSheetState();
}

class _TimerSettingSheetState extends State<TimerSettingSheet> {
  static const int _maxHours = 23;

  Duration _tempDuration = Duration.zero;

  late final FixedExtentScrollController _hCtrl =
  FixedExtentScrollController(initialItem: 0);
  late final FixedExtentScrollController _mCtrl =
  FixedExtentScrollController(initialItem: 0);
  late final FixedExtentScrollController _sCtrl =
  FixedExtentScrollController(initialItem: 0);

  @override
  void dispose() {
    _hCtrl.dispose();
    _mCtrl.dispose();
    _sCtrl.dispose();
    super.dispose();
  }

  void _onWheelChanged() {
    setState(() {
      _tempDuration = Duration(
        hours: _hCtrl.selectedItem,
        minutes: _mCtrl.selectedItem,
        seconds: _sCtrl.selectedItem,
      );
    });
  }

  Future<void> _setDuration(Duration d) async {
    final h = d.inHours.clamp(0, _maxHours);
    final m = d.inMinutes.remainder(60);
    final s = d.inSeconds.remainder(60);

    setState(() {
      _tempDuration = Duration(hours: h, minutes: m, seconds: s);
    });

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      _hCtrl.animateToItem(h, duration: const Duration(milliseconds: 180), curve: Curves.easeOut);
      _mCtrl.animateToItem(m, duration: const Duration(milliseconds: 180), curve: Curves.easeOut);
      _sCtrl.animateToItem(s, duration: const Duration(milliseconds: 180), curve: Curves.easeOut);
    });
  }

  Widget _wheel(FixedExtentScrollController ctrl, int count) {
    return CupertinoPicker(
      scrollController: ctrl,
      itemExtent: 44,
      useMagnifier: true,
      magnification: 1.08,
      onSelectedItemChanged: (_) => _onWheelChanged(),
      children: List.generate(
        count,
            (i) => Center(
          child: Text(
            i.toString().padLeft(2, '0'),
            style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w600),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final media = MediaQuery.of(context);

    return SafeArea(
      child: SizedBox(
        height: media.size.height * 0.45,
        child: Column(
          children: [
            const SizedBox(height: 8),
            Container(
              width: 44,
              height: 5,
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.12),
                borderRadius: BorderRadius.circular(999),
              ),
            ),
            const SizedBox(height: 12),
            const Text('타이머 설정', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700)),
            const SizedBox(height: 8),

            Expanded(
              flex: 7,
              child: Row(
                children: [
                  Expanded(child: _wheel(_hCtrl, _maxHours + 1)),
                  Expanded(child: _wheel(_mCtrl, 60)),
                  Expanded(child: _wheel(_sCtrl, 60)),
                ],
              ),
            ),

            Wrap(
              spacing: 10,
              children: [
                _PresetChip('10분', () => _setDuration(const Duration(minutes: 10))),
                _PresetChip('15분', () => _setDuration(const Duration(minutes: 15))),
                _PresetChip('30분', () => _setDuration(const Duration(minutes: 30))),
              ],
            ),

            Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
              child: Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: widget.onCancel,
                      child: const Text('취소'),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: FilledButton(
                      onPressed: _tempDuration == Duration.zero
                          ? null
                          : () {
                        widget.onConfirm(_tempDuration);
                        Navigator.pop(context);
                      },
                      child: const Text('설정'),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _PresetChip extends StatelessWidget {
  final String label;
  final VoidCallback onTap;

  const _PresetChip(this.label, this.onTap);

  @override
  Widget build(BuildContext context) {
    return ActionChip(
      label: Text(
        label,
        style: const TextStyle(
          fontWeight: FontWeight.w600,
        ),
      ),
      onPressed: onTap,
    );
  }
}