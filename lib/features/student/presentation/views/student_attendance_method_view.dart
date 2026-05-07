import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:school_system/core/api/api_service.dart';
import 'package:school_system/core/utils/app_colors.dart';
import 'package:school_system/core/utils/app_text_style.dart';
import 'package:school_system/features/student/data/models/active_session_model.dart';
import 'package:school_system/features/student/data/repos/student_attendance_repo.dart';
import 'package:school_system/features/student/presentation/manager/student_attendance_cubit/student_attendance_cubit.dart';
import 'package:school_system/features/student/presentation/manager/student_attendance_cubit/student_attendance_state.dart';
import 'package:school_system/features/student/presentation/views/widgets/student_attendance_method_card.dart';
import 'package:school_system/features/student/presentation/views/student_select_code_view.dart';
import 'package:intl/intl.dart';

class StudentAttendanceMethodView extends StatelessWidget {
  static const String routeName = 'student_attendance_method_view';

  /// Subject is kept for backward compatibility but real data comes from session
  final String subject;

  const StudentAttendanceMethodView({super.key, required this.subject});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) =>
          StudentAttendanceCubit(StudentAttendanceRepo(ApiService()))
            ..getActiveSession(),
      child: Scaffold(
        backgroundColor: AppColors.backgroundColor,
        appBar: AppBar(
          title: Text(
            'Choose Attendance Method',
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
        body: BlocBuilder<StudentAttendanceCubit, StudentAttendanceState>(
          builder: (context, state) {
            final isLoading = state is StudentAttendanceLoading ||
                state is StudentAttendanceInitial;

            ActiveSessionModel? session;
            if (state is ActiveSessionLoaded) session = state.session;

            final className =
                session?.className ?? subject;
            final now = DateTime.now();
            final timeLabel =
                'Today, ${DateFormat('h:mm a').format(now)}';

            return SafeArea(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(
                    horizontal: 24.0, vertical: 24.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'CURRENT SESSION',
                      style: AppTextStyle.bold12.copyWith(
                        color: AppColors.grey,
                        letterSpacing: 1.0,
                      ),
                    ),
                    const SizedBox(height: 8),
                    isLoading
                        ? Container(
                            height: 32,
                            width: 200,
                            decoration: BoxDecoration(
                              color: AppColors.lightGrey.withValues(alpha: 0.3),
                              borderRadius: BorderRadius.circular(8),
                            ),
                          )
                        : Text(
                            className,
                            style: AppTextStyle.bold24.copyWith(
                              color: AppColors.black,
                              fontSize: 28,
                            ),
                          ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        if (session != null)
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 6,
                            ),
                            decoration: BoxDecoration(
                              color: AppColors.primaryColor.withValues(alpha: 0.15),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Text(
                              session.className,
                              style: AppTextStyle.bold12.copyWith(
                                color: AppColors.secondaryColor,
                              ),
                            ),
                          ),
                        if (session != null) const SizedBox(width: 12),
                        Row(
                          children: [
                            Icon(
                              Icons.calendar_today_outlined,
                              size: 14,
                              color: AppColors.grey,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              timeLabel,
                              style: AppTextStyle.medium12.copyWith(
                                color: AppColors.grey,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 48),

                    // ── Scan QR Code ───────────────────────────────────────
                    StudentAttendanceMethodCard(
                      iconWidget: const Icon(
                        Icons.qr_code_scanner,
                        color: Colors.white,
                        size: 28,
                      ),
                      iconBackgroundColor: AppColors.secondaryColor,
                      title: 'Scan QR Code',
                      description:
                          'Instantly check-in by scanning the digital code displayed in class.',
                      actionText: 'Open Camera',
                      onTap: () {
                        // Route correctly regardless of what the user tapped:
                        // if session says method=3, go to code screen instead
                        if (session?.method == 3) {
                          Navigator.pushNamed(
                            context,
                            StudentSelectCodeView.routeName,
                          );
                        } else {
                          Navigator.pushNamed(
                            context,
                            'student_scan_qr_view',
                            arguments: className,
                          );
                        }
                      },
                    ),

                    const SizedBox(height: 20),

                    // ── Choose Code ────────────────────────────────────────
                    StudentAttendanceMethodCard(
                      iconWidget: Text(
                        '123',
                        style: AppTextStyle.bold16.copyWith(
                          color: Colors.white,
                          fontSize: 14,
                        ),
                      ),
                      iconBackgroundColor: AppColors.secondaryColor,
                      iconContainerColor:
                          AppColors.lightGrey.withValues(alpha: 0.3),
                      title: 'Choose Code',
                      description:
                          'Select the matching number shown on the board by your instructor.',
                      actionText: 'Enter Manually',
                      onTap: () {
                        // Route correctly — if session says method=2, go to QR
                        if (session?.method == 2) {
                          Navigator.pushNamed(
                            context,
                            'student_scan_qr_view',
                            arguments: className,
                          );
                        } else {
                          Navigator.pushNamed(
                            context,
                            StudentSelectCodeView.routeName,
                          );
                        }
                      },
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
