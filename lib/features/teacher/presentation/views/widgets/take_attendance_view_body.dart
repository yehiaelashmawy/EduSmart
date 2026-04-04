import 'package:flutter/material.dart';
import 'package:school_system/core/utils/app_colors.dart';
import 'package:school_system/core/utils/app_text_style.dart';
import 'package:school_system/features/teacher/presentation/views/widgets/take_attendance_card.dart';

class TakeAttendanceViewBody extends StatelessWidget {
  const TakeAttendanceViewBody({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
      children: [
        SafeArea(
          bottom: false,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Your Classes Today',
                style: AppTextStyle.bold24.copyWith(color: AppColors.black),
              ),
              const SizedBox(height: 4),
              Text(
                'Monday, Oct 24th',
                style: AppTextStyle.medium16.copyWith(color: AppColors.grey),
              ),
            ],
          ),
        ),
        const SizedBox(height: 24),
        TakeAttendanceCard(
          imagePath: 'assets/images/lesson1.png',
          statusText: 'NEXT SESSION: 09:00 AM',
          statusColor: AppColors.primaryColor,
          grade: 'Grade 10-A',
          subject: 'Mathematics',
          studentsCount: 24,
          onViewReports: () {},
          onTakeAttendance: () {},
        ),
        TakeAttendanceCard(
          imagePath: 'assets/images/lesson2.png',
          statusText: 'NEXT SESSION: 11:30 AM',
          statusColor: const Color(0xff7D8B9D), // Greyish purple color
          grade: 'Grade 11-B',
          subject: 'Advanced Calculus',
          studentsCount: 18,
          onViewReports: () {},
          onTakeAttendance: () {},
        ),
        TakeAttendanceCard(
          imagePath: 'assets/images/lesson3.png',
          statusText: 'ATTENDANCE COMPLETED',
          statusColor: const Color(0xff0BA96A), // Emerald green
          grade: 'Grade 9-C',
          subject: 'Algebra Basics',
          studentsCount: 30,
          onViewReports: () {},
          onTakeAttendance: () {},
        ),
        const SizedBox(height: 24),
      ],
    );
  }
}
