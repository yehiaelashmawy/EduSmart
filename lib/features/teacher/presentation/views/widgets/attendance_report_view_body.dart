import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:school_system/core/utils/app_colors.dart';
import 'package:school_system/core/utils/app_text_style.dart';
import 'package:school_system/features/teacher/data/models/teacher_class_model.dart';
import 'package:school_system/features/teacher/presentation/manager/attendance_report_cubit/attendance_report_cubit.dart';
import 'package:school_system/features/teacher/presentation/manager/attendance_report_cubit/attendance_report_state.dart';
import 'package:school_system/features/teacher/presentation/views/widgets/attendance_report_summary_card.dart';
import 'package:school_system/features/teacher/presentation/views/widgets/student_report_card.dart';

class AttendanceReportViewBody extends StatefulWidget {
  final TeacherClassModel teacherClass;
  const AttendanceReportViewBody({super.key, required this.teacherClass});

  @override
  State<AttendanceReportViewBody> createState() =>
      _AttendanceReportViewBodyState();
}

class _AttendanceReportViewBodyState extends State<AttendanceReportViewBody> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AttendanceReportCubit, AttendanceReportState>(
      builder: (context, state) {
        if (state is AttendanceReportLoading) {
          return _buildLoadingState();
        } else if (state is AttendanceReportFailure) {
          return Center(child: Text(state.error.errorMessage));
        } else if (state is AttendanceReportSuccess) {
          final stats = state.stats;
          final totalPresent = stats.studentSummaries.fold(0, (sum, s) => sum + s.presentCount);
          final totalAbsent = stats.studentSummaries.fold(0, (sum, s) => sum + s.absentCount);
          final totalLate = stats.studentSummaries.fold(0, (sum, s) => sum + s.lateCount);

          return ListView(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
            children: [
              Text(
                widget.teacherClass.name,
                style: AppTextStyle.bold18.copyWith(color: AppColors.black),
              ),
              const SizedBox(height: 4),
              Text(
                widget.teacherClass.level,
                style: AppTextStyle.medium14.copyWith(color: AppColors.grey),
              ),
              const SizedBox(height: 24),

              AttendanceReportSummaryCard(
                totalPercentage: stats.averageAttendance.toInt(),
                presentDays: totalPresent,
                absentDays: totalAbsent,
                lateDays: totalLate,
              ),

              const SizedBox(height: 32),

              Text(
                'Student Breakdown',
                style: AppTextStyle.bold18.copyWith(color: AppColors.black),
              ),
              const SizedBox(height: 16),

              ...stats.studentSummaries.map(
                (s) => StudentReportCard(
                  name: s.studentName,
                  rollNumber: s.studentOid.substring(0, 8), // Using short OID as roll number
                  attendancePercentage: s.attendancePercentage.toInt(),
                  avatarPath: '', 
                ),
              ),
            ],
          );
        }
        return const SizedBox.shrink();
      },
    );
  }

  Widget _buildLoadingState() {
    return Skeletonizer(
      enabled: true,
      child: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
        children: [
          const Bone.text(words: 2),
          const SizedBox(height: 4),
          const Bone.text(words: 1),
          const SizedBox(height: 24),
          const AttendanceReportSummaryCard(
            totalPercentage: 0,
            presentDays: 0,
            absentDays: 0,
            lateDays: 0,
          ),
          const SizedBox(height: 32),
          const Bone.text(words: 2),
          const SizedBox(height: 16),
          ...List.generate(
            5,
            (index) => const StudentReportCard(
              name: 'Loading Student',
              rollNumber: '000',
              attendancePercentage: 0,
              avatarPath: '',
            ),
          ),
        ],
      ),
    );
  }
}
