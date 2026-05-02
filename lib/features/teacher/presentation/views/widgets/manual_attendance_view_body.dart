import 'package:flutter/material.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:school_system/core/utils/app_colors.dart';
import 'package:school_system/core/utils/app_text_style.dart';
import 'package:school_system/features/teacher/data/models/attendance_session_model.dart';
import 'package:school_system/features/teacher/data/models/teacher_class_model.dart';
import 'package:school_system/features/teacher/presentation/views/widgets/attendance_stats_row.dart';
import 'package:school_system/features/teacher/presentation/views/widgets/student_attendance_card.dart';

class StudentData {
  final String studentOid;
  final String name;
  final String subtitle;
  final String imagePath;
  final bool hasHonorRoll;
  AttendanceStatus status;

  StudentData({
    required this.studentOid,
    required this.name,
    required this.subtitle,
    required this.imagePath,
    this.hasHonorRoll = false,
    this.status = AttendanceStatus.none,
  });
}

class ManualAttendanceViewBody extends StatefulWidget {
  final TeacherClassModel teacherClass;
  final AttendanceSessionModel? session;
  final bool isLoading;

  const ManualAttendanceViewBody({
    super.key,
    required this.teacherClass,
    this.session,
    this.isLoading = false,
  });

  @override
  State<ManualAttendanceViewBody> createState() =>
      ManualAttendanceViewBodyState();
}

class ManualAttendanceViewBodyState extends State<ManualAttendanceViewBody> {
  late final List<StudentData> students;

  @override
  void initState() {
    super.initState();
    final todayStr = DateTime.now().toIso8601String().split('T')[0];

    if (widget.session != null) {
      students = widget.session!.students.asMap().entries.map((entry) {
        final index = entry.key;
        final s = entry.value;
        // Try to find full student data in teacherClass to get the avatar and attendance history
        final classStudent = widget.teacherClass.students
            .cast<TeacherStudentModel?>()
            .firstWhere((cs) => cs?.oid == s.studentOid, orElse: () => null);

        // Check for existing attendance record for today
        AttendanceStatus initialStatus = AttendanceStatus.none;
        if (classStudent != null) {
          final todayRecord = classStudent.details.attendance.recentRecords
              .where((r) => r.date.startsWith(todayStr))
              .firstOrNull;

          if (todayRecord != null) {
            final status = todayRecord.status.toLowerCase();
            if (status == 'present') {
              initialStatus = AttendanceStatus.present;
            } else if (status == 'absent') {
              initialStatus = AttendanceStatus.absent;
            } else if (status == 'late') {
              initialStatus = AttendanceStatus.late;
            }
          }
        }

        return StudentData(
          studentOid: s.studentOid,
          name: s.studentName,
          subtitle: 'Roll No. ${(index + 1).toString().padLeft(3, '0')}',
          imagePath: classStudent?.avatar ?? '',
          status: initialStatus,
        );
      }).toList();
    } else {
      students = widget.teacherClass.students.asMap().entries.map((entry) {
        final index = entry.key;
        final s = entry.value;

        // Check for existing attendance record for today
        AttendanceStatus initialStatus = AttendanceStatus.none;
        final todayRecord = s.details.attendance.recentRecords
            .where((r) => r.date.startsWith(todayStr))
            .firstOrNull;

        if (todayRecord != null) {
          final status = todayRecord.status.toLowerCase();
          if (status == 'present') {
            initialStatus = AttendanceStatus.present;
          } else if (status == 'absent') {
            initialStatus = AttendanceStatus.absent;
          } else if (status == 'late') {
            initialStatus = AttendanceStatus.late;
          }
        }

        return StudentData(
          studentOid: s.oid,
          name: s.fullName,
          subtitle: 'Roll No. ${(index + 1).toString().padLeft(3, '0')}',
          imagePath: s.avatar,
          status: initialStatus,
        );
      }).toList();
    }
  }

  int get enrolledCount => students.length;
  int get absentCount =>
      students.where((s) => s.status == AttendanceStatus.absent).length;

  @override
  Widget build(BuildContext context) {
    final teacherClass = widget.teacherClass;
    return Skeletonizer(
      enabled: widget.isLoading,
      child: ListView(
        padding: const EdgeInsets.only(bottom: 24),
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(24, 24, 24, 0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${teacherClass.level.toUpperCase()} • ${teacherClass.name.toUpperCase()}',
                  style: AppTextStyle.bold12.copyWith(
                    color: AppColors.grey,
                    letterSpacing: 1.0,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Attendance Check',
                  style: AppTextStyle.bold24.copyWith(
                    color: AppColors.black,
                    fontSize: 32,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  '$enrolledCount Students Enrolled',
                  style: AppTextStyle.medium14.copyWith(color: AppColors.grey),
                ),
              ],
            ),
          ),
          if (widget.session != null)
            Container(
              width: double.infinity,
              margin: const EdgeInsets.fromLTRB(24, 24, 24, 8),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: const Color(0xffE2E8F0)),
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
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: AppColors.secondaryColor.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(
                      Icons.calendar_today_rounded,
                      color: AppColors.secondaryColor,
                      size: 20,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'ACTIVE SESSION',
                          style: AppTextStyle.bold12.copyWith(
                            color: AppColors.grey,
                            letterSpacing: 1.0,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          widget.session!.lessonName,
                          style: AppTextStyle.bold16.copyWith(
                            color: AppColors.darkBlue,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          Padding(
            padding: const EdgeInsets.all(24),
            child: AttendanceStatsRow(
              enrolledCount: enrolledCount,
              absentCount: absentCount,
            ),
          ),
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            padding: const EdgeInsets.symmetric(horizontal: 24),
            itemCount: students.length,
            separatorBuilder: (context, index) => const SizedBox(height: 16),
            itemBuilder: (context, index) {
              final student = students[index];
              return StudentAttendanceCard(
                name: student.name,
                subtitle: student.subtitle,
                imagePath: student.imagePath,
                hasHonorRoll: student.hasHonorRoll,
                status: student.status,
                onStatusChanged: (newStatus) {
                  setState(() {
                    student.status = newStatus;
                  });
                },
              );
            },
          ),
        ],
      ),
    );
  }
}
