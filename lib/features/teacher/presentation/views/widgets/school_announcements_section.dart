import 'package:flutter/material.dart';
import 'package:school_system/core/utils/app_colors.dart';
import 'package:school_system/core/utils/app_text_style.dart';

class SchoolAnnouncementsSection extends StatelessWidget {
  const SchoolAnnouncementsSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.primaryColor.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.campaign_outlined,
                color: AppColors.primaryColor,
                size: 24,
              ),
              const SizedBox(width: 12),
              const Text('School Announcements', style: AppTextStyle.bold18),
            ],
          ),
          const SizedBox(height: 20),
          _buildAnnouncementItem(
            title: 'Staff Meeting at 3 PM',
            subtitle: 'Subject: Annual Sports Day Planning',
          ),
          const SizedBox(height: 16),
          _buildAnnouncementItem(
            title: 'Grades Submission Deadline',
            subtitle: 'Quarterly reports due by Friday 5 PM',
          ),
        ],
      ),
    );
  }

  Widget _buildAnnouncementItem({
    required String title,
    required String subtitle,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          margin: const EdgeInsets.only(top: 6),
          width: 8,
          height: 8,
          decoration: BoxDecoration(
            color: AppColors.primaryColor,
            shape: BoxShape.circle,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: AppTextStyle.semiBold14.copyWith(
                  color: AppColors.darkBlue,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                subtitle,
                style: AppTextStyle.regular14.copyWith(color: AppColors.grey),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
