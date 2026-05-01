import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:school_system/core/utils/app_colors.dart';
import 'package:school_system/core/utils/app_text_style.dart';
import 'package:school_system/features/student/data/models/student_exam_model.dart';
import 'package:school_system/core/helper/file_helper.dart';

class StudentExamMySubmission extends StatelessWidget {
  final MyExamSubmissionModel submission;

  const StudentExamMySubmission({super.key, required this.submission});

  @override
  Widget build(BuildContext context) {
    String submittedAt = '';
    if (submission.submittedAt != null) {
      try {
        final date = DateTime.parse(submission.submittedAt!);
        submittedAt = DateFormat('MMM dd, yyyy • hh:mm a').format(date);
      } catch (e) {
        submittedAt = submission.submittedAt!;
      }
    }

    final isGraded = submission.isGraded ?? false;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: isGraded
              ? AppColors.secondaryColor.withValues(alpha: 0.3)
              : AppColors.lightGrey.withValues(alpha: 0.5),
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.black.withValues(alpha: 0.03),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Your Submission',
                style: AppTextStyle.bold16.copyWith(color: AppColors.darkBlue),
              ),
              _buildStatusBadge(),
            ],
          ),
          const SizedBox(height: 16),
          if (submittedAt.isNotEmpty)
            Row(
              children: [
                Icon(Icons.access_time, size: 14, color: AppColors.grey),
                const SizedBox(width: 6),
                Text(
                  'Submitted: $submittedAt',
                  style: AppTextStyle.medium12.copyWith(color: AppColors.grey),
                ),
              ],
            ),
          const SizedBox(height: 16),
          _buildContentSection(),
          if (submission.feedback != null && submission.feedback!.isNotEmpty) ...[
            const SizedBox(height: 20),
            _buildFeedbackSection(),
          ],
        ],
      ),
    );
  }

  Widget _buildStatusBadge() {
    final status = submission.status ?? 'Submitted';
    final isGraded = submission.isGraded ?? false;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: (isGraded ? AppColors.secondaryColor : const Color(0xffB42318))
            .withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        isGraded ? 'GRADED' : status.toUpperCase(),
        style: TextStyle(
          fontSize: 10,
          fontWeight: FontWeight.bold,
          color: isGraded ? AppColors.secondaryColor : const Color(0xffB42318),
        ),
      ),
    );
  }

  Widget _buildContentSection() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.lightGrey.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (submission.answerText != null && submission.answerText!.isNotEmpty)
            Text(
              submission.answerText!,
              style: AppTextStyle.medium14.copyWith(color: AppColors.darkBlue),
            ),
          if (submission.fileName != null) ...[
            if (submission.answerText != null && submission.answerText!.isNotEmpty)
              const SizedBox(height: 12),
            InkWell(
              onTap: () {
                if (submission.attachmentUrl != null) {
                  FileHelper.downloadAndOpenFile(
                    url: submission.attachmentUrl!,
                    fileName: submission.fileName!,
                  );
                }
              },
              child: Row(
                children: [
                  Icon(Icons.attach_file, size: 16, color: AppColors.primaryColor),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      submission.fileName!,
                      style: AppTextStyle.bold14.copyWith(
                        color: AppColors.primaryColor,
                        decoration: TextDecoration.underline,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildFeedbackSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(Icons.comment_outlined, size: 16, color: AppColors.secondaryColor),
            const SizedBox(width: 8),
            Text(
              'Teacher Feedback',
              style: AppTextStyle.bold14.copyWith(color: AppColors.darkBlue),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: AppColors.secondaryColor.withValues(alpha: 0.05),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: AppColors.secondaryColor.withValues(alpha: 0.1),
            ),
          ),
          child: Text(
            submission.feedback!,
            style: AppTextStyle.medium12.copyWith(
              color: AppColors.darkBlue,
              fontStyle: FontStyle.italic,
            ),
          ),
        ),
      ],
    );
  }
}
