import 'package:flutter/material.dart';
import 'package:school_system/core/utils/app_colors.dart';
import 'package:school_system/core/utils/app_text_style.dart';
import 'package:school_system/features/parent/presentation/views/widgets/kid_section_header.dart';

class KidAttendanceTab extends StatelessWidget {
  const KidAttendanceTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const KidSectionHeader(
            icon: Icons.calendar_view_day,
            title: 'This Week Attendance',
          ),
          const SizedBox(height: 16),
          const _ThisWeekAttendanceList(),
          const SizedBox(height: 32),
          const KidSectionHeader(
            icon: Icons.bar_chart,
            title: 'Subject Attendance',
          ),
          const SizedBox(height: 16),
          const _SubjectAttendanceList(),
          const SizedBox(height: 40),
        ],
      ),
    );
  }
}

class _ThisWeekAttendanceList extends StatelessWidget {
  const _ThisWeekAttendanceList();

  static const _attendance = [
    {'day': 'Sunday', 'date': 'Oct 20, 2024', 'status': 'PRESENT'},
    {'day': 'Monday', 'date': 'Oct 21, 2024', 'status': 'PRESENT'},
    {'day': 'Tuesday', 'date': 'Oct 22, 2024', 'status': 'LATE'},
    {'day': 'Wednesday', 'date': 'Oct 23, 2024', 'status': 'ABSENT'},
    {'day': 'Thursday (Today)', 'date': 'Oct 24, 2024', 'status': 'PRESENT'},
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.lightGrey.withValues(alpha: 0.3)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: _attendance.asMap().entries.map((entry) {
          final item = entry.value;
          final isLast = entry.key == _attendance.length - 1;
          final isToday = item['day']!.contains('Today');
          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                child: Row(
                  children: [
                    Container(
                      width: 36,
                      height: 36,
                      decoration: BoxDecoration(
                        color: isToday
                            ? AppColors.primaryColor.withValues(alpha: 0.1)
                            : AppColors.lightGrey.withValues(alpha: 0.15),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.calendar_today_rounded,
                        size: 16,
                        color: isToday ? AppColors.primaryColor : AppColors.grey,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          item['day']!,
                          style: AppTextStyle.bold14.copyWith(
                            color: isToday ? AppColors.primaryColor : AppColors.darkBlue,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          item['date']!,
                          style: AppTextStyle.regular12.copyWith(color: AppColors.grey),
                        ),
                      ],
                    ),
                    const Spacer(),
                    _AttendanceChip(status: item['status']!),
                  ],
                ),
              ),
              if (!isLast)
                Divider(
                  height: 1,
                  color: AppColors.grey.withValues(alpha: 0.08),
                  indent: 16,
                  endIndent: 16,
                ),
            ],
          );
        }).toList(),
      ),
    );
  }
}

class _AttendanceChip extends StatelessWidget {
  final String status;
  const _AttendanceChip({required this.status});

  Color get _bgColor {
    switch (status) {
      case 'PRESENT': return const Color(0xFFE8F5E9);
      case 'LATE':    return const Color(0xFFFFF3E0);
      case 'ABSENT':  return const Color(0xFFFFEBEE);
      default:        return AppColors.lightGrey;
    }
  }

  Color get _textColor {
    switch (status) {
      case 'PRESENT': return const Color(0xFF4CAF50);
      case 'LATE':    return const Color(0xFFFF9800);
      case 'ABSENT':  return const Color(0xFFF44336);
      default:        return AppColors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
      decoration: BoxDecoration(
        color: _bgColor,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        status,
        style: AppTextStyle.bold12.copyWith(color: _textColor, fontSize: 11),
      ),
    );
  }
}

class _SubjectAttendanceList extends StatelessWidget {
  const _SubjectAttendanceList();

  static const _subjects = [
    {'name': 'Mathematics', 'sessions': '19/20 sessions', 'percent': 95},
    {'name': 'Computer Science', 'sessions': '17/20 sessions', 'percent': 85},
    {'name': 'World History', 'sessions': '20/20 sessions', 'percent': 100},
    {'name': 'Modern Chemistry', 'sessions': '18/20 sessions', 'percent': 90},
  ];

  static const _colors = [
    Color(0xff004EEB),
    Color(0xff0F52BD),
    Color(0xff12B76A),
    Color(0xffF04438),
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.lightGrey.withValues(alpha: 0.3)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: _subjects.asMap().entries.map((entry) {
          final subject = entry.value;
          final color = _colors[entry.key];
          return Padding(
            padding: const EdgeInsets.only(bottom: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: color.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Icon(Icons.menu_book_rounded, size: 16, color: color),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            subject['name'] as String,
                            style: AppTextStyle.bold14.copyWith(color: AppColors.darkBlue),
                          ),
                          Text(
                            subject['sessions'] as String,
                            style: AppTextStyle.regular12.copyWith(color: AppColors.grey),
                          ),
                        ],
                      ),
                    ),
                    Text(
                      '${subject['percent']}%',
                      style: AppTextStyle.bold14.copyWith(color: color),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: LinearProgressIndicator(
                    value: (subject['percent'] as int) / 100,
                    backgroundColor: AppColors.grey.withValues(alpha: 0.08),
                    valueColor: AlwaysStoppedAnimation<Color>(color),
                    minHeight: 6,
                  ),
                ),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }
}
