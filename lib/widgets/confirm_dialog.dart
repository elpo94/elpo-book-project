import 'package:flutter/material.dart';

Future<bool> showConfirmDialog(
    BuildContext context, {
      required String title,
      required String message,
      String cancelText = '취소',
      String confirmText = '확인',
      Color? confirmColor,
    }) async {
  final result = await showDialog<bool>(
    context: context,
    useRootNavigator: true,
    barrierDismissible: false,
    builder: (dialogContext) => AlertDialog(
      backgroundColor: const Color(0xFFFFF8EE),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      insetPadding: const EdgeInsets.symmetric(horizontal: 28, vertical: 24),
      contentPadding: const EdgeInsets.fromLTRB(20, 12, 20, 8),
      title: Text(
        title,
        textAlign: TextAlign.center,
        style: const TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 18,
          color: Color(0xFF3A2B1A),
        ),
      ),
      content: Text(
        message,
        textAlign: TextAlign.center,
        style: const TextStyle(color: Color(0xFF5A4632), fontSize: 14),
      ),
      actionsPadding: const EdgeInsets.fromLTRB(20, 10, 20, 16),
      actions: [
        Row(
          children: [
            Expanded(
              child: OutlinedButton(
                // dialogContext로 pop
                onPressed: () => Navigator.of(dialogContext, rootNavigator: true)
                    .pop(false),
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  backgroundColor: const Color(0xFFF3E9D2),
                  side: const BorderSide(color: Color(0xFFE1D5C7)),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
                child: Text(
                  cancelText,
                  style: const TextStyle(
                    color: Color(0xFF5A4632),
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: FilledButton(
                // 반드시 dialogContext로 pop
                onPressed: () => Navigator.of(dialogContext, rootNavigator: true)
                    .pop(true),
                style: FilledButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  backgroundColor: confirmColor ?? const Color(0xFFD65C5C),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
                child: Text(
                  confirmText,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    ),
  );

  return result ?? false;
}
