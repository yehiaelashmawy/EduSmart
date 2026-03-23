import 'package:flutter/material.dart';
import 'package:school_system/core/utils/app_colors.dart';
import 'package:school_system/core/utils/app_text_style.dart';
import 'package:school_system/features/teacher/presentation/views/widgets/learning_objectives_section.dart';
import 'package:school_system/features/teacher/presentation/views/widgets/lesson_details_header.dart';
import 'package:school_system/features/teacher/presentation/views/widgets/lesson_file_card.dart';

class LessonDetailsViewBody extends StatelessWidget {
  const LessonDetailsViewBody({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const LessonDetailsHeader(),

          // Content Section
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'DESCRIPTION',
                  style: AppTextStyle.bold16.copyWith(
                    color: AppColors.primaryColor,
                    letterSpacing: 1.5,
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  'This fundamental course covers the basic\nconcepts of limits, derivatives, and integrals.\nStudents will explore how these mathematical\ntools allow us to model change and motion in\nthe physical world. Perfect for beginners\nentering the world of higher mathematics.',
                  style: AppTextStyle.regular16.copyWith(
                    color: AppColors.grey,
                    height: 1.5,
                  ),
                ),
                const SizedBox(height: 24),

                const LearningObjectivesSection(),

                const SizedBox(height: 32),

                // Lesson Files Section
                const Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Lesson Files',
                      style: TextStyle(
                        color: AppColors.darkBlue,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      '3 Files',
                      style: TextStyle(
                        color: Color(0xff0F52BD),
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                const LessonFileCard(
                  fileName: 'Calculus_Basics.pdf',
                  fileInfo: '2.4 MB • PDF Document',
                  iconColor: Color(0xffFEE2E2),
                  iconData: Icons.picture_as_pdf,
                  iconWidgetColor: Color(0xffDC2626),
                ),
                const SizedBox(height: 12),
                const LessonFileCard(
                  fileName: 'Formula_Sheet.png',
                  fileInfo: '1.1 MB • Image',
                  iconColor: Color(0xffDBEAFE),
                  iconData: Icons.image,
                  iconWidgetColor: Color(0xff2563EB),
                ),
                const SizedBox(height: 12),
                const LessonFileCard(
                  fileName: 'Week_1_Homework.pdf',
                  fileInfo: '850 KB • PDF Document',
                  iconColor: Color(0xffFEE2E2),
                  iconData: Icons.picture_as_pdf,
                  iconWidgetColor: Color(0xffDC2626),
                ),
              ],
            ),
          ),
          const SizedBox(height: 32),
        ],
      ),
    );
  }
}
