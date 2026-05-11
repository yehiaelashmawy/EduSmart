import 'package:flutter/material.dart';
import 'package:school_system/core/utils/app_colors.dart';
import 'package:school_system/core/utils/app_text_style.dart';

class HomeworkItemCard extends StatelessWidget {
  const HomeworkItemCard({
    super.key,
    required this.title,
    required this.subtitle,
    required this.statusText,
    required this.badgeColor,
    required this.badgeTextColor,
    this.updatedTime,
    required this.dueDate,
    required this.submissions,
    this.avgGrade,
    this.progress,
    required this.isOverdue,
    required this.onDetailsTap,
    required this.onReviewTap,
    this.totalMarks,
  });

  final String title;
  final String subtitle;
  final String statusText;
  final Color badgeColor;
  final Color badgeTextColor;
  final String? updatedTime;
  final String dueDate;
  final String submissions;
  final String? avgGrade;
  final double? progress;
  final bool isOverdue;
  final VoidCallback onDetailsTap;
  final VoidCallback onReviewTap;
  final int? totalMarks;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: badgeColor,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  statusText,
                  style: TextStyle(
                    color: badgeTextColor,
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 0.5,
                  ),
                ),
              ),
              if (updatedTime != null)
                Text(
                  updatedTime!,
                  style: TextStyle(
                    color: AppColors.grey.withValues(alpha: 0.8),
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            title,
            style: AppTextStyle.bold18.copyWith(color: AppColors.black),
          ),
          const SizedBox(height: 4),
          Text(
            subtitle,
            style: AppTextStyle.regular14.copyWith(color: AppColors.grey),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: Row(
                  children: [
                    Icon(
                      Icons.calendar_today_outlined,
                      size: 16,
                      color: isOverdue ? Colors.red : AppColors.primaryColor,
                    ),
                    const SizedBox(width: 8),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'DUE DATE',
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                            color: AppColors.grey.withValues(alpha: 0.8),
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          dueDate,
                          style: AppTextStyle.bold14.copyWith(
                            color: isOverdue ? Colors.red : AppColors.black,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Row(
                  children: [
                    Icon(
                      Icons.people_outline,
                      size: 18,
                      color: AppColors.primaryColor,
                    ),
                    const SizedBox(width: 8),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'SUBMISSIONS',
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                            color: AppColors.grey.withValues(alpha: 0.8),
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          submissions,
                          style: AppTextStyle.bold14.copyWith(
                            color: AppColors.black,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          if (avgGrade != null) ...[
            const SizedBox(height: 12),
            Row(
              children: [
                Icon(
                  Icons.insights_outlined,
                  size: 18,
                  color: const Color(0xFF10B981),
                ),
                const SizedBox(width: 8),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'AVERAGE SCORE',
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                        color: AppColors.grey.withValues(alpha: 0.8),
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      '$avgGrade/${totalMarks ?? 100}',
                      style: AppTextStyle.bold14.copyWith(
                        color: AppColors.black,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
          if (progress != null) ...[
            const SizedBox(height: 16),
            Stack(
              children: [
                Container(
                  height: 6,
                  decoration: BoxDecoration(
                    color: AppColors.lightGrey.withValues(alpha: 0.5),
                    borderRadius: BorderRadius.circular(3),
                  ),
                ),
                LayoutBuilder(
                  builder: (context, constraints) {
                    return Container(
                      height: 6,
                      width: constraints.maxWidth * progress!,
                      decoration: BoxDecoration(
                        color: AppColors.primaryColor,
                        borderRadius: BorderRadius.circular(3),
                      ),
                    );
                  },
                ),
              ],
            ),
          ],
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: onDetailsTap,
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    side: BorderSide(color: AppColors.primaryColor),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Text(
                    'View Details',
                    style: AppTextStyle.semiBold14
                        .copyWith(color: AppColors.primaryColor),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: ElevatedButton(
                  onPressed: onReviewTap,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.secondaryColor,
                    elevation: 0,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Text(
                    'Review Submission',
                    style: AppTextStyle.semiBold14.copyWith(color: Colors.white),
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
