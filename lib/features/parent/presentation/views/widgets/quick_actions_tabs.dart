import 'package:flutter/material.dart';
import 'package:school_system/core/utils/app_colors.dart';
import 'package:school_system/core/utils/app_text_style.dart';

class QuickActionsTabs extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTabChanged;

  const QuickActionsTabs({
    super.key,
    required this.currentIndex,
    required this.onTabChanged,
  });

  @override
  Widget build(BuildContext context) {
    final tabs = ['Quick Actions', 'Attendance', 'Grades', 'Homework'];
    return SizedBox(
      height: 40,
      child: ListView.separated(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        scrollDirection: Axis.horizontal,
        itemCount: tabs.length,
        separatorBuilder: (_, __) => const SizedBox(width: 8),
        itemBuilder: (context, index) {
          final isSelected = index == currentIndex;
          return GestureDetector(
            onTap: () => onTabChanged(index),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: isSelected
                    ? AppColors.primaryColor.withValues(alpha: 0.1)
                    : Colors.transparent,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color:
                      isSelected ? AppColors.primaryColor : Colors.transparent,
                ),
              ),
              child: Text(
                tabs[index],
                style: AppTextStyle.semiBold14.copyWith(
                  color: isSelected ? AppColors.primaryColor : AppColors.grey,
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
