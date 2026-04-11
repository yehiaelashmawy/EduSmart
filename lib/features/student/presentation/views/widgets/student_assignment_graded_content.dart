import 'package:flutter/material.dart';
import 'package:school_system/core/utils/app_colors.dart';
import 'package:school_system/core/utils/app_text_style.dart';

class StudentAssignmentGradedContent extends StatelessWidget {
  final String? grade;
  final String? totalGrade;
  final String? feedback;
  final Color statusColor;

  const StudentAssignmentGradedContent({
    super.key,
    required this.grade,
    required this.totalGrade,
    required this.feedback,
    required this.statusColor,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'GRADE',
              style: AppTextStyle.bold12.copyWith(
                color: AppColors.grey,
                fontSize: 10,
              ),
            ),
            const SizedBox(height: 4),
            Row(
              crossAxisAlignment: CrossAxisAlignment.baseline,
              textBaseline: TextBaseline.alphabetic,
              children: [
                Text(
                  grade ?? '0',
                  style: AppTextStyle.bold24.copyWith(color: statusColor),
                ),
                Text(
                  '/$totalGrade',
                  style: AppTextStyle.bold14.copyWith(color: AppColors.grey),
                ),
              ],
            ),
          ],
        ),
        Container(
          height: 40,
          width: 1,
          color: AppColors.lightGrey.withValues(alpha: 0.5),
          margin: const EdgeInsets.symmetric(horizontal: 16),
        ),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'FEEDBACK',
                style: AppTextStyle.bold12.copyWith(
                  color: AppColors.grey,
                  fontSize: 10,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                feedback ?? '',
                style: AppTextStyle.medium12.copyWith(color: AppColors.grey),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
