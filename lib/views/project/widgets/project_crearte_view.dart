import 'package:flutter/material.dart';

class ProjectCreateView extends StatefulWidget {
  const ProjectCreateView({super.key});

  @override
  State<ProjectCreateView> createState() => _ProjectCreateViewState();
}

class _ProjectCreateViewState extends State<ProjectCreateView> {
  final titleController = TextEditingController();
  final descriptionController = TextEditingController();
  final dailyGoalController = TextEditingController();
  final weeklyGoalController = TextEditingController();
  final periodController = TextEditingController();

  /// 요일 선택 상태
  final List<bool> selectedDays = List.generate(7, (_) => false);
  final List<String> days = ['월', '화', '수', '목', '금', '토', '일'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('사부작'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            /// 프로젝트 이름
            _sectionTitle('프로젝트 이름'),
            TextField(
              controller: titleController,
              decoration: const InputDecoration(
                hintText: '예: 소설 1부',
              ),
            ),

            const SizedBox(height: 18),

            /// 프로젝트 설명
            _sectionTitle('설명'),
            TextField(
              controller: descriptionController,
              maxLines: 3,
              decoration: const InputDecoration(
                hintText: '프로젝트에 대한 간단한 설명',
              ),
            ),

            const SizedBox(height: 18),

            /// 작성 기간
            _sectionTitle('작성 기간'),
            TextField(
              controller: periodController,
              readOnly: true,
              decoration: const InputDecoration(
                hintText: '날짜를 선택하세요',
              ),
            ),

            const SizedBox(height: 18),

            /// 하루 목표
            _sectionTitle('하루 목표'),
            TextField(
              controller: dailyGoalController,
              decoration: const InputDecoration(
                hintText: '예: 하루 3시간',
              ),
            ),

            const SizedBox(height: 18),

            /// 주간 빈도
            _sectionTitle('주간 빈도'),
            TextField(
              controller: weeklyGoalController,
              decoration: const InputDecoration(
                hintText: '예: 주 5일',
              ),
            ),

            const SizedBox(height: 18),

            /// 반복 요일
            _sectionTitle('반복 요일'),
            const SizedBox(height: 8),
            Row(
              children: List.generate(7, (index) {
                return Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 2),
                    child: ChoiceChip(
                      label: Text(days[index]),
                      selected: selectedDays[index],
                      onSelected: (_) {
                        setState(() {
                          selectedDays[index] = !selectedDays[index];
                        });
                      },
                    ),
                  ),
                );
              }),
            ),

            const SizedBox(height: 32),

            /// 하단 버튼
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: const Text('취소'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: FilledButton(
                    onPressed: () {
                      // 나중에 저장
                    },
                    child: const Text('저장'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _sectionTitle(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Text(
        text,
        style: const TextStyle(
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
