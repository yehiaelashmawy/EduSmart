import 'package:flutter/material.dart';
import 'package:school_system/core/utils/app_colors.dart';
import 'package:school_system/core/utils/app_text_style.dart';

class AttendanceMethodCard extends StatelessWidget {
  final Widget icon;
  final String title;
  final String subtitle;
  final String actionText;
  final IconData actionIcon;
  final bool isPrimary;
  final VoidCallback onTap;

  const AttendanceMethodCard({
    super.key,
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.actionText,
    this.actionIcon = Icons.chevron_right,
    this.isPrimary = false,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: isPrimary ? const Color(0xff065AD8) : AppColors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            if (!isPrimary)
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.04),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            icon,
            const SizedBox(height: 20),
            Text(
              title,
              style: AppTextStyle.bold16.copyWith(
                color: isPrimary ? Colors.white : AppColors.black,
                fontSize: 18,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              subtitle,
              style: AppTextStyle.medium14.copyWith(
                color: isPrimary
                    ? Colors.white.withValues(alpha: 0.8)
                    : AppColors.grey,
                height: 1.5,
              ),
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                Text(
                  actionText,
                  style: AppTextStyle.bold14.copyWith(
                    color: isPrimary ? Colors.white : AppColors.primaryColor,
                    letterSpacing: 1.2,
                  ),
                ),
                const SizedBox(width: 4),
                Icon(
                  actionIcon,
                  color: isPrimary ? Colors.white : AppColors.primaryColor,
                  size: 18,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
