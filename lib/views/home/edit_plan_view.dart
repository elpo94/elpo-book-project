import 'package:flutter/material.dart';

class EditPlanView extends StatefulWidget {
  const EditPlanView({super.key});

  @override
  State<EditPlanView> createState() => _EditPlanViewState();
}

class _EditPlanViewState extends State<EditPlanView> {
  final TextEditingController titleController = TextEditingController();
  final TextEditingController memoController = TextEditingController();

  /// 요일 선택 상태
  List<bool> selected = List.generate(7, (_) => false);

  final List<String> days = ["월","화","수","목","금","토","일"];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("플랜 수정"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            /// 제목
            const Text(
              "목표 제목",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 6),

            TextField(
              controller: titleController,
              decoration: const InputDecoration(
                hintText: "예: 소설 루트 프로토콜 세계관 정리",
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 18),

            /// 요일 선택
            const Text(
              "반복 요일",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),

            Row(
              children: List.generate(7, (index) {
                return Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 1),
                    child: ChoiceChip(
                      label: Center(child: Text(days[index])),
                      selected: selected[index],
                      onSelected: (_) {
                        setState(() {
                          selected[index] = !selected[index];
                        });
                      },
                      selectedColor: Theme.of(context).colorScheme.primary,
                      labelStyle: TextStyle(
                        color: selected[index]
                            ? Colors.white
                            : Colors.black,
                      ),
                    ),
                  ),
                );
              }),
            ),

            const SizedBox(height: 18),

            /// 메모
            const Text(
              "세부 메모",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 6),

            TextField(
              controller: memoController,
              maxLines: 4,
              decoration: const InputDecoration(
                hintText: "필요시 추가 기록을 남겨주세요",
                border: OutlineInputBorder(),
              ),
            ),

            const Spacer(),

            /// 저장 버튼
            SizedBox(
              width: double.infinity,
              child: FilledButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text("저장"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
