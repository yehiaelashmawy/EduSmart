import 'package:flutter/material.dart';
import 'package:school_system/core/utils/app_colors.dart';
import 'package:school_system/features/student/data/models/weekly_schedule_models.dart';

class WeeklyDaysSelector extends StatelessWidget {
  final List<ScheduleDay> days;
  final int selectedIndex;
  final ValueChanged<int> onDaySelected;

  const WeeklyDaysSelector({
    super.key,
    required this.days,
    required this.selectedIndex,
    required this.onDaySelected,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 110,
      child: ListView.separated(
        clipBehavior: Clip.none,
        scrollDirection: Axis.horizontal,
        itemCount: days.length,
        separatorBuilder: (context, index) => const SizedBox(width: 12),
        itemBuilder: (context, index) {
          final day = days[index];
          final isSelected = index == selectedIndex;
          return GestureDetector(
            onTap: () => onDaySelected(index),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              width: 80,
              padding: const EdgeInsets.symmetric(vertical: 16),
              decoration: BoxDecoration(
                color: isSelected ? AppColors.secondaryColor : Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.05),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    day.dayName,
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1,
                      color: isSelected ? Colors.white.withValues(alpha: 0.8) : AppColors.grey,
                    ),
                  ),
                  Text(
                    day.dayNumber,
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: isSelected ? Colors.white : AppColors.darkBlue,
                    ),
                  ),
                  Text(
                    '${day.classCount} classes',
                    style: TextStyle(
                      fontSize: 10,
                      color: isSelected ? Colors.white.withValues(alpha: 0.8) : AppColors.grey,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
