import 'package:flutter/material.dart';
import 'package:school_system/core/helper/file_helper.dart';
import 'package:school_system/core/utils/app_colors.dart';
import 'package:school_system/core/utils/app_text_style.dart';
import 'package:school_system/features/student/data/models/student_homework_model.dart';
import 'package:school_system/features/student/presentation/views/widgets/student_lesson_material_card.dart';

class StudentAssignmentAttachedMaterials extends StatelessWidget {
  final List<StudentHomeworkMaterialModel> materials;

  const StudentAssignmentAttachedMaterials({
    super.key,
    required this.materials,
  });

  @override
  Widget build(BuildContext context) {
    if (materials.isEmpty) {
      return const SizedBox.shrink();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: AppColors.primaryColor.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(Icons.attachment_rounded, color: AppColors.primaryColor, size: 20),
            ),
            const SizedBox(width: 12),
            Text(
              'Study Materials',
              style: AppTextStyle.bold16.copyWith(
                color: AppColors.darkBlue,
              ),
            ),
            const Spacer(),
            Text(
              '${materials.length} Files',
              style: AppTextStyle.medium12.copyWith(color: AppColors.grey),
            ),
          ],
        ),
        const SizedBox(height: 16),
        ...materials.map((material) {
          final bool isPdf = material.fileType?.contains('pdf') ?? false;
          final bool isImage = material.fileType?.contains('image') ?? false;

          return Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: StudentLessonMaterialCard(
              title: material.fileName ?? 'Unknown File',
              subtitle: material.sizeText ?? 'Unknown Size',
              leadingIcon: isPdf
                  ? Icons.picture_as_pdf_rounded
                  : isImage
                      ? Icons.image_rounded
                      : Icons.insert_drive_file_rounded,
              leadingColor: isPdf
                  ? const Color(0xffD92D20)
                  : isImage
                      ? AppColors.primaryColor
                      : AppColors.grey,
              leadingBackgroundColor: (isPdf
                      ? const Color(0xffD92D20)
                      : isImage
                          ? AppColors.primaryColor
                          : AppColors.grey)
                  .withValues(alpha: 0.1),
              onDownload: () {
                if (material.fileUrl != null) {
                  FileHelper.downloadAndOpenFile(
                    url: material.fileUrl!,
                    fileName: material.fileName ?? 'attachment',
                  );
                }
              },
            ),
          );
        }),
      ],
    );
  }
}
