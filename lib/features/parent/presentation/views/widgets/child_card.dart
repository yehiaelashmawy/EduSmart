import 'package:flutter/material.dart';
import 'package:school_system/core/utils/app_colors.dart';
import 'package:school_system/core/utils/app_text_style.dart';

class ChildCard extends StatelessWidget {
  final String name;
  final String grade;
  final double gpa;
  final double attendance;
  final int subjectsCount;
  final VoidCallback? onTap;

  const ChildCard({
    super.key,
    required this.name,
    required this.grade,
    this.gpa = 0,
    this.attendance = 0,
    this.subjectsCount = 0,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        padding: const EdgeInsets.all(16),
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
        child: Row(
          children: [
            Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                color: AppColors.primaryColor.withValues(alpha: 0.05),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Center(
                child: Icon(
                  Icons.person_rounded,
                  color: AppColors.primaryColor,
                  size: 30,
                ),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    style: AppTextStyle.bold16.copyWith(color: AppColors.darkBlue),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    grade,
                    style: AppTextStyle.medium12.copyWith(color: AppColors.grey),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      _buildMiniStat(Icons.star_rounded, gpa > 0 ? gpa.toStringAsFixed(1) : '-', const Color(0xffFDB022)),
                      const SizedBox(width: 12),
                      _buildMiniStat(Icons.calendar_today_rounded, attendance > 0 ? '${attendance.toInt()}%' : '-', AppColors.primaryColor),
                      const SizedBox(width: 12),
                      _buildMiniStat(Icons.menu_book_rounded, subjectsCount > 0 ? subjectsCount.toString() : '-', const Color(0xff12B76A)),
                    ],
                  ),
                ],
              ),
            ),
            Icon(
              Icons.arrow_forward_ios_rounded,
              color: AppColors.grey.withValues(alpha: 0.3),
              size: 16,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMiniStat(IconData icon, String value, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Icon(icon, size: 12, color: color),
          const SizedBox(width: 4),
          Text(
            value,
            style: AppTextStyle.bold12.copyWith(color: color),
          ),
        ],
      ),
    );
  }
}