import 'package:flutter/material.dart';
import '../../../theme/app_colors.dart';

class SettingCard extends StatelessWidget {
  final List<Widget> children;
  const SettingCard({super.key, required this.children});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(children: _withDividers(children)),
    );
  }

  List<Widget> _withDividers(List<Widget> tiles) {
    final result = <Widget>[];
    for (int i = 0; i < tiles.length; i++) {
      result.add(tiles[i]);
      if (i != tiles.length - 1) {
        result.add(
          Divider(
            height: 1,
            thickness: 0.6,
            color: AppColors.border.withOpacity(0.7),
          ),
        );
      }
    }
    return result;
  }
}
