import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../../widgets/confirm_dialog.dart';

class TimerSettingSheet extends StatefulWidget {
  final Duration initial;
  final void Function(Duration) onConfirm;

  const TimerSettingSheet({
    super.key,
    required this.initial,
    required this.onConfirm,
  });

  @override
  State<TimerSettingSheet> createState() => _TimerSettingSheetState();
}

class _TimerSettingSheetState extends State<TimerSettingSheet> {
  static const int _maxHours = 23;

  late Duration _tempDuration;

  late FixedExtentScrollController _hCtrl;
  late FixedExtentScrollController _mCtrl;
  late FixedExtentScrollController _sCtrl;

  @override
  void initState() {
    super.initState();
    _tempDuration = widget.initial;

    final h = _clamp(widget.initial.inHours, 0, _maxHours);
    final m = widget.initial.inMinutes.remainder(60);
    final s = widget.initial.inSeconds.remainder(60);

    _hCtrl = FixedExtentScrollController(initialItem: h);
    _mCtrl = FixedExtentScrollController(initialItem: m);
    _sCtrl = FixedExtentScrollController(initialItem: s);
  }

  @override
  void dispose() {
    _hCtrl.dispose();
    _mCtrl.dispose();
    _sCtrl.dispose();
    super.dispose();
  }

  int _clamp(int v, int min, int max) => v < min ? min : (v > max ? max : v);

  Duration _composeDuration({required int h, required int m, required int s}) {
    return Duration(hours: h, minutes: m, seconds: s);
  }

  Future<void> _setDuration(Duration d, {bool animate = true}) async {
    final h = _clamp(d.inHours, 0, _maxHours);
    final m = d.inMinutes.remainder(60);
    final s = d.inSeconds.remainder(60);

    setState(() {
      _tempDuration = _composeDuration(h: h, m: m, s: s);
    });

    if (!animate) return;

    // 컨트롤러가 아직 attach 안 된 타이밍을 피하려고 postFrame으로 한 번 감쌈
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;

      _hCtrl.animateToItem(h, duration: const Duration(milliseconds: 180), curve: Curves.easeOut);
      _mCtrl.animateToItem(m, duration: const Duration(milliseconds: 180), curve: Curves.easeOut);
      _sCtrl.animateToItem(s, duration: const Duration(milliseconds: 180), curve: Curves.easeOut);
    });
  }

  void _onWheelChanged() {
    final h = _hCtrl.selectedItem;
    final m = _mCtrl.selectedItem;
    final s = _sCtrl.selectedItem;

    setState(() {
      _tempDuration = _composeDuration(h: h, m: m, s: s);
    });
  }

  Widget _numberWheel({
    required FixedExtentScrollController controller,
    required int itemCount,
    required void Function(int) onSelectedItemChanged,
  }) {
    return CupertinoPicker(
      scrollController: controller,
      itemExtent: 44,
      useMagnifier: true,
      magnification: 1.08,
      onSelectedItemChanged: onSelectedItemChanged,
      children: List.generate(
        itemCount,
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

    final sheetHeight = media.size.height * 0.45;

    // ✅ 하단 safeArea(홈 인디케이터)만큼 여유 확보
    final bottomInset = media.padding.bottom;

    return SafeArea(
      child: SizedBox(
        height: sheetHeight,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            // drag handle
            const SizedBox(height: 8),
            Container(
              width: 44,
              height: 5,
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.12),
                borderRadius: BorderRadius.circular(999),
              ),
            ),
            const SizedBox(height: 10),

            const Text(
              '타이머 설정',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
            ),

            const SizedBox(height: 8),


            Expanded(
              flex: 7,
              child: Center(
                child: SizedBox(
                  width: media.size.width * 0.9,
                  child: Row(
                    children: [
                      Expanded(
                        child: _numberWheel(
                          controller: _hCtrl,
                          itemCount: _maxHours + 1,
                          onSelectedItemChanged: (_) => _onWheelChanged(),
                        ),
                      ),
                      Expanded(
                        child: _numberWheel(
                          controller: _mCtrl,
                          itemCount: 60,
                          onSelectedItemChanged: (_) => _onWheelChanged(),
                        ),
                      ),
                      Expanded(
                        child: _numberWheel(
                          controller: _sCtrl,
                          itemCount: 60,
                          onSelectedItemChanged: (_) => _onWheelChanged(),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            const SizedBox(height: 6),

            // ✅ Preset: 적당히만
            Expanded(
              flex: 2,
              child: Align(
                alignment: Alignment.topCenter,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Wrap(
                    spacing: 10,
                    runSpacing: 10,
                    alignment: WrapAlignment.center,
                    children: [
                      _PresetChip(
                        label: '10분',
                        onTap: () => _setDuration(const Duration(minutes: 10)),
                      ),
                      _PresetChip(
                        label: '15분',
                        onTap: () => _setDuration(const Duration(minutes: 15)),
                      ),
                      _PresetChip(
                        label: '30분',
                        onTap: () => _setDuration(const Duration(minutes: 30)),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            // ✅ Bottom Buttons (고정)
            Padding(
              padding: EdgeInsets.fromLTRB(16, 4, 16, 12),
              child: Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () async {
                        final ok = await showConfirmDialog(
                          context,
                          title: '취소하시겠습니까?',
                          message: '설정한 내용은 저장되지 않습니다.',
                          cancelText: '계속 설정',
                          confirmText: '취소',
                          confirmColor: const Color(0xFFD65C5C),
                        );

                        if (ok && mounted) Navigator.pop(context);
                      },
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

  const _PresetChip({
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ActionChip(
      label: Text(label),
      onPressed: onTap,
    );
  }
}