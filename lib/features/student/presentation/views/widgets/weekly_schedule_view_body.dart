import 'package:flutter/material.dart';
import 'package:school_system/features/student/data/models/weekly_schedule_models.dart';
import 'package:school_system/features/student/presentation/views/widgets/weekly_schedule_header.dart';
import 'package:school_system/features/student/presentation/views/widgets/weekly_days_selector.dart';
import 'package:school_system/features/student/presentation/views/widgets/daily_curriculum_section.dart';

class WeeklyScheduleViewBody extends StatefulWidget {
  const WeeklyScheduleViewBody({super.key});

  @override
  State<WeeklyScheduleViewBody> createState() => _WeeklyScheduleViewBodyState();
}

class _WeeklyScheduleViewBodyState extends State<WeeklyScheduleViewBody> {
  int _selectedDayIndex = 1;
  late DateTime _currentStartDate;
  int _currentWeekNumber = 12;

  @override
  void initState() {
    super.initState();
    // Initialize to a Monday. E.g. Apr 6, 2026 is a Monday.
    _currentStartDate = DateTime(2026, 4, 6);
  }

  void _changeWeek(int days) {
    setState(() {
      _currentStartDate = _currentStartDate.add(Duration(days: days));
      if (days < 0) {
        _currentWeekNumber = _currentWeekNumber > 1
            ? _currentWeekNumber - 1
            : 1;
      } else {
        _currentWeekNumber++;
      }
      _selectedDayIndex = 0; // Reset selection to first day (Monday)
    });
  }

  String _getMonthName(int month) {
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
    return months[month - 1];
  }

  String _getFullMonthName(int month) {
    const months = [
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
    return months[month - 1];
  }

  String _getDayNameShort(int weekday) {
    const days = ['MON', 'TUE', 'WED', 'THU', 'FRI', 'SAT', 'SUN'];
    return days[weekday - 1];
  }

  String _getHeaderDateRange() {
    final endDate = _currentStartDate.add(const Duration(days: 4)); // Friday
    return '${_getMonthName(_currentStartDate.month)} ${_currentStartDate.day} - ${_getMonthName(endDate.month)} ${endDate.day},\n${endDate.year}';
  }

  String _getSelectedDateString() {
    final selectedDate = _currentStartDate.add(
      Duration(days: _selectedDayIndex),
    );
    return '${_getFullMonthName(selectedDate.month)} ${selectedDate.day.toString().padLeft(2, '0')}'
        .toUpperCase();
  }

  List<ScheduleDay> _generateDays() {
    final List<ScheduleDay> days = [];
    for (int i = 0; i < 5; i++) {
      final date = _currentStartDate.add(Duration(days: i));
      days.add(
        ScheduleDay(
          dayName: _getDayNameShort(date.weekday),
          dayNumber: date.day.toString(),
          classCount: (i % 3) + 2, // Dummy count logic
        ),
      );
    }
    return days;
  }

  final List<CurriculumItem> _curriculumItems = [
    CurriculumItem(
      startTime: '09:00',
      endTime: '10:30 AM',
      title: 'Advanced Physics II',
      subtitle: 'Lecture Hall B • Prof. Richardson',
      type: 'REQUIRED',
      isActive: true,
      avatars: ['url1', 'url2', '+12'],
    ),
    CurriculumItem(
      startTime: '10:45',
      endTime: '12:15 PM',
      title: 'Discrete Mathematics',
      subtitle: 'Room 402 • Dr. Aris Thorne',
      type: 'ELECTIVE',
      alertText: 'Assignment Due',
    ),
    CurriculumItem(startTime: '', endTime: '', title: '', type: 'LUNCH_BREAK'),
    CurriculumItem(
      startTime: '14:00',
      endTime: '15:30 PM',
      title: 'Computer Architecture',
      subtitle: 'Cyber Lab 1 • Prof. Jensen',
      type: 'REQUIRED',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final generatedDays = _generateDays();

    return SingleChildScrollView(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          WeeklyScheduleHeader(
            dateRangeText: _getHeaderDateRange(),
            weekText: 'Spring Semester • Week $_currentWeekNumber',
            onPreviousWeek: () => _changeWeek(-7),
            onNextWeek: () => _changeWeek(7),
          ),
          const SizedBox(height: 24),
          WeeklyDaysSelector(
            days: generatedDays,
            selectedIndex: _selectedDayIndex,
            onDaySelected: (index) {
              setState(() {
                _selectedDayIndex = index;
              });
            },
          ),
          const SizedBox(height: 32),
          DailyCurriculumSection(
            dateString: _getSelectedDateString(),
            items: _curriculumItems,
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }
}
