import 'package:flutter/material.dart';
import 'package:school_system/core/utils/app_colors.dart';
import 'package:school_system/core/utils/app_text_style.dart';

import 'package:school_system/features/parent/data/models/children_dashboard_model.dart';

class RecentActivityList extends StatelessWidget {
  final List<RecentActivity>? activities;
  const RecentActivityList({super.key, this.activities});

  @override
  Widget build(BuildContext context) {
    if (activities == null || activities!.isEmpty) {
      return Column(
        children: [
          _buildActivityItem(
            icon: Icons.star_border,
            iconColor: Colors.blue,
            title: 'No recent activities',
            subtitle: 'Activities will appear here as they happen.',
            time: '',
          ),
        ],
      );
    }

    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: activities!.length,
      separatorBuilder: (context, index) => const SizedBox(height: 16),
      itemBuilder: (context, index) {
        final activity = activities![index];
        return _buildActivityItem(
          icon: _getIconForActivity(activity.activity),
          iconColor: _getColorForActivity(activity.activity),
          title: activity.activity,
          subtitle: activity.status,
          time: activity.timeAgo,
        );
      },
    );
  }

  IconData _getIconForActivity(String activity) {
    activity = activity.toLowerCase();
    if (activity.contains('submit')) return Icons.assignment_turned_in_outlined;
    if (activity.contains('due')) return Icons.timer_outlined;
    if (activity.contains('grade')) return Icons.star_border;
    return Icons.notifications_none_outlined;
  }

  Color _getColorForActivity(String activity) {
    activity = activity.toLowerCase();
    if (activity.contains('submit')) return Colors.green;
    if (activity.contains('due')) return Colors.orange;
    if (activity.contains('grade')) return Colors.blue;
    return Colors.purple;
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
                    Flexible(
                      child: Text(
                        title,
                        style: AppTextStyle.bold14.copyWith(
                          color: AppColors.darkBlue,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    const SizedBox(width: 8),
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
