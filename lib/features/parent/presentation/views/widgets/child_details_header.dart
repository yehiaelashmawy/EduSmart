import 'package:flutter/material.dart';
import 'package:school_system/core/utils/app_colors.dart';
import 'package:school_system/core/utils/app_text_style.dart';
import 'package:school_system/features/parent/data/models/parent_dashboard_model.dart';

class ChildDetailsHeader extends StatelessWidget {
  final ParentChildModel? child;
  const ChildDetailsHeader({super.key, this.child});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: 358,
        height: 236,
        margin: const EdgeInsets.symmetric(vertical: 8),
        clipBehavior: Clip.antiAlias,
        decoration: BoxDecoration(
          color: const Color(0xFFF0F5FF),
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: Colors.white, width: 2),
          boxShadow: [
            BoxShadow(
              color: AppColors.primaryColor.withValues(alpha: 0.05),
              blurRadius: 20,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: Stack(
          children: [
            // Background Shape 1
            Positioned(
              top: -80,
              right: -60,
              child: Container(
                width: 240,
                height: 240,
                decoration: BoxDecoration(
                  color: AppColors.primaryColor.withValues(alpha: 0.08),
                  shape: BoxShape.circle,
                ),
              ),
            ),
            // Padding
            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'STUDENT PROFILE',
                    style: AppTextStyle.bold12.copyWith(
                      color: AppColors.grey.withValues(alpha: 0.6),
                      letterSpacing: 1.2,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    child?.name ?? 'Alexander Wright',
                    style: AppTextStyle.bold24.copyWith(color: AppColors.darkBlue),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      _buildBadge(Icons.school, 'Grade ${child?.gradeLevel ?? '10-A'}'),
                      const SizedBox(width: 12),
                      _buildBadge(Icons.assessment, 'GPA ${child?.gpa.toStringAsFixed(1) ?? '3.8'}'),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: _buildStatCard('Attendance', '${child?.attendance.toInt() ?? '94.2'}%'),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: _buildStatCard('Total Subjects', child?.subjectsCount.toString() ?? '6'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBadge(IconData icon, String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: AppColors.primaryColor.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: AppColors.primaryColor),
          const SizedBox(width: 6),
          Text(
            label,
            style: AppTextStyle.bold12.copyWith(color: AppColors.primaryColor),
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard(String label, String value) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(16),
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
          Text(
            label,
            style: AppTextStyle.regular12.copyWith(color: AppColors.grey),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: AppTextStyle.bold18.copyWith(color: AppColors.primaryColor),
          ),
        ],
      ),
    );
  }
}
