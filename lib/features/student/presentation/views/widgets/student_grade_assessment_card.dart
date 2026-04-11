import 'package:flutter/material.dart';
import 'package:school_system/core/utils/app_colors.dart';
import 'package:school_system/core/utils/app_text_style.dart';

class StudentGradeAssessmentCard extends StatelessWidget {
  final String badgeText;
  final Color badgeColor;
  final Color badgeBackgroundColor;
  final String dateString;
  final String title;
  final String grade;
  final String totalGrade;
  final Color gradeColor;
  final String? statusText;
  final Color? statusColor;
  final Color? statusBackgroundColor;

  const StudentGradeAssessmentCard({
    super.key,
    required this.badgeText,
    required this.badgeColor,
    required this.badgeBackgroundColor,
    required this.dateString,
    required this.title,
    required this.grade,
    required this.totalGrade,
    required this.gradeColor,
    this.statusText,
    this.statusColor,
    this.statusBackgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: badgeBackgroundColor,
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  badgeText.toUpperCase(),
                  style: AppTextStyle.bold12.copyWith(
                    color: badgeColor,
                    fontSize: 9,
                    letterSpacing: 0.5,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Text(
                dateString,
                style: AppTextStyle.medium12.copyWith(
                  color: AppColors.grey,
                  fontSize: 11,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            title,
            style: AppTextStyle.bold16.copyWith(
              color: AppColors.darkBlue,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                grade,
                style: AppTextStyle.bold24.copyWith(
                  color: gradeColor,
                  fontSize: 28,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 4, left: 4),
                child: Text(
                  '/ $totalGrade',
                  style: AppTextStyle.medium14.copyWith(
                    color: AppColors.darkBlue,
                    fontSize: 12,
                  ),
                ),
              ),
              const SizedBox(width: 16),
              if (statusText != null && statusBackgroundColor != null)
                Padding(
                  padding: const EdgeInsets.only(bottom: 6),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: statusBackgroundColor,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      statusText!,
                      style: AppTextStyle.bold12.copyWith(
                        color: statusColor,
                        fontSize: 10,
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }
}
