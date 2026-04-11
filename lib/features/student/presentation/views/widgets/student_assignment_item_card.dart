import 'package:flutter/material.dart';
import 'package:school_system/core/utils/app_colors.dart';
import 'package:school_system/core/utils/app_text_style.dart';
import 'package:school_system/features/student/presentation/views/widgets/student_assignment_graded_content.dart';
import 'package:school_system/features/student/presentation/views/widgets/student_assignment_not_submitted_content.dart';
import 'package:school_system/features/student/presentation/views/widgets/student_assignment_pending_content.dart';

enum AssignmentStatus { graded, notSubmitted, pendingReview }

class StudentAssignmentItemCard extends StatelessWidget {
  final AssignmentStatus status;
  final String title;
  final String submittedDate;
  final bool isDueSoon;
  final String? grade;
  final String? totalGrade;
  final String? feedback;
  final String? description;
  final String? filename;

  final VoidCallback? onViewDetails;
  final VoidCallback? onSecondaryAction;
  final VoidCallback? onSubmitWork;

  const StudentAssignmentItemCard({
    super.key,
    required this.status,
    required this.title,
    required this.submittedDate,
    this.isDueSoon = false,
    this.grade,
    this.totalGrade,
    this.feedback,
    this.description,
    this.filename,
    this.onViewDetails,
    this.onSecondaryAction,
    this.onSubmitWork,
  });

  Color get _statusColor {
    switch (status) {
      case AssignmentStatus.graded:
        return const Color(0xff12B76A); // Green
      case AssignmentStatus.notSubmitted:
        return const Color(0xffF04438); // Red
      case AssignmentStatus.pendingReview:
        return const Color(0xffF79009); // Orange
    }
  }

  String get _statusLabel {
    switch (status) {
      case AssignmentStatus.graded:
        return 'GRADED';
      case AssignmentStatus.notSubmitted:
        return 'NOT SUBMITTED';
      case AssignmentStatus.pendingReview:
        return 'PENDING REVIEW';
    }
  }

  String get _secondaryActionLabel {
    switch (status) {
      case AssignmentStatus.graded:
        return 'Materials';
      case AssignmentStatus.notSubmitted:
        return 'Download';
      case AssignmentStatus.pendingReview:
        return 'Re-submit';
    }
  }

  String get _viewDetailsLabel {
    switch (status) {
      case AssignmentStatus.pendingReview:
        return 'Details';
      default:
        return 'View Details';
    }
  }

  IconData get _secondaryActionIcon {
    switch (status) {
      case AssignmentStatus.graded:
      case AssignmentStatus.notSubmitted:
        return Icons.download_rounded;
      case AssignmentStatus.pendingReview:
        return Icons.history;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.lightGrey.withValues(alpha: 0.3)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.01),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Container(
        decoration: BoxDecoration(
          border: Border(left: BorderSide(color: _statusColor, width: 4)),
        ),
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header: Title and Status Badge
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Text(
                    title,
                    style: AppTextStyle.bold16.copyWith(
                      color: AppColors.darkBlue,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: _statusColor.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    _statusLabel,
                    style: AppTextStyle.bold12.copyWith(
                      color: _statusColor,
                      fontSize: 10,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),

            // Subtitle (Date)
            Row(
              children: [
                Icon(
                  isDueSoon ? Icons.access_time : Icons.calendar_today_outlined,
                  size: 14,
                  color: isDueSoon ? _statusColor : AppColors.grey,
                ),
                const SizedBox(width: 4),
                Text(
                  submittedDate,
                  style: AppTextStyle.medium12.copyWith(
                    color: isDueSoon ? _statusColor : AppColors.grey,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 16),

            // Content based on status
            if (status == AssignmentStatus.graded) ...[
              StudentAssignmentGradedContent(
                grade: grade,
                totalGrade: totalGrade,
                feedback: feedback,
                statusColor: _statusColor,
              ),
            ] else if (status == AssignmentStatus.notSubmitted) ...[
              StudentAssignmentNotSubmittedContent(
                description: description,
                onSubmitWork: onSubmitWork,
              ),
            ] else if (status == AssignmentStatus.pendingReview) ...[
              StudentAssignmentPendingContent(filename: filename),
            ],

            const SizedBox(height: 16),

            // Actions
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: onViewDetails,
                    style: OutlinedButton.styleFrom(
                      side: BorderSide(color: AppColors.lightGrey),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                    icon: Icon(
                      Icons.remove_red_eye_outlined,
                      size: 18,
                      color: AppColors.darkBlue,
                    ),
                    label: Text(
                      _viewDetailsLabel,
                      style: AppTextStyle.bold14.copyWith(
                        color: AppColors.darkBlue,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: TextButton.icon(
                    onPressed: onSecondaryAction,
                    style: TextButton.styleFrom(
                      backgroundColor: AppColors.lightGrey.withValues(
                        alpha: 0.3,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                    icon: Icon(
                      _secondaryActionIcon,
                      size: 18,
                      color: AppColors.darkBlue,
                    ),
                    label: Text(
                      _secondaryActionLabel,
                      style: AppTextStyle.bold14.copyWith(
                        color: AppColors.darkBlue,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

}
