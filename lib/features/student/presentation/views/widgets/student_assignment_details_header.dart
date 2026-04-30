import 'package:flutter/material.dart';
import 'package:school_system/core/utils/app_colors.dart';
import 'package:school_system/core/utils/app_text_style.dart';

class StudentAssignmentDetailsHeader extends StatelessWidget {
  final String subjectName;
  final String title;
  final String dueTime;
  final String points;
  final String dateDay;
  final String dateMonth;

  const StudentAssignmentDetailsHeader({
    super.key,
    required this.subjectName,
    required this.title,
    required this.dueTime,
    required this.points,
    required this.dateDay,
    required this.dateMonth,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppColors.primaryColor.withValues(alpha: 0.05),
            Colors.white,
          ],
        ),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: AppColors.primaryColor.withValues(alpha: 0.1)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            AppColors.primaryColor.withValues(alpha: 0.8),
                            AppColors.primaryColor,
                          ],
                        ),
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.primaryColor.withValues(alpha: 0.2),
                            blurRadius: 8,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Text(
                        subjectName.toUpperCase(),
                        style: AppTextStyle.bold12.copyWith(
                          color: Colors.white,
                          fontSize: 10,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Text(
                  title,
                  style: AppTextStyle.bold24.copyWith(
                    color: AppColors.darkBlue,
                    height: 1.2,
                  ),
                ),
                const SizedBox(height: 20),
                Wrap(
                  spacing: 16,
                  runSpacing: 12,
                  children: [
                    _InfoChip(
                      icon: Icons.access_time_rounded,
                      label: 'Due: $dueTime',
                      color: AppColors.secondaryColor,
                    ),
                    _InfoChip(
                      icon: Icons.stars_rounded,
                      label: '$points Points',
                      color: const Color(0xff12B76A),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(width: 16),
          _CalendarCard(day: dateDay, month: dateMonth),
        ],
      ),
    );
  }
}

class _InfoChip extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;

  const _InfoChip({
    required this.icon,
    required this.label,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          padding: const EdgeInsets.all(4),
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.1),
            shape: BoxShape.circle,
          ),
          child: Icon(icon, size: 14, color: color),
        ),
        const SizedBox(width: 8),
        Text(
          label,
          style: AppTextStyle.medium12.copyWith(
            color: AppColors.grey,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}

class _CalendarCard extends StatelessWidget {
  final String day;
  final String month;

  const _CalendarCard({required this.day, required this.month});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 64,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 6),
            decoration: const BoxDecoration(
              color: Color(0xffD92D20),
              borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
            ),
            child: Text(
              month.toUpperCase(),
              textAlign: TextAlign.center,
              style: AppTextStyle.bold12.copyWith(
                color: Colors.white,
                fontSize: 10,
                letterSpacing: 1,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 12),
            child: Text(
              day,
              style: AppTextStyle.bold24.copyWith(
                color: AppColors.darkBlue,
                height: 1.0,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
