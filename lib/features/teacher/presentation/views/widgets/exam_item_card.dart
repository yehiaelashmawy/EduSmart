import 'package:flutter/material.dart';
import 'package:school_system/core/utils/app_colors.dart';
import 'package:school_system/core/utils/app_text_style.dart';
import 'package:school_system/features/teacher/presentation/views/exam_results_view.dart';

class ExamItemCard extends StatelessWidget {
  const ExamItemCard({
    super.key,
    required this.title,
    required this.date,
    required this.time,
    required this.subject,
    required this.grade,
    required this.status,
    required this.statusColor,
    required this.isDraft,
  });

  final String title;
  final String date;
  final String time;
  final String subject;
  final String grade;
  final String status;
  final Color statusColor;
  final bool isDraft;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.lightGrey.withValues(alpha: 0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Header Image/Color Box Placeholder
          Container(
            height: 100,
            decoration: BoxDecoration(
              color: AppColors.primaryColor.withValues(alpha: 0.15),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(20),
                topRight: Radius.circular(20),
              ),
            ),
            child: Stack(
              children: [
                Positioned(
                  top: 12,
                  right: 12,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: statusColor,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      status,
                      style: AppTextStyle.bold12.copyWith(color: Colors.white),
                    ),
                  ),
                ),
              ],
            ),
          ),
          // Content
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: AppTextStyle.bold18.copyWith(
                    color: AppColors.darkBlue,
                  ),
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Icon(
                      Icons.calendar_month_outlined,
                      size: 16,
                      color: AppColors.secondaryColor,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      '$date • $time',
                      style: AppTextStyle.medium14.copyWith(
                        color: AppColors.grey,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Icon(
                      Icons.school_outlined,
                      size: 16,
                      color: AppColors.secondaryColor,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      '$subject - $grade',
                      style: AppTextStyle.medium14.copyWith(
                        color: AppColors.grey,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                // Buttons
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: () {
                          Navigator.of(
                            context,
                            rootNavigator: true,
                          ).pushNamed('/exam_details');
                        },
                        icon: Icon(
                          isDraft ? Icons.edit_outlined : Icons.info_outline,
                          size: 18,
                          color: AppColors.grey,
                        ),
                        label: Text(
                          'View Details',
                          style: AppTextStyle.semiBold14.copyWith(
                            color: AppColors.darkBlue,
                          ),
                        ),
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          side: BorderSide(
                            color: AppColors.lightGrey.withValues(alpha: 0.5),
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: () {
                          Navigator.of(
                            context,
                            rootNavigator: true,
                          ).pushNamed(ExamResultsView.routeName);
                        },
                        icon: const Icon(
                          Icons.feed_outlined,
                          size: 18,
                          color: Colors.white,
                        ),
                        label: Text(
                          'Results',
                          style: AppTextStyle.semiBold14.copyWith(
                            color: Colors.white,
                          ),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.secondaryColor,
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
