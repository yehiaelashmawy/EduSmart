import 'package:flutter/material.dart';
import 'package:school_system/core/utils/app_colors.dart';
import 'package:school_system/core/utils/app_text_style.dart';
import 'package:school_system/features/teacher/presentation/views/widgets/attendance_stats_row.dart';
import 'package:school_system/features/teacher/presentation/views/widgets/student_attendance_card.dart';

class StudentData {
  final String name;
  final String subtitle;
  final String imagePath;
  final bool hasHonorRoll;
  AttendanceStatus status;

  StudentData({
    required this.name,
    required this.subtitle,
    required this.imagePath,
    this.hasHonorRoll = false,
    this.status = AttendanceStatus.none,
  });
}

class ManualAttendanceViewBody extends StatefulWidget {
  const ManualAttendanceViewBody({super.key});

  @override
  State<ManualAttendanceViewBody> createState() => _ManualAttendanceViewBodyState();
}

class _ManualAttendanceViewBodyState extends State<ManualAttendanceViewBody> {
  final List<StudentData> students = [
    StudentData(
      name: 'Julianne Devis',
      subtitle: '"Late last Monday"',
      imagePath: 'assets/images/profile_photo.png',
      status: AttendanceStatus.present,
    ),
    StudentData(
      name: 'Arthur Morgan',
      subtitle: 'Roll No. 002',
      imagePath: 'assets/images/profile_photo.png',
    ),
    StudentData(
      name: 'Lydia Bennet',
      subtitle: 'Roll No. 003',
      imagePath: 'assets/images/profile_photo.png',
      hasHonorRoll: true,
      status: AttendanceStatus.absent,
    ),
    StudentData(
      name: 'Tobias Kingston',
      subtitle: 'Roll No. 004',
      imagePath: 'assets/images/profile_photo.png',
    ),
    StudentData(
      name: 'Sarah Walker',
      subtitle: 'Roll No. 005',
      imagePath: 'assets/images/profile_photo.png',
    ),
  ];

  int get enrolledCount => students.length;
  int get absentCount =>
      students.where((s) => s.status == AttendanceStatus.absent).length;

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
      children: [
        Text(
          'CLASS 4B • HISTORY OF ART',
          style: AppTextStyle.bold12.copyWith(
            color: AppColors.grey,
            letterSpacing: 1.0,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'Attendance Check',
          style: AppTextStyle.bold24.copyWith(color: AppColors.black, fontSize: 32),
        ),
        const SizedBox(height: 8),
        Text(
          'Monday, October 23rd • Morning Session',
          style: AppTextStyle.medium14.copyWith(color: AppColors.grey),
        ),
        const SizedBox(height: 24),
        AttendanceStatsRow(
          enrolledCount: enrolledCount,
          absentCount: absentCount,
        ),
        const SizedBox(height: 24),
        ...List.generate(students.length, (index) {
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
        }),
      ],
    );
  }
}
