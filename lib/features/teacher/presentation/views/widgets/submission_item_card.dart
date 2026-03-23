import 'package:flutter/material.dart';
import 'package:school_system/core/utils/app_colors.dart';
import 'package:school_system/core/utils/app_text_style.dart';
import 'package:school_system/features/teacher/presentation/views/grade_submission_view.dart';

enum SubmissionStatus { graded, submitted, notTurnedIn }

class SubmissionItemCard extends StatelessWidget {
  const SubmissionItemCard({
    super.key,
    required this.studentName,
    required this.initials,
    required this.status,
    this.dateString,
    this.score,
    this.isOnline = false,
  });

  final String studentName;
  final String initials;
  final SubmissionStatus status;
  final String? dateString;
  final int? score;
  final bool isOnline;

  @override
  Widget build(BuildContext context) {
    final bool isNotTurnedIn = status == SubmissionStatus.notTurnedIn;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
      decoration: BoxDecoration(
        color: isNotTurnedIn ? Colors.transparent : AppColors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isNotTurnedIn ? AppColors.lightGrey.withOpacity(0.5) : AppColors.lightGrey.withOpacity(0.3),
        ),
      ),
      child: Row(
        children: [
          Stack(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: isNotTurnedIn ? AppColors.lightGrey.withOpacity(0.3) : AppColors.primaryColor.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                alignment: Alignment.center,
                child: Text(
                  initials,
                  style: TextStyle(
                    color: isNotTurnedIn ? AppColors.grey : AppColors.primaryColor,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              if (isOnline)
                Positioned(
                  bottom: 0,
                  right: 0,
                  child: Container(
                    width: 14,
                    height: 14,
                    decoration: BoxDecoration(
                      color: const Color(0xFF10B981), // Green dot
                      shape: BoxShape.circle,
                      border: Border.all(color: AppColors.white, width: 2),
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  studentName,
                  style: AppTextStyle.bold16.copyWith(
                    color: isNotTurnedIn ? AppColors.grey : AppColors.black,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    if (isNotTurnedIn) ...[
                      Icon(Icons.access_time, size: 14, color: AppColors.grey.withOpacity(0.8)),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          'Pending Submission',
                          style: AppTextStyle.regular12.copyWith(color: AppColors.grey.withOpacity(0.8)),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ] else ...[
                      Expanded(
                        child: Text(
                          status == SubmissionStatus.graded ? 'Graded • $dateString' : 'Submitted • $dateString',
                          style: AppTextStyle.regular12.copyWith(color: AppColors.grey.withOpacity(0.8)),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          _buildTrailingWidget(context),
        ],
      ),
    );
  }

  Widget _buildTrailingWidget(BuildContext context) {
    switch (status) {
      case SubmissionStatus.graded:
        return Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              '$score',
              style: AppTextStyle.bold18.copyWith(color: AppColors.secondaryColor),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 2),
              child: Text(
                '/100',
                style: AppTextStyle.regular12.copyWith(color: AppColors.grey),
              ),
            ),
          ],
        );
      case SubmissionStatus.submitted:
        return ElevatedButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const GradeSubmissionView(),
              ),
            );
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.secondaryColor,
            elevation: 0,
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30),
            ),
          ),
          child: const Text('Grade', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        );
      case SubmissionStatus.notTurnedIn:
        return Text(
          'Not Turned In',
          style: AppTextStyle.regular12.copyWith(color: AppColors.grey.withOpacity(0.5)),
        );
    }
  }
}
