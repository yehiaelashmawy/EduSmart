import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:school_system/core/utils/app_colors.dart';
import 'package:school_system/core/utils/app_text_style.dart';
import 'package:school_system/features/teacher/data/models/exam_submission_model.dart';

class ExamSubmissionCard extends StatelessWidget {
  final ExamSubmissionModel submission;
  final VoidCallback onTap;

  const ExamSubmissionCard({
    super.key,
    required this.submission,
    required this.onTap,
  });

  String _formatDate(String raw) {
    final dt = DateTime.tryParse(raw);
    if (dt == null) return raw;
    return DateFormat('MMM d, h:mm a').format(dt.toLocal());
  }

  @override
  Widget build(BuildContext context) {
    final isGraded = submission.isGraded;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.lightGrey.withValues(alpha: 0.3)),
        ),
        child: Row(
          children: [
            // Avatar
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: AppColors.primaryColor.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              alignment: Alignment.center,
              child: Text(
                submission.initials,
                style: TextStyle(
                  color: AppColors.primaryColor,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(width: 14),

            // Info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    submission.studentName,
                    style: AppTextStyle.bold16.copyWith(color: AppColors.black),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Icon(
                        isGraded ? Icons.check_circle : Icons.schedule,
                        size: 14,
                        color: isGraded ? const Color(0xFF10B981) : const Color(0xFFF59E0B),
                      ),
                      const SizedBox(width: 4),
                      Text(
                        isGraded ? 'Graded' : 'Pending',
                        style: AppTextStyle.medium12.copyWith(
                          color: isGraded ? const Color(0xFF10B981) : const Color(0xFFF59E0B),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        _formatDate(submission.submittedAt),
                        style: AppTextStyle.regular12.copyWith(color: AppColors.grey),
                      ),
                    ],
                  ),
                  if (submission.fileName != null) ...[
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Icon(Icons.attach_file, size: 12, color: AppColors.primaryColor),
                        const SizedBox(width: 4),
                        Expanded(
                          child: Text(
                            submission.fileName!,
                            style: AppTextStyle.regular12.copyWith(color: AppColors.primaryColor),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ],
                ],
              ),
            ),

            // Score
            if (isGraded) ...[
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    submission.score.toStringAsFixed(0),
                    style: AppTextStyle.bold20.copyWith(color: AppColors.secondaryColor),
                  ),
                  Text(
                    'Score',
                    style: AppTextStyle.regular10.copyWith(color: AppColors.grey),
                  ),
                ],
              ),
            ] else
              Icon(Icons.chevron_right, color: AppColors.grey.withValues(alpha: 0.5)),
          ],
        ),
      ),
    );
  }
}
