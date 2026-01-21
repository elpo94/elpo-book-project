import 'package:flutter/material.dart';
import '../../../theme/app_colors.dart';

class SettingTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback? onTap;

  final bool showChevron;
  final Color? iconColor;
  final Color? titleColor;

  const SettingTile({
    super.key,
    required this.icon,
    required this.title,
    required this.subtitle,
    this.onTap,
    this.showChevron = true,
    this.iconColor,
    this.titleColor,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
          child: Row(
            children: [
              Icon(
                icon,
                size: 20,
                color: iconColor ?? AppColors.foreground.withOpacity(0.85),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: titleColor ?? AppColors.foreground,
                      ),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      subtitle,
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: AppColors.mutedOn,
                      ),
                    ),
                  ],
                ),
              ),
              if (showChevron)
                const Icon(
                  Icons.chevron_right_rounded,
                  size: 22,
                  color: AppColors.mutedOn,
                ),
            ],
          ),
        ),
      ),
    );
  }
}
