import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:school_system/features/student/data/models/weekly_schedule_models.dart';
import 'package:school_system/features/student/presentation/manager/student_weekly_schedule_cubit/student_weekly_schedule_cubit.dart';
import 'package:school_system/features/student/presentation/manager/student_weekly_schedule_cubit/student_weekly_schedule_state.dart';
import 'package:school_system/features/student/presentation/views/widgets/weekly_schedule_header.dart';
import 'package:school_system/features/student/presentation/views/widgets/weekly_days_selector.dart';
import 'package:school_system/features/student/presentation/views/widgets/daily_curriculum_section.dart';
import 'package:school_system/core/helper/localization_helper.dart';

class WeeklyScheduleViewBody extends StatefulWidget {
  const WeeklyScheduleViewBody({super.key});

  @override
  State<WeeklyScheduleViewBody> createState() => _WeeklyScheduleViewBodyState();
}

class _WeeklyScheduleViewBodyState extends State<WeeklyScheduleViewBody> {
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
    // Optional: reload API data for the new week here if the API supported passing dates.
    // context.read<StudentWeeklyScheduleCubit>().fetchWeeklySchedule();
  }

  DateTime _mondayOfWeek(DateTime date) {
    return DateTime(date.year, date.month, date.day).subtract(
      Duration(days: date.weekday - DateTime.monday),
    );
  }

  int _weekNumber(DateTime date) {
    final firstDay = DateTime(date.year, 1, 1);
    final dayOfYear = date.difference(firstDay).inDays + 1;
    return ((dayOfYear - date.weekday + 10) / 7).floor();
  }

  String _getMonthName(int month) {
    if (LocalizationHelper.isArabic) {
      const months = [
        'يناير', 'فبراير', 'مارس', 'أبريل', 'مايو', 'يونيو', 'يوليو', 'أغسطس', 'سبتمبر', 'أكتوبر', 'نوفمبر', 'ديسمبر'
      ];
      return months[month - 1];
    }
    const months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
    ];
    return months[month - 1];
  }

  String _getHeaderDateRange() {
    final endDate = _currentStartDate.add(const Duration(days: 4)); // Friday
    return '${_getMonthName(_currentStartDate.month)} ${_currentStartDate.day} - ${_getMonthName(endDate.month)} ${endDate.day},\n${endDate.year}';
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<StudentWeeklyScheduleCubit, StudentWeeklyScheduleState>(
      builder: (context, state) {
        if (state is StudentWeeklyScheduleLoading || state is StudentWeeklyScheduleInitial) {
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
              subtitle: 'Room 101 • Grade 10 • Teacher',
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

        if (state is StudentWeeklyScheduleFailure) {
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

        if (state is StudentWeeklyScheduleSuccess) {
          final data = state.data;
          
          // Generate days from API 'calendar'
          final generatedDays = data.calendar.map((cal) {
            String dayNameTranslated = cal.dayName.toUpperCase();
            if (LocalizationHelper.isArabic) {
              switch (dayNameTranslated) {
                case 'MON': dayNameTranslated = 'إثنين'; break;
                case 'TUE': dayNameTranslated = 'ثلاثاء'; break;
                case 'WED': dayNameTranslated = 'أربعاء'; break;
                case 'THU': dayNameTranslated = 'خميس'; break;
                case 'FRI': dayNameTranslated = 'جمعة'; break;
                case 'SAT': dayNameTranslated = 'سبت'; break;
                case 'SUN': dayNameTranslated = 'أحد'; break;
              }
            }
            return ScheduleDay(
              dayName: dayNameTranslated,
              dayNumber: cal.dayNumber.toString(),
              classCount: cal.classesCount,
            );
          }).toList();

          // Fix selected index if it's out of bounds
          if (_selectedDayIndex >= generatedDays.length) {
            _selectedDayIndex = generatedDays.isEmpty ? 0 : generatedDays.length - 1;
          }

          // Fetch items for the selected day from API 'weeklyTimetable'
          List<CurriculumItem> curriculumItems = [];
          String selectedDateString = '';

          if (data.weeklyTimetable.isNotEmpty && _selectedDayIndex < data.weeklyTimetable.length && _selectedDayIndex >= 0) {
            final dayData = data.weeklyTimetable[_selectedDayIndex];
            selectedDateString = dayData.date; // e.g. "أبريل 20" or "April 20"
            curriculumItems = dayData.lessons.map((lesson) {
              return CurriculumItem(
                startTime: lesson.time,
                endTime: '', // Missing in API response
                title: lesson.subjectName,
                subtitle: LocalizationHelper.isArabic
                    ? 'غرفة ${lesson.room} • ${lesson.teacherName}'
                    : '${lesson.room} • ${lesson.teacherName}',
                type: 'REQUIRED',
              );
            }).toList();
          }

          return SingleChildScrollView(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                WeeklyScheduleHeader(
                  dateRangeText: _getHeaderDateRange(), // or from API if needed
                  weekText: LocalizationHelper.isArabic
                      ? 'الفصل الدراسي الربيعي • الأسبوع $_currentWeekNumber'
                      : 'Spring Semester • Week $_currentWeekNumber',
                  onPreviousWeek: () => _changeWeek(-7),
                  onNextWeek: () => _changeWeek(7),
                ),
                const SizedBox(height: 24),
                if (generatedDays.isNotEmpty)
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
                  dateString: selectedDateString,
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

