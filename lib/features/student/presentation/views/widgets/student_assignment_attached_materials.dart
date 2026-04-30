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
        Text(
          'Attached Materials',
          style: AppTextStyle.bold16.copyWith(color: AppColors.darkBlue),
        ),
        const SizedBox(height: 16),
        ...materials.map((material) {
          final bool isPdf = material.fileType?.contains('pdf') ?? false;
          final bool isImage = material.fileType?.contains('image') ?? false;

          return StudentLessonMaterialCard(
            title: material.fileName ?? 'Unknown File',
            subtitle: material.sizeText ?? 'Unknown Size',
            leadingIcon: isPdf
                ? Icons.picture_as_pdf
                : isImage
                    ? Icons.image
                    : Icons.insert_drive_file,
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
          );
        }),
      ],
    );
  }
}
