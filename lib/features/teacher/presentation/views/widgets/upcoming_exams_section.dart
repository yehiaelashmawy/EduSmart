import 'package:flutter/material.dart';
import 'package:school_system/core/utils/app_colors.dart';
import 'package:school_system/core/utils/app_text_style.dart';

class UpcomingExamsSection extends StatelessWidget {
  const UpcomingExamsSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Upcoming Exams', style: AppTextStyle.bold20),
        const SizedBox(height: 16),
        _buildExamCard(
          month: 'OCT',
          day: '12',
          title: 'Mid-Term Math',
          subtitle: 'Grade 10 • 45 Students',
          statusText: 'In 2 Days',
          statusColor: const Color(0xFFF97316), // Orange
        ),
        const SizedBox(height: 16),
        _buildExamCard(
          month: 'OCT',
          day: '15',
          title: 'Physics Quiz',
          subtitle: 'Grade 12 • 28 Students',
          statusText: 'In 5 Days',
          statusColor: AppColors.grey,
        ),
      ],
    );
  }

  Widget _buildExamCard({
    required String month,
    required String day,
    required String title,
    required String subtitle,
    required String statusText,
    required Color statusColor,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.lightGrey.withOpacity(0.4)),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: AppColors.primaryColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              children: [
                Text(month, style: AppTextStyle.semiBold14.copyWith(color: AppColors.primaryColor, fontSize: 12)),
                Text(day, style: AppTextStyle.bold20.copyWith(color: AppColors.primaryColor)),
              ],
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: AppTextStyle.bold16),
                const SizedBox(height: 4),
                Text(subtitle, style: AppTextStyle.regular14.copyWith(color: AppColors.grey, fontSize: 13)),
              ],
            ),
          ),
          Text(statusText, style: AppTextStyle.bold14.copyWith(color: statusColor)),
        ],
      ),
    );
  }
}
