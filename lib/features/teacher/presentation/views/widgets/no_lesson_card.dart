import 'package:flutter/material.dart';
import 'package:school_system/core/utils/app_colors.dart';
import 'package:school_system/core/utils/app_text_style.dart';

class NoLessonCard extends StatelessWidget {
  const NoLessonCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.lightGrey.withValues(alpha: 0.5)),
      ),
      child: Column(
        children: [
          Icon(
            Icons.event_busy_rounded,
            size: 48,
            color: AppColors.lightGrey,
          ),
          const SizedBox(height: 12),
          Text(
            'No Lessons Available',
            style: AppTextStyle.bold16.copyWith(color: AppColors.darkBlue),
          ),
          const SizedBox(height: 6),
          Text(
            'There are no active lessons for this class. Please add a lesson first.',
            style: AppTextStyle.medium14.copyWith(
              color: AppColors.grey,
              height: 1.4,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
