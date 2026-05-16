import 'package:flutter/material.dart';
import 'package:school_system/core/utils/app_colors.dart';
import 'package:school_system/core/utils/app_text_style.dart';

import 'package:school_system/features/parent/data/models/children_dashboard_model.dart';

class UpcomingEventsList extends StatelessWidget {
  final List<UpcomingEvent>? events;
  const UpcomingEventsList({super.key, this.events});

  @override
  Widget build(BuildContext context) {
    if (events == null || events!.isEmpty) {
      return Column(
        children: [
          _buildEventItem(
            date: 'N/A\n--',
            title: 'No upcoming events',
            time: 'Stay tuned for updates.',
            color: Colors.grey,
          ),
        ],
      );
    }

    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: events!.length,
      separatorBuilder: (context, index) => const SizedBox(height: 12),
      itemBuilder: (context, index) {
        final event = events![index];
        final dateFormatted = _formatDate(event.date);
        return _buildEventItem(
          date: dateFormatted,
          title: event.title,
          time: event.type,
          color: _getColorForEventType(event.type),
          isHighPriority: event.type == 'Exams',
        );
      },
    );
  }

  String _formatDate(String date) {
    // API returns "Month Day" like "يونيو 10"
    final parts = date.split(' ');
    if (parts.length >= 2) {
      return '${parts[0].substring(0, 3).toUpperCase()}\n${parts[1]}';
    }
    return 'CAL\n--';
  }

  Color _getColorForEventType(String type) {
    switch (type) {
      case 'Exams': return Colors.red;
      case 'Homework': return Colors.orange;
      case 'Events': return Colors.blue;
      default: return Colors.green;
    }
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
