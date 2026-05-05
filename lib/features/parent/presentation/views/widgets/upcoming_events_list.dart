import 'package:flutter/material.dart';
import 'package:school_system/core/utils/app_colors.dart';
import 'package:school_system/core/utils/app_text_style.dart';

class UpcomingEventsList extends StatelessWidget {
  const UpcomingEventsList({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _buildEventItem(
          date: 'OCT\n28',
          title: 'Parent-Teacher Conference',
          time: '3:30 PM • Room 204 (Block B)',
          color: Colors.blue,
          hasAction: true,
        ),
        const SizedBox(height: 12),
        _buildEventItem(
          date: 'NOV\n02',
          title: 'Regional Science Fair',
          time: 'All Day • Campus Auditorium',
          color: Colors.purple,
        ),
        const SizedBox(height: 12),
        _buildEventItem(
          date: 'NOV\n05',
          title: 'Physics Project Deadline',
          time: 'Due at 11:59 PM',
          color: Colors.deepOrange,
          isHighPriority: true,
        ),
      ],
    );
  }

  Widget _buildEventItem({
    required String date,
    required String title,
    required String time,
    required Color color,
    bool hasAction = false,
    bool isHighPriority = false,
  }) {
    final dateParts = date.split('\n');
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.lightGrey.withValues(alpha: 0.3)),
      ),
      child: Row(
        children: [
          Container(
            width: 50,
            height: 60,
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  dateParts[0],
                  style: AppTextStyle.bold10.copyWith(
                    color: color,
                    letterSpacing: 1,
                  ),
                ),
                Text(
                  dateParts[1],
                  style: AppTextStyle.bold18.copyWith(color: color),
                ),
              ],
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: AppTextStyle.bold14.copyWith(
                    color: AppColors.darkBlue,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  time,
                  style: AppTextStyle.regular12.copyWith(color: AppColors.grey),
                ),
                if (hasAction) ...[
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Icon(Icons.notifications_active_outlined,
                          size: 14, color: color),
                      const SizedBox(width: 4),
                      Text(
                        'Remind Me',
                        style: AppTextStyle.bold12.copyWith(color: color),
                      ),
                    ],
                  ),
                ],
                if (isHighPriority) ...[
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.red.withValues(alpha: 0.8),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      'HIGH PRIORITY',
                      style: AppTextStyle.bold10.copyWith(color: Colors.white),
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
