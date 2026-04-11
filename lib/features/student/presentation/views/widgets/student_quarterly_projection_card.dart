import 'package:flutter/material.dart';
import 'package:school_system/core/utils/app_colors.dart';
import 'package:school_system/core/utils/app_text_style.dart';

class StudentQuarterlyProjectionCard extends StatelessWidget {
  final int examsCount;
  final int tasksCount;
  final int averagePercentage;
  final String statusMessage;

  const StudentQuarterlyProjectionCard({
    super.key,
    required this.examsCount,
    required this.tasksCount,
    required this.averagePercentage,
    required this.statusMessage,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 20),
      decoration: BoxDecoration(
        color: AppColors.primaryColor.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          Text(
            'QUARTERLY PROJECTION',
            style: AppTextStyle.bold12.copyWith(
              color: AppColors.darkBlue,
              letterSpacing: 1.0,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            statusMessage,
            style: AppTextStyle.medium14.copyWith(
              color: AppColors.secondaryColor, // Or active primary blue
            ),
          ),
          const SizedBox(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildStatColumn(value: examsCount.toString(), label: 'EXAMS'),
              Container(
                height: 36,
                width: 1,
                color: AppColors.darkBlue.withValues(alpha: 0.15),
                margin: const EdgeInsets.symmetric(horizontal: 20),
              ),
              _buildStatColumn(value: tasksCount.toString(), label: 'TASKS'),
              Container(
                height: 36,
                width: 1,
                color: AppColors.darkBlue.withValues(alpha: 0.15),
                margin: const EdgeInsets.symmetric(horizontal: 20),
              ),
              _buildStatColumn(value: '$averagePercentage%', label: 'AVG'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatColumn({required String value, required String label}) {
    return Column(
      children: [
        Text(
          value,
          style: AppTextStyle.bold24.copyWith(
            color: AppColors.darkBlue,
            fontSize: 26,
            height: 1.0,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: AppTextStyle.bold12.copyWith(
            color: AppColors.darkBlue.withValues(alpha: 0.8),
            fontSize: 9,
            letterSpacing: 0.5,
          ),
        ),
      ],
    );
  }
}
