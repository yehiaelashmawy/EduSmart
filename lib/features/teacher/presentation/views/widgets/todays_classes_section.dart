import 'package:flutter/material.dart';
import 'package:school_system/core/utils/app_colors.dart';
import 'package:school_system/core/utils/app_text_style.dart';

class TodaysClassesSection extends StatelessWidget {
  const TodaysClassesSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Text('Today\'s Classes', style: AppTextStyle.bold20),
            TextButton(
              onPressed: () {},
              style: TextButton.styleFrom(
                padding: EdgeInsets.zero,
                minimumSize: Size.zero,
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              ),
              child: Text(
                'View Schedule',
                style: AppTextStyle.semiBold14.copyWith(
                  color: AppColors.primaryColor,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        SizedBox(
          height: 160,
          child: ListView(
            scrollDirection: Axis.horizontal,
            clipBehavior: Clip.none,
            children: [
              _buildClassCard(
                subject: 'Mathematics',
                grade: 'Grade 10 • A',
                time: '08:30 AM - 09:45 AM',
                location: 'Room 402, Block B',
              ),
              const SizedBox(width: 16),
              _buildClassCard(
                subject: 'Physics',
                grade: 'Grade 12 • C',
                time: '10:00 AM - 11:15 AM',
                location: 'Room 405, Block A',
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildClassCard({
    required String subject,
    required String grade,
    required String time,
    required String location,
  }) {
    return Container(
      width: 260,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: AppColors.black.withValues(alpha: 0.04),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: const Color(0xFFF0F5FF),
                  shape: BoxShape.circle,
                ),
                child: Text(
                  'Σ',
                  style: AppTextStyle.bold20.copyWith(
                    color: AppColors.primaryColor,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(subject, style: AppTextStyle.bold16),
                  const SizedBox(height: 2),
                  Text(
                    grade,
                    style: AppTextStyle.regular14.copyWith(
                      color: AppColors.grey,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              Icon(Icons.access_time, size: 18, color: AppColors.grey),
              const SizedBox(width: 8),
              Text(
                time,
                style: AppTextStyle.regular14.copyWith(color: AppColors.grey),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Icon(Icons.location_on_outlined, size: 18, color: AppColors.grey),
              const SizedBox(width: 8),
              Text(
                location,
                style: AppTextStyle.regular14.copyWith(color: AppColors.grey),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
