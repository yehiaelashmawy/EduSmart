import 'package:flutter/material.dart';
import 'package:school_system/core/utils/app_colors.dart';
import 'package:school_system/core/utils/app_text_style.dart';

class ActiveCourseCard extends StatelessWidget {
  final String courseName;
  final String location;

  const ActiveCourseCard({
    super.key,
    required this.courseName,
    required this.location,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Active Course',
            style: AppTextStyle.medium14.copyWith(color: AppColors.grey),
          ),
          const SizedBox(height: 6),
          Text(
            courseName,
            style: AppTextStyle.bold16.copyWith(
              color: AppColors.primaryColor,
              fontSize: 17,
            ),
          ),
          const SizedBox(height: 6),
          Row(
            children: [
              Icon(
                Icons.location_on_outlined,
                size: 14,
                color: AppColors.grey,
              ),
              const SizedBox(width: 4),
              Text(
                location,
                style: AppTextStyle.medium12.copyWith(color: AppColors.grey),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
