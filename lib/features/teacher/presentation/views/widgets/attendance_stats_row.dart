import 'package:flutter/material.dart';
import 'package:school_system/core/utils/app_colors.dart';
import 'package:school_system/core/utils/app_text_style.dart';
import 'package:school_system/core/utils/theme_manager.dart';

class AttendanceStatsRow extends StatelessWidget {
  final int enrolledCount;
  final int absentCount;

  const AttendanceStatsRow({
    super.key,
    required this.enrolledCount,
    required this.absentCount,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _StatCard(
            value: enrolledCount.toString(),
            label: 'ENROLLED',
            valueColor: const Color(0xff065AD8),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: _StatCard(
            value: absentCount.toString(),
            label: 'MARKED ABSENT',
            valueColor: const Color(0xff993300),
          ),
        ),
      ],
    );
  }
}

class _StatCard extends StatelessWidget {
  final String value;
  final String label;
  final Color valueColor;

  const _StatCard({
    required this.value,
    required this.label,
    required this.valueColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 20),
      decoration: BoxDecoration(
        color: ThemeManager.isDarkMode ? AppColors.lightGrey.withOpacity(0.2) : const Color(0xffF4F7FB),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Text(
            value,
            style: AppTextStyle.bold24.copyWith(color: valueColor, fontSize: 28),
          ),
          const SizedBox(height: 8),
          Text(
            label,
            style: AppTextStyle.bold12.copyWith(
              color: AppColors.grey,
              letterSpacing: 1.2,
            ),
          ),
        ],
      ),
    );
  }
}
