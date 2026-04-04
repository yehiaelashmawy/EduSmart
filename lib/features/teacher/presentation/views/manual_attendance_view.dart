import 'package:flutter/material.dart';
import 'package:school_system/core/utils/app_colors.dart';
import 'package:school_system/core/utils/app_text_style.dart';
import 'package:school_system/features/teacher/presentation/views/widgets/manual_attendance_view_body.dart';

class ManualAttendanceView extends StatelessWidget {
  static const String routeName = '/manual_attendance_view';

  const ManualAttendanceView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      appBar: AppBar(
        backgroundColor: AppColors.backgroundColor,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xff0F52BD)),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Manual Attendance',
          style: AppTextStyle.bold16.copyWith(
            color: const Color(0xff0F2042),
            fontSize: 18,
          ),
        ),
      ),
      body: const ManualAttendanceViewBody(),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(24, 8, 24, 16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xff065AD8),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 0,
                  ),
                  child: Text(
                    'Finalise Attendance',
                    style: AppTextStyle.semiBold16.copyWith(color: Colors.white),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Text(
                'AUTOMATED SYNC WITH SCHOOL INFORMATION\nSYSTEM',
                style: AppTextStyle.bold12.copyWith(
                  color: AppColors.grey,
                  letterSpacing: 1.2,
                  fontSize: 10,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
