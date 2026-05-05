import 'package:flutter/material.dart';
import 'package:school_system/core/utils/app_colors.dart';
import 'package:school_system/core/utils/app_text_style.dart';

class RecentActivityList extends StatelessWidget {
  const RecentActivityList({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _buildActivityItem(
          icon: Icons.star_border,
          iconColor: Colors.blue,
          title: 'New Grade Posted',
          subtitle: 'Advanced Mathematics - Mid-term Quiz',
          time: '2h ago',
          tag: 'A- (92%)',
        ),
        const SizedBox(height: 16),
        _buildActivityItem(
          icon: Icons.assignment_outlined,
          iconColor: Colors.orange,
          title: 'Assignment Submitted',
          subtitle: 'English Literature: Modernism Essay',
          time: 'Yesterday',
        ),
        const SizedBox(height: 16),
        _buildActivityItem(
          icon: Icons.chat_bubble_outline,
          iconColor: Colors.purple,
          title: 'Teacher Note',
          subtitle: 'Mr. Henderson left a comment on Physics lab',
          time: 'Oct 24',
        ),
      ],
    );
  }

  Widget _buildActivityItem({
    required IconData icon,
    required Color iconColor,
    required String title,
    required String subtitle,
    required String time,
    String? tag,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.lightGrey.withValues(alpha: 0.3)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: iconColor.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: iconColor, size: 20),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      title,
                      style: AppTextStyle.bold14.copyWith(
                        color: AppColors.darkBlue,
                      ),
                    ),
                    Text(
                      time,
                      style: AppTextStyle.regular12.copyWith(
                        color: AppColors.grey.withValues(alpha: 0.6),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: AppTextStyle.regular12.copyWith(color: AppColors.grey),
                ),
                if (tag != null) ...[
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: iconColor.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      tag,
                      style: AppTextStyle.bold10.copyWith(color: iconColor),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}
