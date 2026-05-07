import 'package:flutter/material.dart';
import 'package:school_system/core/utils/app_colors.dart';
import 'package:school_system/core/utils/app_text_style.dart';
import 'package:school_system/features/teacher/data/models/teacher_class_model.dart';
import 'package:school_system/features/teacher/presentation/views/widgets/attendance_lesson_card.dart';

class AttendanceLessonSelector extends StatelessWidget {
  final List<TeacherLessonModel> lessons;
  final String? selectedLessonOid;
  final Set<String> takenLessonOids;
  final ValueChanged<String> onLessonSelected;

  const AttendanceLessonSelector({
    super.key,
    required this.lessons,
    required this.selectedLessonOid,
    required this.onLessonSelected,
    this.takenLessonOids = const {},
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'SELECT LESSON',
          style: AppTextStyle.bold12.copyWith(
            color: AppColors.grey,
            letterSpacing: 1.0,
          ),
        ),
        const SizedBox(height: 12),
        if (lessons.isEmpty)
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.red.withValues(alpha: 0.2)),
            ),
            child: Text(
              'No lessons available for this class. Please add a lesson first.',
              style: AppTextStyle.medium14.copyWith(color: Colors.red),
            ),
          )
        else
          SizedBox(
            height: 110,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: lessons.length,
              separatorBuilder: (_, _) => const SizedBox(width: 12),
              itemBuilder: (context, index) {
                final lesson = lessons[index];
                return AttendanceLessonCard(
                  lesson: lesson,
                  isSelected: selectedLessonOid == lesson.oid,
                  hasAttendance: takenLessonOids.contains(lesson.oid),
                  onTap: () => onLessonSelected(lesson.oid),
                );
              },
            ),
          ),
      ],
    );
  }
}
