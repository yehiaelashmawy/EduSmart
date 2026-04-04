import 'package:flutter/material.dart';
import 'package:school_system/core/utils/app_colors.dart';
import 'package:school_system/core/utils/app_text_style.dart';
import 'package:school_system/features/teacher/presentation/views/widgets/attendance_report_summary_card.dart';
import 'package:school_system/features/teacher/presentation/views/widgets/attendance_report_month_filter.dart';
import 'package:school_system/features/teacher/presentation/views/widgets/student_report_card.dart';

class AttendanceReportViewBody extends StatefulWidget {
  const AttendanceReportViewBody({super.key});

  @override
  State<AttendanceReportViewBody> createState() =>
      _AttendanceReportViewBodyState();
}

class _AttendanceReportViewBodyState extends State<AttendanceReportViewBody> {
  DateTime _currentDate = DateTime.now();

  static const List<String> _months = [
    'January',
    'February',
    'March',
    'April',
    'May',
    'June',
    'July',
    'August',
    'September',
    'October',
    'November',
    'December',
  ];

  String get _formattedMonth =>
      '${_months[_currentDate.month - 1]} ${_currentDate.year}';

  void _previousMonth() {
    setState(() {
      _currentDate = DateTime(_currentDate.year, _currentDate.month - 1);
    });
  }

  void _nextMonth() {
    setState(() {
      _currentDate = DateTime(_currentDate.year, _currentDate.month + 1);
    });
  }

  // Dummy student data
  final List<Map<String, dynamic>> _students = [
    {
      'name': 'Julianne Devis',
      'roll': '101',
      'avatar': 'assets/images/Ellipse 375.png',
      'percentage': 95,
    },
    {
      'name': 'Arthur Morgan',
      'roll': '102',
      'avatar': 'assets/images/Ellipse 375.png',
      'percentage': 72,
    },
    {
      'name': 'Lydia Bennet',
      'roll': '103',
      'avatar': 'assets/images/Ellipse 375.png',
      'percentage': 88,
    },
    {
      'name': 'Tobias Kingston',
      'roll': '104',
      'avatar': 'assets/images/Ellipse 375.png',
      'percentage': 55,
    },
    {
      'name': 'Sarah Walker',
      'roll': '105',
      'avatar': 'assets/images/Ellipse 375.png',
      'percentage': 91,
    },
    {
      'name': 'Marcus Lee',
      'roll': '106',
      'avatar': 'assets/images/Ellipse 375.png',
      'percentage': 82,
    },
    {
      'name': 'Clara Hunt',
      'roll': '107',
      'avatar': 'assets/images/Ellipse 375.png',
      'percentage': 48,
    },
  ];

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
      children: [
        Text(
          'Mathematics: Advanced Algebra',
          style: AppTextStyle.bold18.copyWith(color: AppColors.black),
        ),
        const SizedBox(height: 4),
        Text(
          'Grade 10-A',
          style: AppTextStyle.medium14.copyWith(color: AppColors.grey),
        ),
        const SizedBox(height: 24),

        AttendanceReportMonthFilter(
          currentMonth: _formattedMonth,
          onPrevious: _previousMonth,
          onNext: _nextMonth,
        ),

        const SizedBox(height: 24),

        const AttendanceReportSummaryCard(
          totalPercentage: 85,
          presentDays: 28,
          absentDays: 5,
          lateDays: 2,
        ),

        const SizedBox(height: 32),

        Text(
          'Student Breakdown',
          style: AppTextStyle.bold18.copyWith(color: AppColors.black),
        ),
        const SizedBox(height: 16),

        ..._students.map(
          (s) => StudentReportCard(
            name: s['name'] as String,
            rollNumber: s['roll'] as String,
            attendancePercentage: s['percentage'] as int,
            avatarPath:
                '', // Keeping empty to fallback to icon if image missing
          ),
        ),
      ],
    );
  }
}
