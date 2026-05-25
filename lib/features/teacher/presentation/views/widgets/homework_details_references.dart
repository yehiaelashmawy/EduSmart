import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:open_filex/open_filex.dart';
import 'package:path_provider/path_provider.dart';
import 'package:school_system/core/helper/url_helper.dart';
import 'package:school_system/core/widgets/custom_snack_bar.dart';
import 'package:school_system/core/utils/app_colors.dart';
import 'package:school_system/core/utils/app_text_style.dart';
import 'package:school_system/features/teacher/data/models/teacher_class_model.dart';
import 'package:school_system/features/teacher/presentation/views/widgets/lesson_file_card.dart';

import 'package:school_system/core/helper/localization_helper.dart';

class HomeworkDetailsReferences extends StatelessWidget {
  final List<LessonMaterialModel> materials;

  const HomeworkDetailsReferences({super.key, required this.materials});

  Future<void> _openOrDownloadFile({
    required BuildContext context,
    required LessonMaterialModel material,
    required bool showSavedMessage,
  }) async {
    final fileName = material.name;
    final rawUrl = material.fileUrl;
    if (rawUrl.trim().isEmpty) {
      CustomSnackBar.showError(context, 'File URL is missing');
      return;
    }

    final fileUrl = UrlHelper.getFullImageUrl(rawUrl);
    if (fileUrl.trim().isEmpty) {
      CustomSnackBar.showError(context, 'Invalid file URL');
      return;
    }

    try {
      final tempDir = await getTemporaryDirectory();
      final filePath = '${tempDir.path}/$fileName';

      await Dio().download(fileUrl, filePath);
      await OpenFilex.open(filePath);
      if (!context.mounted) return;

      if (showSavedMessage) {
        CustomSnackBar.showSuccess(context, 'File downloaded successfully');
      }
    } catch (_) {
      if (!context.mounted) return;
      CustomSnackBar.showError(context, 'Failed to open/download file');
    }
  }

  @override
  Widget build(BuildContext context) {
    if (materials.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(Icons.link, color: AppColors.primaryColor, size: 20),
            const SizedBox(width: 8),
            Text(
              'reference_files'.tr(),
              style: AppTextStyle.bold16.copyWith(color: AppColors.black),
            ),
          ],
        ),
        const SizedBox(height: 12),
        ...materials.map((material) {
          final isPdf = material.name.toLowerCase().endsWith('.pdf');
          final kbSize = material.fileSize / 1024;
          final mbSize = kbSize / 1024;
          final sizeStr = mbSize > 1
              ? '${mbSize.toStringAsFixed(1)} MB'
              : '${kbSize.toStringAsFixed(0)} KB';

          return Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: LessonFileCard(
              fileName: material.name,
              fileInfo: sizeStr,
              iconColor: isPdf
                  ? const Color(0xFFFEE2E2)
                  : AppColors.primaryColor.withValues(alpha: 0.1),
              iconData: isPdf
                  ? Icons.picture_as_pdf_outlined
                  : Icons.description_outlined,
              iconWidgetColor: isPdf
                  ? const Color(0xFFEF4444)
                  : AppColors.primaryColor,
              onTap: () => _openOrDownloadFile(
                context: context,
                material: material,
                showSavedMessage: false,
              ),
              onDownloadTap: () => _openOrDownloadFile(
                context: context,
                material: material,
                showSavedMessage: true,
              ),
            ),
          );
        }),
      ],
    );
  }
}
