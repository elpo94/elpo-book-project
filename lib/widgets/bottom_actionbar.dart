import 'package:flutter/material.dart';

class BottomActionBar extends StatelessWidget {
  final VoidCallback onCancel;
  final VoidCallback onConfirm;
  final String confirmText;

  const BottomActionBar({
    super.key,
    required this.onCancel,
    required this.onConfirm,
    required this.confirmText,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: OutlinedButton(
            onPressed: onCancel,
            child: const Text('취소'),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: FilledButton(
            onPressed: onConfirm,
            child: Text(confirmText),
          ),
        ),
      ],
    );
  }
}
