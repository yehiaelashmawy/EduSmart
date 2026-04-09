import 'package:flutter/material.dart';
import 'package:school_system/core/utils/app_colors.dart';
import 'package:school_system/core/utils/app_text_style.dart';

class StudentLessonMaterialCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData leadingIcon;
  final Color leadingColor;
  final Color leadingBackgroundColor;
  final VoidCallback onDownload;

  const StudentLessonMaterialCard({
    super.key,
    required this.title,
    required this.subtitle,
    required this.leadingIcon,
    required this.leadingColor,
    required this.leadingBackgroundColor,
    required this.onDownload,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: leadingBackgroundColor,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(leadingIcon, color: leadingColor, size: 24),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: AppTextStyle.bold14.copyWith(
                    color: AppColors.darkBlue,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: AppTextStyle.medium12.copyWith(color: AppColors.grey),
                ),
              ],
            ),
          ),
          IconButton(
            icon: Icon(
              Icons.file_download_outlined,
              color: AppColors.secondaryColor,
            ),
            onPressed: onDownload,
          ),
        ],
      ),
    );
  }
}
