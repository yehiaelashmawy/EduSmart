import 'package:flutter/material.dart';
import 'package:school_system/core/utils/app_colors.dart';
import 'package:school_system/core/utils/app_text_style.dart';
import 'package:school_system/features/teacher/data/models/teacher_class_model.dart';

class AttendanceLessonCard extends StatelessWidget {
  final TeacherLessonModel lesson;
  final bool isSelected;
  final bool hasAttendance;
  final VoidCallback onTap;

  const AttendanceLessonCard({
    super.key,
    required this.lesson,
    required this.isSelected,
    required this.onTap,
    this.hasAttendance = false,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            width: 160,
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: isSelected ? AppColors.secondaryColor : AppColors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: isSelected
                    ? AppColors.secondaryColor
                    : hasAttendance
                    ? const Color(0xff10B981)
                    : const Color(0xffE2E8F0),
                width: 2,
              ),
              boxShadow: isSelected
                  ? [
                      BoxShadow(
                        color: AppColors.secondaryColor.withValues(alpha: 0.3),
                        blurRadius: 8,
                        offset: const Offset(0, 4),
                      ),
                    ]
                  : null,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  lesson.title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyle.bold14.copyWith(
                    color: isSelected ? Colors.white : AppColors.darkBlue,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  lesson.date.split('T').first,
                  style: AppTextStyle.medium12.copyWith(
                    color: isSelected
                        ? Colors.white.withValues(alpha: 0.8)
                        : AppColors.grey,
                  ),
                ),
                if (hasAttendance && !isSelected) ...[
                  const SizedBox(height: 6),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 6,
                      vertical: 2,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xffD1FAE5),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      'Taken',
                      style: AppTextStyle.bold12.copyWith(
                        color: const Color(0xff065F46),
                        fontSize: 10,
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
          if (hasAttendance)
            Positioned(
              top: -6,
              right: -6,
              child: Container(
                width: 22,
                height: 22,
                decoration: BoxDecoration(
                  color: const Color(0xff10B981),
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white, width: 2),
                ),
                child: const Icon(
                  Icons.check,
                  color: Colors.white,
                  size: 12,
                ),
              ),
            ),
        ],
      ),
    );
  }
}
