import 'package:flutter/material.dart';
import 'package:school_system/core/utils/app_colors.dart';
import 'package:school_system/core/utils/app_text_style.dart';

class LessonOverviewSection extends StatelessWidget {
  final String description;

  const LessonOverviewSection({super.key, required this.description});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Overview',
              style: AppTextStyle.bold16.copyWith(
                color: AppColors.secondaryColor,
                fontSize: 22,
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              decoration: BoxDecoration(
                color: AppColors.primaryColor.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                'UNIT 4: ALGEBRA',
                style: AppTextStyle.bold12.copyWith(
                  color: AppColors.secondaryColor.withValues(alpha: 0.7),
                  fontSize: 10,
                  letterSpacing: 0.5,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: const Color(0xffF2F3FE),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Text(
            description,
            style: AppTextStyle.medium14.copyWith(
              color: AppColors.grey.withValues(alpha: 0.9),
              height: 1.6,
            ),
          ),
        ),
      ],
    );
  }
}
