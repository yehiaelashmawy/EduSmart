import 'package:flutter/material.dart';
import 'package:school_system/core/utils/app_colors.dart';
import 'package:school_system/core/utils/app_text_style.dart';

class KidSubjectGradeCard extends StatelessWidget {
  final String subject;
  final String percent;
  final String letterGrade;
  final List<Map<String, dynamic>> quizzes;
  final List<Map<String, dynamic>> assignments;

  const KidSubjectGradeCard({
    super.key,
    required this.subject,
    required this.percent,
    required this.letterGrade,
    required this.quizzes,
    required this.assignments,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.lightGrey.withValues(alpha: 0.3)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            decoration: BoxDecoration(
              color: AppColors.primaryColor.withValues(alpha: 0.04),
              borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    subject,
                    style: AppTextStyle.bold18.copyWith(color: AppColors.darkBlue),
                  ),
                ),
                Text(
                  percent,
                  style: AppTextStyle.bold18.copyWith(color: AppColors.primaryColor),
                ),
                const SizedBox(width: 8),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: AppColors.primaryColor.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    letterGrade,
                    style: AppTextStyle.bold12.copyWith(color: AppColors.primaryColor),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildGradeSectionLabel(Icons.quiz_outlined, 'QUIZZES & EXAMS'),
                const SizedBox(height: 12),
                ...quizzes.map((q) => _buildGradeItem(
                      q['title'] as String,
                      q['date'] as String,
                      q['percent'] as int,
                    )),
                const SizedBox(height: 16),
                _buildGradeSectionLabel(Icons.assignment_outlined, 'ASSIGNMENTS'),
                const SizedBox(height: 12),
                ...assignments.map((a) => _buildGradeItem(
                      a['title'] as String,
                      a['date'] as String,
                      a['percent'] as int,
                    )),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGradeSectionLabel(IconData icon, String title) {
    return Row(
      children: [
        Icon(icon, size: 14, color: AppColors.grey),
        const SizedBox(width: 6),
        Text(
          title,
          style: AppTextStyle.bold12.copyWith(
            color: AppColors.grey,
            letterSpacing: 0.5,
          ),
        ),
      ],
    );
  }

  Widget _buildGradeItem(String title, String date, int percent) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  title,
                  style: AppTextStyle.medium14.copyWith(color: AppColors.darkBlue),
                ),
              ),
              Text(
                '$percent%',
                style: AppTextStyle.bold14.copyWith(color: AppColors.primaryColor),
              ),
            ],
          ),
          const SizedBox(height: 2),
          Text(
            date,
            style: AppTextStyle.regular12.copyWith(color: AppColors.grey),
          ),
          const SizedBox(height: 8),
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: percent / 100,
              backgroundColor: AppColors.grey.withValues(alpha: 0.1),
              valueColor: AlwaysStoppedAnimation<Color>(AppColors.primaryColor),
              minHeight: 4,
            ),
          ),
        ],
      ),
    );
  }
}
