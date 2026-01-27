import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../../../theme/app_colors.dart';
import '../../../../widgets/confirm_dialog.dart';

class TimerSettingSheet extends StatefulWidget {
  final Duration initialDuration;
  final void Function(Duration) onConfirm;
  final VoidCallback onCancel;

  const TimerSettingSheet({
    super.key,
    required this.initialDuration,
    required this.onConfirm,
    required this.onCancel,
  });

  @override
  State<TimerSettingSheet> createState() => _TimerSettingSheetState();
}

class _TimerSettingSheetState extends State<TimerSettingSheet> {
  static const int _maxHours = 23;
  late Duration _tempDuration;

  late final FixedExtentScrollController _hCtrl;
  late final FixedExtentScrollController _mCtrl;
  late final FixedExtentScrollController _sCtrl;

  @override
  void initState() {
    super.initState();
    // 초기값 주입 (0:0:0 방지)
    _tempDuration = widget.initialDuration;
    _hCtrl = FixedExtentScrollController(initialItem: _tempDuration.inHours);
    _mCtrl = FixedExtentScrollController(initialItem: _tempDuration.inMinutes.remainder(60));
    _sCtrl = FixedExtentScrollController(initialItem: _tempDuration.inSeconds.remainder(60));
  }

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

  Widget _wheel(FixedExtentScrollController ctrl, int count, String unit) {
    return Expanded(
      child: Stack(
        alignment: Alignment.center,
        children: [
          CupertinoPicker(
            scrollController: ctrl,
            itemExtent: 44,
            useMagnifier: true,
            magnification: 1.1,
            onSelectedItemChanged: (_) => _onWheelChanged(),
            children: List.generate(count, (i) => Center(
              child: Text(
                i.toString().padLeft(2, '0'),
                style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w600),
              ),
            )),
          ),
          // 단위 표시 (시, 분, 초)
          Positioned(
            right: 15,
            child: Text(unit, style: TextStyle(color: AppColors.foreground.withOpacity(0.5), fontSize: 13)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false, // 배경 터치로 바로 닫히는 것을 방지
      onPopInvokedWithResult: (didPop, result) async {
        if (didPop) return;

        // 수정 사항이 없으면 그냥 닫고, 있으면 컨펌창
        if (_tempDuration == widget.initialDuration) {
          Navigator.pop(context);
        } else {
          final ok = await showConfirmDialog(
            context,
            title: '설정을 취소할까요?',
            message: '변경된 내용은 저장되지 않습니다.',
            cancelText: '계속 설정',
            confirmText: '취소',
          );
          if (ok && context.mounted) Navigator.pop(context);
        }
      },
      child: SafeArea(
        child: SizedBox(
          height: MediaQuery.of(context).size.height * 0.45,
          child: Column(
            children: [
              const SizedBox(height: 8),
              Container(width: 44, height: 5, decoration: BoxDecoration(color: Colors.black12, borderRadius: BorderRadius.circular(999))),
              const SizedBox(height: 12),
              const Text('타이머 설정', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700)),

              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Row(
                    children: [
                      _wheel(_hCtrl, _maxHours + 1, '시'),
                      _wheel(_mCtrl, 60, '분'),
                      _wheel(_sCtrl, 60, '초'),
                    ],
                  ),
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
                padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
                child: Row(
                  children: [
                    Expanded(child: OutlinedButton(onPressed: widget.onCancel, child: const Text('취소'))),
                    const SizedBox(width: 12),
                    Expanded(
                      child: FilledButton(
                        onPressed: _tempDuration == Duration.zero ? null : () => widget.onConfirm(_tempDuration),
                        child: const Text('설정'),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
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
      label: Text(label, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600)),
      onPressed: onTap,
      padding: EdgeInsets.zero,
      visualDensity: VisualDensity.compact,
    );
  }
}