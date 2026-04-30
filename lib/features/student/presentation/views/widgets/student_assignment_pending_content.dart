import 'package:flutter/material.dart';
import 'package:school_system/core/utils/app_colors.dart';
import 'package:school_system/core/utils/app_text_style.dart';

class StudentAssignmentPendingContent extends StatelessWidget {
  final String? filename;
  final VoidCallback? onTap;

  const StudentAssignmentPendingContent({
    super.key,
    required this.filename,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: AppColors.lightGrey.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          children: [
            Icon(
              Icons.description_outlined,
              size: 20,
              color: AppColors.primaryColor,
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                filename ?? 'Attached Document',
                style: AppTextStyle.medium12.copyWith(color: AppColors.darkBlue),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            if (onTap != null)
              Icon(
                Icons.open_in_new,
                size: 16,
                color: AppColors.grey,
              ),
          ],
        ),
      ),
    );
  }
}
