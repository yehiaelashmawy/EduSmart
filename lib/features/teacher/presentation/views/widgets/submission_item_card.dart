import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:school_system/core/utils/app_colors.dart';
import 'package:school_system/core/utils/app_text_style.dart';
import 'package:school_system/core/helper/file_helper.dart';
import 'package:school_system/core/widgets/custom_snack_bar.dart';
import 'package:school_system/features/teacher/data/models/submission_model.dart';

class SubmissionItemCard extends StatelessWidget {
  const SubmissionItemCard({
    super.key,
    required this.submission,
    required this.onGradeTap,
  });

  final SubmissionModel submission;
  final VoidCallback onGradeTap;

  String _formatDate(String raw) {
    final dt = DateTime.tryParse(raw);
    if (dt == null) return raw;
    return DateFormat('MMM d, h:mm a').format(dt.toLocal());
  }

  @override
  Widget build(BuildContext context) {
    final isGraded = submission.isGraded;
    final isLate = submission.isLate;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.lightGrey.withValues(alpha: 0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              // ── Avatar ──────────────────────────────────────────────
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

              // ── Name + email ─────────────────────────────────────────
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            submission.studentName,
                            style: AppTextStyle.bold16.copyWith(
                              color: AppColors.black,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        if (isLate)
                          Container(
                            margin: const EdgeInsets.only(left: 8),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 2,
                            ),
                            decoration: BoxDecoration(
                              color: const Color(0xFFFEE2E2),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: const Text(
                              'LATE',
                              style: TextStyle(
                                color: Color(0xFF991B1B),
                                fontSize: 9,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 0.5,
                              ),
                            ),
                          ),
                      ],
                    ),
                    const SizedBox(height: 2),
                    Text(
                      submission.studentEmail,
                      style: AppTextStyle.regular12.copyWith(
                        color: AppColors.grey,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 2),
                    Text(
                      'ID: ${submission.studentEmail.split('@').first}', // Using a part of email as ID if not in model, or use submission.id
                      style: AppTextStyle.regular10.copyWith(
                        color: AppColors.grey.withValues(alpha: 0.8),
                      ),
                    ),
                  ],
                ),
              ),

              // ── Score badge (if graded) ──────────────────────────────
              if (isGraded) ...[
                const SizedBox(width: 8),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      submission.grade!.toStringAsFixed(0),
                      style: AppTextStyle.bold18.copyWith(
                        color: AppColors.secondaryColor,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 2),
                      child: Text(
                        '/100',
                        style: AppTextStyle.regular12.copyWith(
                          color: AppColors.grey,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ],
          ),

          // ── Submission time and Status ───────────────────────────────
          const SizedBox(height: 10),
          Row(
            children: [
              Icon(
                isGraded
                    ? Icons.check_circle_outline
                    : (submission.status.toLowerCase() == 'submitted'
                          ? Icons.check
                          : Icons.schedule_outlined),
                size: 14,
                color: isGraded
                    ? AppColors.secondaryColor
                    : (submission.status.toLowerCase() == 'submitted'
                          ? const Color(0xFF10B981) // Green
                          : AppColors.grey.withValues(alpha: 0.7)),
              ),
              const SizedBox(width: 5),
              Text(
                isGraded
                    ? 'Graded • ${_formatDate(submission.submittedAt)}'
                    : (submission.submittedAt.isNotEmpty
                          ? '${submission.status} • ${_formatDate(submission.submittedAt)}'
                          : submission.status),
                style: AppTextStyle.regular12.copyWith(
                  color: AppColors.grey.withValues(alpha: 0.8),
                ),
              ),
            ],
          ),

          // ── Content preview ──────────────────────────────────────────
          if (submission.content.isNotEmpty) ...[
            const SizedBox(height: 8),
            Text(
              submission.content,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: AppTextStyle.regular12.copyWith(
                color: AppColors.grey.withValues(alpha: 0.7),
              ),
            ),
          ],

          // ── Feedback (if graded) ─────────────────────────────────────
          if (submission.feedback != null && submission.feedback!.isNotEmpty) ...[
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: const Color(0xFFF0FDF4), // Light Green
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Icons.chat_bubble_outline, size: 14, color: const Color(0xFF166534)),
                      const SizedBox(width: 4),
                      Text(
                        'FEEDBACK',
                        style: AppTextStyle.bold10.copyWith(color: const Color(0xFF166534)),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    submission.feedback!,
                    style: AppTextStyle.regular12.copyWith(color: const Color(0xFF166534)),
                  ),
                ],
              ),
            ),
          ],

          // ── Attachment chip ──────────────────────────────────────────
          if (submission.attachmentUrl != null) ...[
            const SizedBox(height: 10),
            GestureDetector(
              onTap: () async {
                final fileName = submission.attachmentUrl!.split('/').last;
                try {
                  await FileHelper.downloadAndOpenFile(
                    url: submission.attachmentUrl!,
                    fileName: fileName,
                  );
                } catch (e) {
                  if (context.mounted) {
                    CustomSnackBar.showError(
                      context,
                      'Could not open file: ${e.toString()}',
                    );
                  }
                }
              },
              child: Row(
                children: [
                  Icon(
                    Icons.attach_file,
                    size: 14,
                    color: AppColors.primaryColor,
                  ),
                  const SizedBox(width: 4),
                  Expanded(
                    child: Text(
                      submission.attachmentUrl!.split('/').last,
                      style: AppTextStyle.regular12.copyWith(
                        color: AppColors.primaryColor,
                        decoration: TextDecoration.underline,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ),
          ],

          // ── Grade button / Already graded label ──────────────────────
          const SizedBox(height: 14),
          SizedBox(
            width: double.infinity,
            child: isGraded
                ? OutlinedButton.icon(
                    onPressed: onGradeTap,
                    icon: Icon(
                      Icons.edit_outlined,
                      size: 16,
                      color: AppColors.primaryColor,
                    ),
                    label: Text(
                      'Edit Grade',
                      style: AppTextStyle.semiBold14.copyWith(
                        color: AppColors.primaryColor,
                      ),
                    ),
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      side: BorderSide(color: AppColors.primaryColor),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  )
                : ElevatedButton.icon(
                    onPressed: onGradeTap,
                    icon: const Icon(
                      Icons.star_border,
                      size: 16,
                      color: Colors.white,
                    ),
                    label: const Text(
                      'Grade Submission',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.secondaryColor,
                      elevation: 0,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
          ),
        ],
      ),
    );
  }
}
