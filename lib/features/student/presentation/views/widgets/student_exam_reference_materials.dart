import 'package:flutter/material.dart';
import 'package:school_system/core/utils/app_colors.dart';
import 'package:school_system/core/utils/app_text_style.dart';
import 'package:school_system/features/student/data/models/student_exam_model.dart';
import 'package:school_system/core/helper/file_helper.dart';

class StudentExamReferenceMaterials extends StatelessWidget {
  final List<ExamMaterialModel> materials;

  const StudentExamReferenceMaterials({super.key, required this.materials});

  @override
  Widget build(BuildContext context) {
    if (materials.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Reference Materials',
          style: AppTextStyle.bold16.copyWith(
            color: AppColors.darkBlue,
          ),
        ),
        const SizedBox(height: 16),
        ...materials.map((m) => _buildMaterialItem(
              icon: _getIconForType(m.fileType ?? ''),
              iconColor: AppColors.secondaryColor,
              iconBackgroundColor: AppColors.primaryColor.withValues(alpha: 0.15),
              title: m.name ?? 'Unknown File',
              subtitle: _formatSubtitle(m),
              trailingIcon: Icons.download_rounded,
              onTap: () {
                if (m.fileUrl != null) {
                  FileHelper.downloadAndOpenFile(
                    url: m.fileUrl!,
                    fileName: m.name ?? 'exam_material',
                  );
                }
              },
            )),
      ],
    );
  }

  IconData _getIconForType(String type) {
    if (type.contains('pdf')) return Icons.picture_as_pdf;
    if (type.contains('image')) return Icons.image;
    if (type.contains('video')) return Icons.play_circle;
    return Icons.insert_drive_file;
  }

  String _formatSubtitle(ExamMaterialModel m) {
    String size = '';
    if (m.fileSize != null) {
      final mb = m.fileSize! / (1024 * 1024);
      if (mb >= 1) {
        size = '${mb.toStringAsFixed(1)} MB';
      } else {
        final kb = m.fileSize! / 1024;
        size = '${kb.toStringAsFixed(0)} KB';
      }
    }
    return size.isNotEmpty ? size : 'Reference File';
  }

  Widget _buildMaterialItem({
    required IconData icon,
    required Color iconColor,
    required Color iconBackgroundColor,
    required String title,
    required String subtitle,
    required IconData trailingIcon,
    required VoidCallback onTap,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: AppColors.black.withValues(alpha: 0.02),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: ListTile(
        contentPadding: EdgeInsets.zero,
        leading: Container(
          width: 44,
          height: 44,
          decoration: BoxDecoration(
            color: iconBackgroundColor,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(icon, color: iconColor),
        ),
        title: Text(
          title,
          style: AppTextStyle.bold14.copyWith(
            color: AppColors.darkBlue,
          ),
        ),
        subtitle: Text(
          subtitle,
          style: AppTextStyle.medium12.copyWith(
            color: AppColors.grey,
            fontSize: 10,
          ),
        ),
        trailing: IconButton(
          icon: Icon(trailingIcon, color: AppColors.grey, size: 20),
          onPressed: onTap,
        ),
      ),
    );
  }
}
