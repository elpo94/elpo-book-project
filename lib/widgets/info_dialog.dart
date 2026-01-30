import 'package:flutter/material.dart';

Future<void> showInfoDialog(
    BuildContext context, {
      required String title,
      required String message,
      String confirmText = '확인',
    }) async {
  await showDialog<void>(
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
        SizedBox(
          width: double.infinity,
          child: FilledButton(
            onPressed: () =>
                Navigator.of(dialogContext, rootNavigator: true).pop(),
            style: FilledButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 14),
              backgroundColor: const Color(0xFFB58A53),
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
  );
}
