import 'package:flutter/material.dart';

class ProjectDetailView extends StatelessWidget {
  final String projectId;

  const ProjectDetailView({
    super.key,
    required this.projectId,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            _sectionCard(
              title: '소설 1부',
              content: '판타지 소설 집필',
            ),

            const SizedBox(height: 16),

            _infoRow('하루 목표', '하루 3시간'),
            _infoRow('주간 빈도', '주 5일 작성'),
            _infoRow('작성 기간', '2025.01.12 ~ 2025.03.04'),

            const SizedBox(height: 24),

            const Text(
              '프로젝트 상태',
              style: TextStyle(fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 10),

            Row(
              children: [
                _statusButton(context, '시작 전', false),
                const SizedBox(width: 8),
                _statusButton(context, '진행 중', true),
                const SizedBox(width: 8),
                _statusButton(context, '마감', false),
              ],
            ),

            const SizedBox(height: 24),

            const Text(
              '메모',
              style: TextStyle(fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 8),

            TextField(
              maxLines: 4,
              enabled: true, // UI 전용
              decoration: const InputDecoration(
                hintText: '프로젝트 관련 메모를 남길 수 있어요',
              ),
            ),

            const Spacer(),

            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('취소'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: FilledButton(
                    onPressed: () {
                      // context.push('/project/edit/$projectId');
                    },
                    child: const Text('수정'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _sectionCard({
    required String title,
    required String content,
  }) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              content,
              style: const TextStyle(fontSize: 13),
            ),
          ],
        ),
      ),
    );
  }

  Widget _infoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label),
          Text(
            value,
            style: const TextStyle(fontWeight: FontWeight.w500),
          ),
        ],
      ),
    );
  }
  Widget _statusButton(
      BuildContext context,
      String text,
      bool selected,
      ) {
    return Expanded(
      child: OutlinedButton(
        style: OutlinedButton.styleFrom(
          backgroundColor:
          selected ? Theme.of(context).colorScheme.primary : null,
          foregroundColor:
          selected ? Colors.white : Theme.of(context).colorScheme.onSurface,
          side: BorderSide(
            color: Theme.of(context).colorScheme.primary,
          ),
        ),
        onPressed: () {},
        child: Text(text),
      ),
    );
  }
}
