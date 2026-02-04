import 'package:flutter/material.dart';
import '../../../view_models/project/project_create_vm.dart';

class ProjectDaySelector extends StatelessWidget {
  final ProjectCreateViewModel vm;
  final double screenWidth;

  const ProjectDaySelector({
    super.key,
    required this.vm,
    required this.screenWidth,
  });

  @override
  Widget build(BuildContext context) {
    // ✅ [수정] itemSize 계산 로직을 build 메서드 안에 포함시킵니다. [cite: 2026-02-04]
    double itemSize = (screenWidth - 120) / 7;
    if (itemSize > 45) itemSize = 45;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "반복 요일",
          style: TextStyle( // ✅ [수정] 중첩된 TextStyle 구조를 하나로 정리했습니다. [cite: 2026-02-04]
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: Color(0xFFB58A53),
          ),
        ),
        const SizedBox(height: 12),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: List.generate(7, (index) {
            final isSelected = vm.selectedDays[index];
            return GestureDetector(
              onTap: () => vm.toggleDay(index),
              child: Container(
                width: itemSize,
                height: itemSize,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: isSelected ? const Color(0xFFB58A53) : Colors.white,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  vm.days[index],
                  style: TextStyle(
                    color: isSelected ? Colors.white : const Color(0xFF5A4632),
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            );
          }),
        ),
      ],
    );
  }
}