import 'package:flutter/material.dart';
import '../../../view_models/project/project_create_vm.dart';
import '../../../widgets/confirm_dialog.dart';
import '../../../theme/app_colors.dart';

class ProjectActionButtons extends StatefulWidget {
  final ProjectCreateViewModel vm;
  final GlobalKey<FormState> formKey;
  final bool isEditMode;
  final Future<void> Function() onSave;

  const ProjectActionButtons({
    super.key,
    required this.vm,
    required this.formKey,
    required this.isEditMode,
    required this.onSave,
  });

  @override
  State<ProjectActionButtons> createState() => _ProjectActionButtonsState();
}

class _ProjectActionButtonsState extends State<ProjectActionButtons> {
  bool _isSaving = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.background,
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(24, 10, 24, 20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildOfflineNotice(),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(child: _buildCancelButton(context)),
                  const SizedBox(width: 12),
                  Expanded(child: _buildSaveButton(context)),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  // 1. 오프라인 안내
  Widget _buildOfflineNotice() {
    return const Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(Icons.cloud_off, size: 14, color: Color(0xFFB58A53)),
        SizedBox(width: 6),
        Text(
          "오프라인 상태에서도 로컬에 저장 후 온라인 시 자동 연동됩니다.",
          style: TextStyle(fontSize: 11, color: Color(0xFFB58A53)),
        ),
      ],
    );
  }

  // 2. 취소 버튼 및 확인 다이얼로그
  Widget _buildCancelButton(BuildContext context) {
    return OutlinedButton(
      onPressed: _isSaving
          ? null
          : () async {
        final bool confirm = await showConfirmDialog(
          context,
          title: "작성 취소",
          message: "작성 중인 내용이 저장되지 않습니다.",
        );
        if (confirm == true && context.mounted) {
          Navigator.pop(context);
        }
      },
      style: OutlinedButton.styleFrom(
        padding: const EdgeInsets.symmetric(vertical: 16),
        side: const BorderSide(color: Color(0xFFB58A53)),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
      child: const Text("취소", style: TextStyle(color: Color(0xFFB58A53))),
    );
  }

  // 3. 저장 버튼 스타일
  Widget _buildSaveButton(BuildContext context) {
    return ElevatedButton(
      onPressed: _isSaving ? null : _handleSave,
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xFFB58A53),
        disabledBackgroundColor: const Color(0xFFDCC8B0),
        padding: const EdgeInsets.symmetric(vertical: 16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
      child: _isSaving
          ? const SizedBox(
        width: 20,
        height: 20,
        child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
      )
          : Text(
        widget.isEditMode ? "수정 완료" : "저장하기",
        style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
      ),
    );
  }

  // 4. 저장 핸들러
  Future<void> _handleSave() async {
    if (widget.formKey.currentState?.validate() ?? false) {
      final bool isOnline = await widget.vm.checkConnection();

      if (!isOnline && mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("오프라인 상태입니다. 나중에 동기화됩니다."),
            duration: Duration(seconds: 2),
          ),
        );
      }

      setState(() => _isSaving = true);
      try {
        await widget.onSave();
      } finally {
        if (mounted) setState(() => _isSaving = false);
      }
    }
  }
}