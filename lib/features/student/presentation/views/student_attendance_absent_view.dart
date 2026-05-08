import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:school_system/core/utils/app_colors.dart';
import 'package:school_system/core/utils/app_text_style.dart';
import 'package:school_system/features/student/data/models/student_attendance_submit_model.dart';

class StudentAttendanceAbsentView extends StatelessWidget {
  static const String routeName = 'student_attendance_absent_view';
  final StudentAttendanceSubmitModel? result;

  const StudentAttendanceAbsentView({super.key, this.result});

  @override
  Widget build(BuildContext context) {
    final argResult = result ?? ModalRoute.of(context)?.settings.arguments as StudentAttendanceSubmitModel?;
    
    final submittedAt = argResult?.checkInTime.isNotEmpty == true 
        ? argResult!.checkInTime 
        : DateFormat('h:mm a').format(DateTime.now());
        
    final message = argResult?.message.isNotEmpty == true ? argResult!.message : "Wrong number selected. Marked as Absent.";

    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      appBar: AppBar(
        title: Text(
          'Attendance Tracking',
          style: AppTextStyle.bold16.copyWith(
            color: AppColors.black,
            fontSize: 16,
          ),
        ),
        backgroundColor: AppColors.backgroundColor,
        elevation: 0,
        centerTitle: false,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: AppColors.secondaryColor),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 32.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Error Icon
              Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(24),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.05),
                      blurRadius: 20,
                      offset: const Offset(0, 10),
                    ),
                  ],
                ),
                child: Center(
                  child: Container(
                    decoration: const BoxDecoration(
                      color: Colors.red,
                      shape: BoxShape.circle,
                    ),
                    padding: const EdgeInsets.all(12),
                    child: const Icon(
                      Icons.close,
                      color: Colors.white,
                      size: 32,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 32),

              Text(
                'Marked as Absent',
                style: AppTextStyle.bold24.copyWith(
                  color: AppColors.black,
                  fontSize: 28,
                  height: 1.2,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),

              Text(
                message,
                style: AppTextStyle.medium14.copyWith(
                  color: AppColors.grey,
                ),
                textAlign: TextAlign.center,
              ),
              
              const SizedBox(height: 32),
              
              const Divider(),
              
              const SizedBox(height: 32),

              // Info rows
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.03),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.access_time, color: Colors.grey, size: 20),
                        const SizedBox(width: 12),
                        Text(
                          'Recorded at $submittedAt',
                          style: AppTextStyle.medium14.copyWith(color: AppColors.black),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        const Icon(Icons.assignment_late_outlined, color: Colors.red, size: 20),
                        const SizedBox(width: 12),
                        Text(
                          'Status: Absent',
                          style: AppTextStyle.bold14.copyWith(color: Colors.red),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 32),

              Text(
                "Your teacher has been notified. Contact them if you think this is a mistake.",
                style: AppTextStyle.medium12.copyWith(color: AppColors.grey),
                textAlign: TextAlign.center,
              ),

              const SizedBox(height: 32),

              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).popUntil((route) => route.isFirst);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.secondaryColor,
                    padding: const EdgeInsets.symmetric(vertical: 20),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 0,
                  ),
                  child: Text(
                    'Back to Home',
                    style: AppTextStyle.bold16.copyWith(color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
