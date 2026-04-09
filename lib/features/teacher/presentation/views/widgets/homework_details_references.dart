import 'package:flutter/material.dart';
import 'package:school_system/core/utils/app_colors.dart';
import 'package:school_system/core/utils/app_text_style.dart';
import 'package:school_system/features/teacher/presentation/views/widgets/lesson_file_card.dart';

class HomeworkDetailsReferences extends StatelessWidget {
  const HomeworkDetailsReferences({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(Icons.link, color: AppColors.primaryColor, size: 20),
            const SizedBox(width: 8),
            Text(
              'Reference Files',
              style: AppTextStyle.bold16.copyWith(color: AppColors.black),
            ),
          ],
        ),
        const SizedBox(height: 12),
        const LessonFileCard(
          fileName: 'Research_Guidelines.pdf',
          fileInfo: '2.4 MB',
          iconColor: Color(0xFFFEE2E2), // Light red background
          iconData: Icons.picture_as_pdf_outlined,
          iconWidgetColor: Color(0xFFEF4444), // Red icon
        ),
        const SizedBox(height: 12),
        LessonFileCard(
          fileName: 'MLA_Style_Guide.docx',
          fileInfo: '1.1 MB',
          iconColor: AppColors.primaryColor.withValues(alpha: 0.1),
          iconData: Icons.description_outlined,
          iconWidgetColor: AppColors.primaryColor,
        ),
      ],
    );
  }
}
