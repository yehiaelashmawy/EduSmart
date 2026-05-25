import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:school_system/core/utils/app_colors.dart';
import 'package:school_system/features/student/data/models/student_weekly_schedule_model.dart';
import 'package:school_system/features/student/presentation/manager/student_weekly_schedule_cubit/student_weekly_schedule_cubit.dart';
import 'package:school_system/features/student/presentation/manager/student_weekly_schedule_cubit/student_weekly_schedule_state.dart';
import 'package:school_system/core/helper/localization_helper.dart';

class StudentTodaySchedule extends StatelessWidget {
  const StudentTodaySchedule({super.key});

  /// Maps Dart's [DateTime.weekday] (1=Mon…7=Sun) to the API day index (0=Mon…4=Fri).
  /// Returns -1 if it's a weekend (Sat/Sun), meaning no school today.
  int _todayIndex() {
    final weekday = DateTime.now().weekday; // 1=Mon … 7=Sun
    if (weekday >= 1 && weekday <= 5) return weekday - 1;
    return -1;
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<StudentWeeklyScheduleCubit, StudentWeeklyScheduleState>(
      builder: (context, state) {
        // ── Loading / Initial ──────────────────────────────────────────────────
        if (state is StudentWeeklyScheduleInitial ||
            state is StudentWeeklyScheduleLoading) {
          return _buildShell(
            context,
            child: Skeletonizer(
              enabled: true,
              child: _buildScheduleList([
                _fakeSkeleton('09:00', 'AM', 'Mathematics', 'Room 101', true),
                _fakeSkeleton('11:00', 'AM', 'Physics', 'Room 204', false),
                _fakeSkeleton('02:00', 'PM', 'Chemistry', 'LAB B', false),
              ]),
            ),
          );
        }

        // ── Error ──────────────────────────────────────────────────────────────
        if (state is StudentWeeklyScheduleFailure) {
          return _buildShell(
            context,
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 24),
              child: Center(
                child: Text(
                  state.error.errorMessage,
                  textAlign: TextAlign.center,
                  style: TextStyle(color: AppColors.grey),
                ),
              ),
            ),
          );
        }

        // ── Success ────────────────────────────────────────────────────────────
        if (state is StudentWeeklyScheduleSuccess) {
          final todayIdx = _todayIndex();

          // Weekend
          if (todayIdx == -1) {
            return _buildShell(
              context,
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 24),
                child: Center(
                  child: Text(
                    LocalizationHelper.isArabic ? 'لا توجد فصول اليوم 🎉' : 'No classes today 🎉',
                    style: TextStyle(color: AppColors.grey),
                  ),
                ),
              ),
            );
          }

          // Find today's timetable entry
          StudentWeeklyTimetableDay? todayData;
          if (todayIdx < state.data.weeklyTimetable.length) {
            todayData = state.data.weeklyTimetable[todayIdx];
          }

