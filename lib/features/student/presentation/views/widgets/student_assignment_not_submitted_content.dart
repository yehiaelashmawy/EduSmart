import 'package:flutter/material.dart';
import 'package:school_system/core/utils/app_colors.dart';
import 'package:school_system/core/utils/app_text_style.dart';

class StudentAssignmentNotSubmittedContent extends StatelessWidget {
  final String? description;
  final VoidCallback? onSubmitWork;

  const StudentAssignmentNotSubmittedContent({
    super.key,
    required this.description,
    required this.onSubmitWork,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (description != null) ...[
          Text(
            description!,
            style: AppTextStyle.medium12.copyWith(
              color: AppColors.grey,
              height: 1.5,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 16),
        ],
        SizedBox(
          width: double.infinity,
          child: ElevatedButton.icon(
            onPressed: onSubmitWork,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primaryColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              padding: const EdgeInsets.symmetric(vertical: 12),
              elevation: 0,
            ),
            icon: const Icon(
              Icons.file_upload_outlined,
              size: 18,
              color: Colors.white,
            ),
            label: Text(
              'Submit Work',
              style: AppTextStyle.bold14.copyWith(color: Colors.white),
            ),
          ),
        ),
      ],
    );
  }
}
