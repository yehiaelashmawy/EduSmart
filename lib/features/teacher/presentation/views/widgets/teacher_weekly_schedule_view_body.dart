import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:school_system/features/student/data/models/weekly_schedule_models.dart';
import 'package:school_system/features/teacher/presentation/manager/teacher_weekly_schedule_cubit/teacher_weekly_schedule_cubit.dart';
import 'package:school_system/features/teacher/presentation/manager/teacher_weekly_schedule_cubit/teacher_weekly_schedule_state.dart';
import 'package:school_system/features/student/presentation/views/widgets/weekly_schedule_header.dart';
import 'package:school_system/features/student/presentation/views/widgets/weekly_days_selector.dart';
import 'package:school_system/features/student/presentation/views/widgets/daily_curriculum_section.dart';
import 'package:school_system/core/helper/localization_helper.dart';

class TeacherWeeklyScheduleViewBody extends StatefulWidget {
  const TeacherWeeklyScheduleViewBody({super.key});

  @override
  State<TeacherWeeklyScheduleViewBody> createState() =>
      _TeacherWeeklyScheduleViewBodyState();
}

class _TeacherWeeklyScheduleViewBodyState
    extends State<TeacherWeeklyScheduleViewBody> {
  int _selectedDayIndex = 0;
  late DateTime _currentStartDate;
  late int _currentWeekNumber;

  @override
  void initState() {
    super.initState();
    _currentStartDate = _mondayOfWeek(DateTime.now());
    _currentWeekNumber = _weekNumber(DateTime.now());
    final todayIndex = DateTime.now().weekday - 1;
    _selectedDayIndex = todayIndex.clamp(0, 4);
  }

  void _changeWeek(int days) {
    setState(() {
      _currentStartDate = _currentStartDate.add(Duration(days: days));
      _currentWeekNumber = _weekNumber(_currentStartDate);
      _selectedDayIndex = 0; // Reset selection to first day
    });
  }

  DateTime _mondayOfWeek(DateTime date) {
    return DateTime(
      date.year,
      date.month,
      date.day,
    ).subtract(Duration(days: date.weekday - DateTime.monday));
  }

  int _weekNumber(DateTime date) {
    final firstDay = DateTime(date.year, 1, 1);
    final dayOfYear = date.difference(firstDay).inDays + 1;
    return ((dayOfYear - date.weekday + 10) / 7).floor();
  }

  String _getMonthName(int month) {
    if (LocalizationHelper.isArabic) {
      const months = [
        'يناير', 'فبراير', 'مارس', 'أبريل', 'مايو', 'يونيو',
        'يوليو', 'أغسطس', 'سبتمبر', 'أكتوبر', 'نوفمبر', 'ديسمبر'
      ];
      return months[month - 1];
    }
    const months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec',
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

  String _dayKeyFromDate(DateTime date) {
    switch (date.weekday) {
      case DateTime.monday:
        return 'Monday';
      case DateTime.tuesday:
        return 'Tuesday';
      case DateTime.wednesday:
        return 'Wednesday';
      case DateTime.thursday:
        return 'Thursday';
      case DateTime.friday:
        return 'Friday';
      case DateTime.saturday:
        return 'Saturday';
      case DateTime.sunday:
        return 'Sunday';
      default:
        return 'Monday';
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TeacherWeeklyScheduleCubit, TeacherWeeklyScheduleState>(
      builder: (context, state) {
        if (state is TeacherWeeklyScheduleLoading ||
            state is TeacherWeeklyScheduleInitial) {
          final skeletonDays = List.generate(
            5,
            (index) => ScheduleDay(
              dayName: ['MON', 'TUE', 'WED', 'THU', 'FRI'][index],
              dayNumber: '${index + 10}',
              classCount: 3,
            ),
          );
          final skeletonItems = List.generate(
            4,
            (_) => CurriculumItem(
              startTime: '08:00',
              endTime: '09:00',
              title: 'Mathematics',
              subtitle: 'Room 101 • Grade 10',
              type: 'REQUIRED',
            ),
          );

          return Skeletonizer(
            enabled: true,
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  WeeklyScheduleHeader(
                    dateRangeText: 'Apr 14 - Apr 18,\n2026',
                    weekText: LocalizationHelper.isArabic
                        ? 'الفصل الدراسي الربيعي • الأسبوع 12'
                        : 'Spring Semester • Week 12',
                    onPreviousWeek: () {},
                    onNextWeek: () {},
                  ),
                  const SizedBox(height: 24),
                  WeeklyDaysSelector(
                    days: skeletonDays,
                    selectedIndex: 0,
                    onDaySelected: (_) {},
                  ),
                  const SizedBox(height: 32),
                  DailyCurriculumSection(
                    dateString: 'APRIL 14',
                    items: skeletonItems,
                  ),
                  const SizedBox(height: 24),
                ],
              ),
            ),
          );
        }

        if (state is TeacherWeeklyScheduleFailure) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Text(
                state.error.errorMessage,
                textAlign: TextAlign.center,
              ),
            ),
          );
        }

        if (state is TeacherWeeklyScheduleSuccess) {
          final weeklySchedule = state.weeklySchedule;

          final generatedDays = List.generate(5, (index) {
            final date = _currentStartDate.add(Duration(days: index));
            final dayKey = _dayKeyFromDate(date);
            final count = weeklySchedule[dayKey]?.length ?? 0;
            return ScheduleDay(
              dayName: _getDayNameShort(date.weekday),
              dayNumber: date.day.toString(),
              classCount: count,
            );
          });

          List<CurriculumItem> curriculumItems = [];

          final selectedDate = _currentStartDate.add(
            Duration(days: _selectedDayIndex),
          );
          final selectedKey = _dayKeyFromDate(selectedDate);
          final selectedClasses = weeklySchedule[selectedKey] ?? [];

          curriculumItems = selectedClasses.map((item) {
            return CurriculumItem(
              startTime: item.startTime,
              endTime: item.endTime,
              title: item.subjectName,
              subtitle: '${item.room} • ${item.className}',
              type: 'REQUIRED',
            );
          }).toList();

          return SingleChildScrollView(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                WeeklyScheduleHeader(
                  dateRangeText: _getHeaderDateRange(),
                  weekText: LocalizationHelper.isArabic
                      ? 'الفصل الدراسي الربيعي • الأسبوع $_currentWeekNumber'
                      : 'Spring Semester • Week $_currentWeekNumber',
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
                  items: curriculumItems,
                ),
                const SizedBox(height: 24),
              ],
            ),
          );
        }

        return const SizedBox();
      },
    );
  }
}
