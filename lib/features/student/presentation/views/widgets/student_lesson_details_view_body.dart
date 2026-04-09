import 'package:flutter/material.dart';
import 'package:school_system/core/utils/app_colors.dart';
import 'package:school_system/core/utils/app_text_style.dart';
import 'package:school_system/features/student/presentation/views/widgets/lesson_overview_section.dart';
import 'package:school_system/features/student/presentation/views/widgets/student_learning_objective_item.dart';
import 'package:school_system/features/student/presentation/views/widgets/student_lesson_material_card.dart';

class StudentLessonDetailsViewBody extends StatelessWidget {
  final String lessonTitle;

  const StudentLessonDetailsViewBody({super.key, required this.lessonTitle});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(24.0),
      children: [
        const LessonOverviewSection(
          description:
              'This lesson explores the fundamental concepts of quadratic equations, focusing on solving standard forms using factoring, completing the square, and the quadratic formula.',
        ),
        const SizedBox(height: 32),
        Text(
          'Learning Objectives',
          style: AppTextStyle.bold16.copyWith(
            color: AppColors.darkBlue,
            fontSize: 18,
          ),
        ),
        const SizedBox(height: 16),
        const StudentLearningObjectiveItem(
          objective:
              'Identify quadratic functions in standard, vertex, and factored forms.',
        ),
        const StudentLearningObjectiveItem(
          objective: 'Apply the Discriminant to determine the nature of roots.',
        ),
        const StudentLearningObjectiveItem(
          objective: 'Graph parabolic functions with precision and accuracy.',
        ),
        const SizedBox(height: 32),
        Text(
          'Lesson Materials',
          style: AppTextStyle.bold16.copyWith(
            color: AppColors.darkBlue,
            fontSize: 18,
          ),
        ),
        const SizedBox(height: 16),
        StudentLessonMaterialCard(
          title: 'Lesson_Notes.pdf',
          subtitle: '1.2 MB • PDF Document',
          leadingIcon: Icons.picture_as_pdf,
          leadingColor: const Color(0xffD92D20),
          leadingBackgroundColor: const Color(
            0xffD92D20,
          ).withValues(alpha: 0.1),
          onDownload: () {},
        ),
        StudentLessonMaterialCard(
          title: 'Diagram_01.png',
          subtitle: '850 KB • Image File',
          leadingIcon: Icons.image,
          leadingColor: const Color(0xffB45309),
          leadingBackgroundColor: const Color(
            0xffB45309,
          ).withValues(alpha: 0.1),
          onDownload: () {},
        ),
      ],
    );
  }
}
