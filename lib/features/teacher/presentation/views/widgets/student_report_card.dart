import 'package:flutter/material.dart';
import 'package:school_system/core/utils/app_colors.dart';
import 'package:school_system/core/utils/app_text_style.dart';
import 'package:school_system/core/utils/theme_manager.dart';

class StudentReportCard extends StatelessWidget {
  final String name;
  final String rollNumber;
  final int attendancePercentage;
  final String avatarPath;

  const StudentReportCard({
    super.key,
    required this.name,
    required this.rollNumber,
    required this.attendancePercentage,
    required this.avatarPath,
  });

  @override
  Widget build(BuildContext context) {
    // Determine color based on percentage
    final Color progressColor = attendancePercentage >= 80
        ? const Color(0xff10B981) // Green
        : attendancePercentage >= 60
            ? const Color(0xffF59E0B) // Orange
            : const Color(0xffEF4444); // Red

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: ThemeManager.isDarkMode
            ? AppColors.lightGrey.withOpacity(0.1)
            : AppColors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: ThemeManager.isDarkMode
              ? Colors.transparent
              : AppColors.lightGrey.withOpacity(0.3),
        ),
      ),
      child: Row(
        children: [
          // Avatar
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: AppColors.lightGrey.withOpacity(0.4),
              image: avatarPath.isNotEmpty
                  ? DecorationImage(
                      image: AssetImage(avatarPath),
                      fit: BoxFit.cover,
                    )
                  : null,
            ),
            child: avatarPath.isEmpty
                ? const Icon(Icons.person, color: Colors.grey)
                : null,
          ),
          const SizedBox(width: 16),
          
          // Student Info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: AppTextStyle.semiBold16.copyWith(
                    color: AppColors.black,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Roll No: $rollNumber',
                  style: AppTextStyle.medium12.copyWith(
                    color: AppColors.grey,
                  ),
                ),
              ],
            ),
          ),
          
          const SizedBox(width: 16),
          
          // Percentage & Progress
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                '$attendancePercentage%',
                style: AppTextStyle.bold16.copyWith(
                  color: progressColor,
                ),
              ),
              const SizedBox(height: 6),
              Container(
                width: 60,
                height: 6,
                decoration: BoxDecoration(
                  color: progressColor.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(3),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 60 * (attendancePercentage / 100),
                      height: 6,
                      decoration: BoxDecoration(
                        color: progressColor,
                        borderRadius: BorderRadius.circular(3),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
