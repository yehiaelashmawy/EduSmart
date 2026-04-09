import 'package:flutter/material.dart';
import 'package:school_system/core/utils/app_colors.dart';
import 'package:school_system/core/utils/app_text_style.dart';
import 'package:school_system/features/teacher/presentation/views/widgets/attendance_method_card.dart';

class AttendanceMethodViewBody extends StatelessWidget {
  const AttendanceMethodViewBody({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
      children: [
        Text(
          'SESSION MANAGEMENT',
          style: AppTextStyle.bold12.copyWith(
            color: AppColors.grey,
            letterSpacing: 1.0,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'Take Attendance',
          style: AppTextStyle.bold18.copyWith(color: AppColors.black),
        ),
        const SizedBox(height: 12),
        RichText(
          text: TextSpan(
            style: AppTextStyle.medium14.copyWith(
              color: AppColors.grey,
              height: 1.5,
            ),
            children: [
              const TextSpan(
                text:
                    'Select a preferred method to verify student presence for ',
              ),
              TextSpan(
                text: 'Advanced Calculus - Section 4B',
                style: AppTextStyle.medium14.copyWith(
                  color: AppColors.secondaryColor,
                ),
              ),
              const TextSpan(text: '.'),
            ],
          ),
        ),
        const SizedBox(height: 32),
        AttendanceMethodCard(
          icon: Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: const Color(0xffDDE4FF), // light bluish grey
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(Icons.edit_calendar, color: Color(0xff065AD8)),
          ),
          title: 'Manual Attendance',
          subtitle:
              'Personally mark students present or absent from the class roster.',
          actionText: 'SELECT METHOD',
          onTap: () {
            Navigator.pushNamed(context, '/manual_attendance_view');
          },
        ),
        AttendanceMethodCard(
          icon: Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(Icons.qr_code, color: Colors.white),
          ),
          title: 'Generate QR Code',
          subtitle:
              'Display a dynamic code on the screen for students to scan with their devices.',
          actionText: 'QUICK LAUNCH',
          actionIcon: Icons.bolt,
          isPrimary: true,
          onTap: () {
            Navigator.pushNamed(context, '/generate_qr_code_view');
          },
        ),
        AttendanceMethodCard(
          icon: Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppColors.peach,
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(Icons.pin, color: Color(0xff78350F)),
          ),
          title: 'Generate Code',
          subtitle:
              'Create a unique 6-digit numeric key for students to enter manually.',
          actionText: 'SELECT METHOD',
          onTap: () {
            Navigator.pushNamed(context, '/entry_code_view');
          },
        ),
      ],
    );
  }
}
