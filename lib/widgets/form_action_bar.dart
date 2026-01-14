import 'package:flutter/material.dart';

class FormActionBar extends StatelessWidget {
  final VoidCallback onCancel;
  final VoidCallback onSave;
  final String cancelText;
  final String saveText;
  final bool saveEnabled;

  const FormActionBar({
    super.key,
    required this.onCancel,
    required this.onSave,
    this.cancelText = '취소',
    this.saveText = '저장',
    this.saveEnabled = true,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
      child: Row(
        children: [
          Expanded(
            child: OutlinedButton(
              onPressed: onCancel,
              child: Text(cancelText),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: FilledButton(
              onPressed: saveEnabled ? onSave : null,
              child: Text(saveText),
            ),
          ),
        ],
      ),
    );
  }
}
