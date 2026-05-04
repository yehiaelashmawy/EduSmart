import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:school_system/core/utils/app_colors.dart';
import 'package:school_system/core/utils/app_text_style.dart';
import 'package:school_system/features/teacher/data/models/teacher_class_model.dart';
import 'package:school_system/features/teacher/presentation/manager/teacher_classes_cubit/teacher_classes_cubit.dart';
import 'package:school_system/features/teacher/presentation/views/attendance_method_view.dart';
import 'package:school_system/features/teacher/presentation/views/attendance_report_view.dart';
import 'package:school_system/features/teacher/presentation/views/widgets/take_attendance_card.dart';

/// One row: a student's attendance record from [TeacherAttendanceRecordModel].
class TeacherAttendanceListEntry {
  final String studentName;
  final TeacherAttendanceRecordModel record;

  const TeacherAttendanceListEntry({
    required this.studentName,
    required this.record,
  });
}

class AttendanceListBody extends StatelessWidget {
  final TeacherClassModel? teacherClass;
  final String className;
  final int studentCount;
  final TeacherAttendanceModel summary;
  final Color statusColor;
  final String statusText;
  final List<TeacherAttendanceListEntry> recentEntries;
  final VoidCallback? onRefresh;

  const AttendanceListBody({
    super.key,
    this.teacherClass,
    required this.className,
    required this.studentCount,
    required this.summary,
    required this.statusColor,
    required this.statusText,
    this.recentEntries = const [],
    this.onRefresh,
  });

  String _formatDate(String raw) {
    final d = DateTime.tryParse(raw);
    if (d == null) return raw;
    const months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];
    return '${months[d.month - 1]} ${d.day}, ${d.year}';
  }

  Color _statusChipColor(String status) {
    switch (status.toLowerCase()) {
      case 'present':
        return const Color(0xFFD1FAE5);
      case 'absent':
        return const Color(0xFFFEE2E2);
      case 'late':
        return const Color(0xFFFEF3C7);
      default:
        return AppColors.lightGrey.withValues(alpha: 0.5);
    }
  }

  Color _statusTextColor(String status) {
    switch (status.toLowerCase()) {
      case 'present':
        return const Color(0xFF065F46);
      case 'absent':
        return const Color(0xFF991B1B);
      case 'late':
        return const Color(0xFFB45309);
      default:
        return AppColors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
      children: [
        TakeAttendanceCard(
          imagePath: 'assets/images/lesson1.png',
          statusText: statusText,
          statusColor: statusColor,
          grade: className,
          subject:
              'Present: ${summary.presentCount} • Absent: ${summary.absentCount} • Late: ${summary.lateCount}',
          studentsCount: studentCount,
          onViewReports: () {
            Navigator.of(
              context,
              rootNavigator: true,
            ).pushNamed(AttendanceReportView.routeName);
          },
          onTakeAttendance: () {
            if (teacherClass == null) return;
            Navigator.of(context, rootNavigator: true)
                .pushNamed(
                  AttendanceMethodView.routeName,
                  arguments: AttendanceMethodViewArgs(
                    teacherClass: teacherClass!,
                    teacherClassesCubit: context.read<TeacherClassesCubit>(),
                  ),
                )
                .then((value) {
              if (!context.mounted) return;
              if (value == true && onRefresh != null) {
                onRefresh!();
              }
            });
          },
        ),
        const SizedBox(height: 24),
        Text(
          'Recent attendance',
          style: AppTextStyle.bold16.copyWith(color: AppColors.darkBlue),
        ),
        const SizedBox(height: 12),
        if (recentEntries.isEmpty)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 24),
            child: Center(
              child: Text(
                'No attendance records yet for this class.',
                style: AppTextStyle.regular14.copyWith(color: AppColors.grey),
                textAlign: TextAlign.center,
              ),
            ),
          )
        else
          ...recentEntries.map((e) {
            final r = e.record;
            return Container(
              margin: const EdgeInsets.only(bottom: 12),
              decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: AppColors.lightGrey.withValues(alpha: 0.4),
                ),
              ),
              child: ListTile(
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                title: Text(
                  e.studentName,
                  style: AppTextStyle.semiBold14.copyWith(
                    color: AppColors.darkBlue,
                  ),
                ),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 4),
                    Text(
                      _formatDate(r.date),
                      style: AppTextStyle.regular12.copyWith(
                        color: AppColors.grey,
                      ),
                    ),
                    if (r.remarks.isNotEmpty) ...[
                      const SizedBox(height: 4),
                      Text(
                        r.remarks,
                        style: AppTextStyle.regular12.copyWith(
                          color: AppColors.grey,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ],
                ),
                trailing: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: _statusChipColor(r.status),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    r.status.isNotEmpty ? r.status : 'WITHOUT MARK',
                    style: AppTextStyle.bold12.copyWith(
                      color: _statusTextColor(r.status),
                    ),
                  ),
                ),
              ),
            );
          }),
      ],
    );
  }
}
