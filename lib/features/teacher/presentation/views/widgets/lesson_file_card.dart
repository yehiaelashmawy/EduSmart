import 'package:flutter/material.dart';
import 'package:school_system/core/utils/app_colors.dart';
import 'package:school_system/core/utils/app_text_style.dart';

class LessonFileCard extends StatelessWidget {
  final String fileName;
  final String fileInfo;
  final Color iconColor;
  final IconData iconData;
  final Color iconWidgetColor;

  const LessonFileCard({
    super.key,
    required this.fileName,
    required this.fileInfo,
    required this.iconColor,
    required this.iconData,
    required this.iconWidgetColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.lightGrey.withOpacity(0.3)),
      ),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: iconColor,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(iconData, color: iconWidgetColor, size: 24),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  fileName,
                  style: AppTextStyle.semiBold14.copyWith(
                    color: AppColors.darkBlue,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  fileInfo,
                  style: AppTextStyle.regular12.copyWith(color: AppColors.grey),
                ),
              ],
            ),
          ),
          const SizedBox(width: 16),
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: AppColors.lightGrey.withOpacity(0.3),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.file_download_outlined,
              color: AppColors.darkBlue,
              size: 18,
            ),
          ),
        ],
      ),
    );
  }
}