          if (todayData == null || todayData.lessons.isEmpty) {
            return _buildShell(
              context,
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 24),
                child: Center(
                  child: Text(
                    LocalizationHelper.isArabic
                        ? 'لا توجد فصول مجدولة لليوم.'
                        : 'No classes scheduled for today.',
                    style: TextStyle(color: AppColors.grey),
                  ),
                ),
              ),
            );
          }

          // Determine the currently active lesson (based on time)
          final now = TimeOfDay.now();
          int activeIndex = -1;
          for (int i = 0; i < todayData.lessons.length; i++) {
            final lessonTime = _parseTime(todayData.lessons[i].time);
            if (lessonTime != null) {
              final lessonMinutes = lessonTime.hour * 60 + lessonTime.minute;
              final nowMinutes = now.hour * 60 + now.minute;
              // Mark a lesson as active if it started within the past 60 minutes
              if (nowMinutes >= lessonMinutes &&
                  nowMinutes < lessonMinutes + 60) {
                activeIndex = i;
                break;
              }
            }
          }

          final items = todayData.lessons.asMap().entries.map((entry) {
            final i = entry.key;
            final lesson = entry.value;
            final parsed = _parseTime(lesson.time);
            final isLast = i == todayData!.lessons.length - 1;

            String timeStr = lesson.time;
            String period = '';
            if (parsed != null) {
              final hour = parsed.hour % 12 == 0 ? 12 : parsed.hour % 12;
              final minute =
                  parsed.minute.toString().padLeft(2, '0');
              timeStr = '$hour:$minute';
              period = parsed.hour < 12 ? 'AM' : 'PM';
            }

            return _ScheduleItem(
              time: timeStr,
              period: period,
              subject: lesson.subjectName,
              topic: lesson.teacherName,
              room: lesson.room,
              isActive: i == activeIndex,
              hasDivider: !isLast,
            );
          }).toList();

          return _buildShell(
            context,
            child: _buildScheduleList(items),
          );
        }

        return const SizedBox.shrink();
      },
    );
  }

  /// The outer section wrapper (title + "VIEW WEEK SCHEDULE" button).
  Widget _buildShell(BuildContext context, {required Widget child}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  LocalizationHelper.isArabic ? "جدول" : "Today's",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: AppColors.darkBlue,
                    height: 1.1,
                  ),
                ),
                Text(
                  LocalizationHelper.isArabic ? "اليوم" : 'Schedule',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: AppColors.darkBlue,
                    height: 1.1,
                  ),
                ),
              ],
            ),
            OutlinedButton(
              onPressed: () {
                Navigator.of(context, rootNavigator: true)
                    .pushNamed('weekly_schedule_view');
              },
              style: OutlinedButton.styleFrom(
                side: BorderSide(
                  color: AppColors.primaryColor.withValues(alpha: 0.3),
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
              ),
              child: Text(
                LocalizationHelper.isArabic ? 'عرض جدول\nالأسبوع' : 'VIEW WEEK\nSCHEDULE',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                  color: AppColors.primaryColor,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 20),
        child,
      ],
    );
  }

  Widget _buildScheduleList(List<Widget> items) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.lightGrey.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: AppColors.lightGrey.withValues(alpha: 0.3),
        ),
      ),
      child: Column(children: items),
    );
  }

  // Skeleton placeholder item
  _ScheduleItem _fakeSkeleton(
    String time,
    String period,
    String subject,
    String room,
    bool isActive,
  ) {
    return _ScheduleItem(
      time: time,
      period: period,
      subject: subject,
      topic: 'Prof. Placeholder',
      room: room,
      isActive: isActive,
      hasDivider: true,
    );
  }

  TimeOfDay? _parseTime(String raw) {
    // Supports "HH:mm" or "H:mm AM/PM"
    final trimmed = raw.trim();
    // Try 24-hour first
    final re24 = RegExp(r'^(\d{1,2}):(\d{2})$');
    final m24 = re24.firstMatch(trimmed);
    if (m24 != null) {
      return TimeOfDay(
        hour: int.parse(m24.group(1)!),
        minute: int.parse(m24.group(2)!),
      );
    }
    // Try 12-hour
    final re12 = RegExp(r'^(\d{1,2}):(\d{2})\s*(AM|PM)$', caseSensitive: false);
    final m12 = re12.firstMatch(trimmed);
    if (m12 != null) {
      int hour = int.parse(m12.group(1)!);
      final minute = int.parse(m12.group(2)!);
      final isPm = m12.group(3)!.toUpperCase() == 'PM';
      if (isPm && hour != 12) hour += 12;
      if (!isPm && hour == 12) hour = 0;
      return TimeOfDay(hour: hour, minute: minute);
    }
    return null;
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Private schedule row widget (unchanged visual design)
// ─────────────────────────────────────────────────────────────────────────────

class _ScheduleItem extends StatelessWidget {
  final String time;
  final String period;
  final String subject;
  final String topic;
  final String room;
  final bool isActive;
  final bool hasDivider;

  const _ScheduleItem({
    required this.time,
    required this.period,
    required this.subject,
    required this.topic,
    required this.room,
    required this.isActive,
    required this.hasDivider,
  });

  @override
  Widget build(BuildContext context) {
    return IntrinsicHeight(
      child: Row(
        children: [
          Container(
            width: 70,
            padding: const EdgeInsets.symmetric(vertical: 20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  time,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: isActive ? AppColors.primaryColor : AppColors.grey,
                  ),
                ),
                Text(
                  period,
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight:
                        isActive ? FontWeight.bold : FontWeight.normal,
                    color: isActive ? AppColors.primaryColor : AppColors.grey,
                  ),
                ),
              ],
            ),
          ),
          VerticalDivider(
            color: isActive ? AppColors.primaryColor : Colors.transparent,
            thickness: 2,
            width: 2,
            indent: 10,
            endIndent: 10,
          ),
          Expanded(
            child: Container(
              padding: const EdgeInsets.fromLTRB(16, 20, 16, 0),
              child: Column(
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              subject,
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: AppColors.darkBlue,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              topic,
                              style: TextStyle(
                                fontSize: 12,
                                color: AppColors.grey,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: isActive
                              ? AppColors.primaryColor
                              : AppColors.grey.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          room,
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                            color: isActive ? Colors.white : AppColors.grey,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      isActive
                          ? GestureDetector(
                              onTap: () {
                                Navigator.pushNamed(
                                  context,
                                  'student_attendance_method_view',
                                  arguments: subject,
                                );
                              },
                              child: Container(
                                padding: const EdgeInsets.all(4),
                                decoration: BoxDecoration(
                                  color: AppColors.primaryColor,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: const Icon(
                                  Icons.person,
                                  color: Colors.white,
                                  size: 16,
                                ),
                              ),
                            )
                          : const Icon(
                              Icons.more_vert,
                              color: Colors.grey,
                              size: 24,
                            ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  if (hasDivider)
                    Divider(
                      height: 1,
                      thickness: 1,
                      color: AppColors.lightGrey.withValues(alpha: 0.3),
                    ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
