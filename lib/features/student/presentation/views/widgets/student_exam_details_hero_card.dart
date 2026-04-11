import 'package:flutter/material.dart';
import 'package:school_system/core/utils/app_colors.dart';
import 'package:school_system/core/utils/app_text_style.dart';

class StudentExamDetailsHeroCard extends StatelessWidget {
  final String status;
  final String title;
  final String date;
  final String time;
  final String duration;
  final String room;

  const StudentExamDetailsHeroCard({
    super.key,
    required this.status,
    required this.title,
    required this.date,
    required this.time,
    required this.duration,
    required this.room,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppColors.secondaryColor, // Dark blue from the image
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              status.toUpperCase(),
              style: AppTextStyle.bold12.copyWith(
                color: Colors.white,
                fontSize: 10,
                letterSpacing: 0.5,
              ),
            ),
          ),
          const SizedBox(height: 16),
          Text(
            title,
            style: AppTextStyle.bold24.copyWith(
              color: Colors.white,
              fontSize: 26,
            ),
          ),
          const SizedBox(height: 24),
          Row(
            children: [
              Expanded(
                child: _buildGridItem(
                  icon: Icons.calendar_today_outlined,
                  label: 'DATE',
                  value: date,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _buildGridItem(
                  icon: Icons.access_time,
                  label: 'TIME',
                  value: time,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: _buildGridItem(
                  icon: Icons.timer_outlined,
                  label: 'DURATION',
                  value: duration,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _buildGridItem(
                  icon: Icons.location_on_outlined,
                  label: 'ROOM',
                  value: room,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildGridItem({
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: Colors.white.withValues(alpha: 0.8), size: 16),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: AppTextStyle.bold12.copyWith(
                    color: Colors.white.withValues(alpha: 0.8),
                    fontSize: 9,
                    letterSpacing: 0.5,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  value,
                  style: AppTextStyle.bold14.copyWith(
                    color: Colors.white,
                    height: 1.2,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
