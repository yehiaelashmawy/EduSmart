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

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border(left: BorderSide(color: _statusColor, width: 4)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Icon Box
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: AppColors.primaryColor.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    Icons.assignment_outlined,
                    color: AppColors.primaryColor,
                    size: 24,
                  ),
                ),
                const SizedBox(width: 12),
                // Text Content
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: AppTextStyle.bold16.copyWith(
                          color: AppColors.darkBlue,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          Icon(
                            isDueSoon ? Icons.access_time : Icons.calendar_today_outlined,
                            size: 14,
                            color: isDueSoon ? _statusColor : AppColors.grey,
                          ),
                          const SizedBox(width: 4),
                          Expanded(
                            child: Text(
                              submittedDate,
                              style: AppTextStyle.medium12.copyWith(
                                color: isDueSoon ? _statusColor : AppColors.grey,
                              ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      // Status Badge
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 3,
                        ),
                        decoration: BoxDecoration(
                          color: _statusColor.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(6),
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
              ),
            ] else if (status == AssignmentStatus.pendingReview) ...[
              StudentAssignmentPendingContent(filename: filename),
            ],

            const SizedBox(height: 16),

            // Action Buttons
            SizedBox(
              width: double.infinity,
              child: Wrap(
                alignment: WrapAlignment.end,
                spacing: 8,
                runSpacing: 8,
                children: [
                  if (status == AssignmentStatus.notSubmitted) ...[
                    SizedBox(
                      height: 40,
                      child: ElevatedButton.icon(
                        onPressed: onSubmitWork,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primaryColor,
                          foregroundColor: Colors.white,
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                        ),
                        icon: const Icon(Icons.file_upload_outlined, size: 18),
                        label: const Text(
                          'Submit Work',
                          style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
                        ),
                      ),
                    ),
                  ],
                  SizedBox(
                    height: 40,
                    child: ElevatedButton.icon(
                      onPressed: onViewDetails,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xff0F52BD), // Match lesson card blue
                        foregroundColor: Colors.white,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                      ),
                      icon: const Icon(Icons.remove_red_eye_outlined, size: 18),
                      label: const Text(
                        'View Details',
                        style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
