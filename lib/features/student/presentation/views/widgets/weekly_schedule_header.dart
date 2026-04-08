import 'package:flutter/material.dart';
import 'package:school_system/core/utils/app_colors.dart';

class WeeklyScheduleHeader extends StatelessWidget {
  final String dateRangeText;
  final String weekText;
  final VoidCallback onPreviousWeek;
  final VoidCallback onNextWeek;

  const WeeklyScheduleHeader({
    super.key,
    required this.dateRangeText,
    required this.weekText,
    required this.onPreviousWeek,
    required this.onNextWeek,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              dateRangeText,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: AppColors.darkBlue,
                height: 1.2,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              weekText,
              style: TextStyle(
                fontSize: 14,
                color: AppColors.grey,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
        Row(
          children: [
            _ArrowButton(icon: Icons.chevron_left, onPressed: onPreviousWeek),
            const SizedBox(width: 8),
            _ArrowButton(icon: Icons.chevron_right, onPressed: onNextWeek),
          ],
        ),
      ],
    );
  }
}

class _ArrowButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onPressed;

  const _ArrowButton({required this.icon, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.primaryColor.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(8),
          onTap: onPressed,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Icon(icon, color: AppColors.secondaryColor, size: 20),
          ),
        ),
      ),
    );
  }
}
