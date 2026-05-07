import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:school_system/core/utils/app_colors.dart';
import 'package:school_system/core/utils/app_text_style.dart';
import 'package:school_system/features/student/data/models/active_session_model.dart';

class StudentAttendanceSuccessView extends StatelessWidget {
  static const String routeName = 'student_attendance_success_view';

  const StudentAttendanceSuccessView({super.key});

  @override
  Widget build(BuildContext context) {
    // Accept an optional ActiveSessionModel passed as route argument
    final session =
        ModalRoute.of(context)?.settings.arguments as ActiveSessionModel?;

    final submittedAt = DateFormat('h:mm a').format(DateTime.now());
    final className = session?.className ?? 'Attendance Session';
    final lessonName = session?.className ?? '';

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
              // Success Icon
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
                      color: Color(0xFF1FAB71),
                      shape: BoxShape.circle,
                    ),
                    padding: const EdgeInsets.all(12),
                    child: const Icon(
                      Icons.check,
                      color: Colors.white,
                      size: 32,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 32),

              Text(
                'Attendance\nRecorded\nSuccessfully',
                style: AppTextStyle.bold24.copyWith(
                  color: AppColors.black,
                  fontSize: 28,
                  height: 1.2,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),

              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Recorded at ',
                    style: AppTextStyle.medium14.copyWith(
                      color: AppColors.grey,
                    ),
                  ),
                  Text(
                    submittedAt,
                    style: AppTextStyle.bold14.copyWith(
                      color: AppColors.secondaryColor,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 48),

              // Session Details Card
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
                child: Row(
                  children: [
                    Container(
                      width: 60,
                      height: 60,
                      decoration: BoxDecoration(
                        color: AppColors.secondaryColor.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(
                        Icons.how_to_reg_rounded,
                        color: AppColors.secondaryColor,
                        size: 30,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'SESSION VERIFIED',
                            style: AppTextStyle.bold12.copyWith(
                              color: AppColors.grey,
                              letterSpacing: 1.0,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            className,
                            style: AppTextStyle.bold16.copyWith(
                              color: AppColors.black,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                          if (lessonName.isNotEmpty) ...[
                            const SizedBox(height: 4),
                            Text(
                              lessonName,
                              style: AppTextStyle.medium12.copyWith(
                                color: AppColors.grey,
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 64),

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
