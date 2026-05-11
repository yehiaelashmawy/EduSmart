import 'package:flutter/material.dart';
import 'package:school_system/core/utils/app_colors.dart';
import 'package:school_system/core/utils/app_text_style.dart';

class KidHomeworkCard extends StatelessWidget {
  final String title;
  final String subject;
  final String info;
  final String status;
  final String? grade;
  final String? comment;

  const KidHomeworkCard({
    super.key,
    required this.title,
    required this.subject,
    required this.info,
    required this.status,
    this.grade,
    this.comment,
  });

  Color get _statusColor {
    switch (status) {
      case 'PENDING':   return Colors.orange;
      case 'SUBMITTED': return AppColors.primaryColor;
      case 'GRADED':    return const Color(0xFF4CAF50);
      default:          return AppColors.grey;
    }
  }

  Color get _statusBgColor => _statusColor.withValues(alpha: 0.1);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.lightGrey.withValues(alpha: 0.3)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: AppTextStyle.bold16.copyWith(color: AppColors.darkBlue),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '$subject • $info',
                      style: AppTextStyle.medium12.copyWith(color: AppColors.grey),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: _statusBgColor,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  status,
                  style: AppTextStyle.bold12.copyWith(color: _statusColor, fontSize: 10),
                ),
              ),
            ],
          ),
          if (grade != null || comment != null) ...[
            const SizedBox(height: 12),
            const Divider(height: 1),
            const SizedBox(height: 12),
          ],
          if (grade != null)
            Row(
              children: [
                Icon(Icons.grade_rounded, size: 16, color: AppColors.primaryColor),
                const SizedBox(width: 6),
                Text(
                  grade!,
                  style: AppTextStyle.bold14.copyWith(color: AppColors.primaryColor),
                ),
              ],
            ),
          if (comment != null) ...[
            const SizedBox(height: 8),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(Icons.comment_outlined, size: 14, color: AppColors.grey),
                const SizedBox(width: 6),
                Expanded(
                  child: Text(
                    comment!,
                    style: AppTextStyle.medium12.copyWith(
                      color: AppColors.grey,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }
}
