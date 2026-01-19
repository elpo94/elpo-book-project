import 'package:flutter/material.dart';
import 'confirm_dialog.dart';

/// ✅ confirm이 필요한 버튼을 공용화
/// - Reset / Delete / Cancel / Logout 등 전부 이걸로 통일 가능
///
/// 사용 예)
/// ConfirmActionButton(
///   text: '초기화',
///   dialogTitle: '타이머를 초기화할까요?',
///   dialogMessage: '누적된 시간이 00:00:00으로 돌아갑니다.\n이 작업은 되돌릴 수 없습니다.',
///   confirmText: '초기화',
///   confirmColor: const Color(0xFFD65C5C),
///   onConfirmed: () async => vm.reset(),
/// )
class ConfirmActionButton extends StatelessWidget {
  // 버튼 표시 텍스트
  final String text;

  // confirm 이후 실제 실행
  final Future<void> Function() onConfirmed;

  // 다이얼로그 문구
  final String dialogTitle;
  final String dialogMessage;
  final String cancelText;
  final String confirmText;

  // 다이얼로그 confirm 버튼 색
  final Color? confirmColor;

  // 버튼 모양
  final bool filled; // true = FilledButton, false = OutlinedButton

  // 버튼 스타일
  final ButtonStyle? style;

  // 버튼 활성화 여부
  final bool enabled;

  const ConfirmActionButton({
    super.key,
    required this.text,
    required this.onConfirmed,
    required this.dialogTitle,
    required this.dialogMessage,
    this.cancelText = '취소',
    this.confirmText = '확인',
    this.confirmColor,
    this.filled = false,
    this.style,
    this.enabled = true,
  });

  Future<void> _handlePressed(BuildContext context) async {
    if (!enabled) return;

    final ok = await showConfirmDialog(
      context,
      title: dialogTitle,
      message: dialogMessage,
      cancelText: cancelText,
      confirmText: confirmText,
      confirmColor: confirmColor,
    );

    if (!ok) return;

    await onConfirmed();
  }

  @override
  Widget build(BuildContext context) {
    final child = Text(text);

    if (filled) {
      return FilledButton(
        onPressed: enabled ? () => _handlePressed(context) : null,
        style: style,
        child: child,
      );
    }

    return OutlinedButton(
      onPressed: enabled ? () => _handlePressed(context) : null,
      style: style,
      child: child,
    );
  }
}
