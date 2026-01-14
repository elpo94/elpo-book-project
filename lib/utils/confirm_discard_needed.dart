import 'package:flutter/material.dart';
import '../widgets/confirm_dialog.dart';

Future<bool> confirmDiscardIfNeeded(
    BuildContext context, {
      required bool isDirty,
      String title = '취소하시겠습니까?',
      String message = '작성한 내용은 저장되지 않습니다.',
    }) async {
  if (!isDirty) return true;

  return showConfirmDialog(
    context,
    title: title,
    message: message,
    cancelText: '계속 작성',
    confirmText: '취소',
    confirmColor: const Color(0xFFD65C5C),
  );
}
