import 'package:flutter/material.dart';

class WeeklyDaySelector extends StatelessWidget {
  const WeeklyDaySelector({super.key});

  @override
  Widget build(BuildContext context) {
    final days = ["월","화","수","목","금","토","일"];

    return Wrap(
      spacing: 10,
      children: days.map((d) {
        return ChoiceChip(
          label: Text(d),
          selected: false,   // 지금은 UI만
          onSelected: (_) {},
        );
      }).toList(),
    );
  }
}
