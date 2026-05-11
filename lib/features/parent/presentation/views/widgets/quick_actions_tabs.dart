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
    final tabs = [
      {'label': 'Overview', 'icon': Icons.grid_view_rounded},
      {'label': 'Attendance', 'icon': Icons.calendar_today_rounded},
      {'label': 'Grades', 'icon': Icons.auto_stories_rounded},
      {'label': 'Homework', 'icon': Icons.assignment_outlined},
    ];

    return SizedBox(
      height: 44,
      child: ListView.separated(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        itemCount: tabs.length,
        separatorBuilder: (_, _) => const SizedBox(width: 10),
        itemBuilder: (context, index) {
          final isSelected = index == currentIndex;
          final tab = tabs[index];

          return GestureDetector(
            onTap: () => onTabChanged(index),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              padding: const EdgeInsets.symmetric(horizontal: 18),
              decoration: BoxDecoration(
                color: isSelected ? AppColors.secondaryColor : Colors.white,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(
                  color: isSelected
                      ? AppColors.secondaryColor
                      : AppColors.lightGrey.withValues(alpha: 0.5),
                ),
                boxShadow: [
                  if (isSelected)
                    BoxShadow(
                      color: AppColors.secondaryColor.withValues(alpha: 0.2),
                      blurRadius: 8,
                      offset: const Offset(0, 4),
                    ),
                ],
              ),
              child: Row(
                children: [
                  Icon(
                    tab['icon'] as IconData,
                    size: 16,
                    color: isSelected ? Colors.white : AppColors.grey,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    tab['label'] as String,
                    style: AppTextStyle.bold14.copyWith(
                      color: isSelected ? Colors.white : AppColors.grey,
                      fontSize: 13,
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
