import 'package:flutter/material.dart';
import 'package:school_system/core/utils/app_colors.dart';
import 'package:school_system/core/utils/app_text_style.dart';

class AttendanceReportSummaryCard extends StatelessWidget {
  final int totalPercentage;
  final int presentDays;
  final int absentDays;
  final int lateDays;

  const AttendanceReportSummaryCard({
    super.key,
    required this.totalPercentage,
    required this.presentDays,
    required this.absentDays,
    required this.lateDays,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 24,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        children: [
          // Circular Progress Section
          Stack(
            alignment: Alignment.center,
            children: [
              SizedBox(
                height: 120,
                width: 120,
                child: CircularProgressIndicator(
                  value: totalPercentage / 100,
                  strokeWidth: 12,
                  backgroundColor: AppColors.lightGrey.withOpacity(0.3),
                  color: AppColors.primaryColor,
                  strokeCap: StrokeCap.round,
                ),
              ),
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    '$totalPercentage%',
                    style: AppTextStyle.bold24.copyWith(
                      color: AppColors.primaryColor,
                      fontSize: 28,
                    ),
                  ),
                  Text(
                    'Present',
                    style: AppTextStyle.medium12.copyWith(
                      color: AppColors.grey,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 32),
          // Stats Row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildStatItem('Present', presentDays, AppColors.primaryColor),
              Container(
                width: 1,
                height: 40,
                color: AppColors.lightGrey.withOpacity(0.5),
              ),
              _buildStatItem('Absent', absentDays, const Color(0xffDC2626)),
              Container(
                width: 1,
                height: 40,
                color: AppColors.lightGrey.withOpacity(0.5),
              ),
              _buildStatItem('Late', lateDays, const Color(0xffD97706)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem(String label, int count, Color color) {
    return Column(
      children: [
        Text(
          '$count',
          style: AppTextStyle.bold24.copyWith(color: AppColors.black),
        ),
        const SizedBox(height: 4),
        Text(
          '$label Days',
          style: AppTextStyle.semiBold12.copyWith(color: color),
        ),
      ],
    );
  }
}
