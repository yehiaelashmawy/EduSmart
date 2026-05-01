import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:school_system/core/utils/app_colors.dart';
import 'package:school_system/features/student/presentation/manager/student_weekly_schedule_cubit/student_weekly_schedule_cubit.dart';
import 'package:school_system/features/student/presentation/manager/student_weekly_schedule_cubit/student_weekly_schedule_state.dart';
import 'package:school_system/features/student/data/models/student_weekly_schedule_model.dart';

class NextClassCard extends StatelessWidget {
  const NextClassCard({super.key});

  int _todayIndex() {
    final weekday = DateTime.now().weekday; // 1=Mon … 7=Sun
    if (weekday >= 1 && weekday <= 5) return weekday - 1;
    return -1;
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<StudentWeeklyScheduleCubit, StudentWeeklyScheduleState>(
      builder: (context, state) {
        if (state is StudentWeeklyScheduleLoading ||
            state is StudentWeeklyScheduleInitial) {
          return _buildSkeleton();
        }

        if (state is StudentWeeklyScheduleSuccess) {
          final nextClass = _findNextClass(state.data.weeklyTimetable);
          if (nextClass == null) {
            return _buildNoMoreClassesCard();
          }
          return _buildDynamicCard(nextClass);
        }

        return const SizedBox.shrink();
      },
    );
  }

  Widget _buildSkeleton() {
    return Skeletonizer(
      enabled: true,
      child: _buildDynamicCard(
        StudentLesson(
          time: '09:00 AM',
          subjectName: 'Loading Subject',
          teacherName: 'Teacher Name',
          room: 'Room 000',
        ),
      ),
    );
  }

  Widget _buildNoMoreClassesCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: AppColors.lightGrey.withValues(alpha: 0.2)),
        boxShadow: [
          BoxShadow(
            color: AppColors.black.withValues(alpha: 0.03),
            blurRadius: 15,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppColors.primaryColor.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(Icons.celebration_outlined,
                color: AppColors.primaryColor, size: 28),
          ),
          const SizedBox(height: 16),
          Text(
            'All classes completed!',
            style: TextStyle(
              color: AppColors.darkBlue,
              fontWeight: FontWeight.bold,
              fontSize: 18,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            'No more scheduled lessons for today. Enjoy your time!',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: AppColors.grey,
              fontSize: 13,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDynamicCard(StudentLesson lesson) {
    final diff = _calculateTimeDiff(lesson.time);
    String diffText = 'Starting soon';
    if (diff != null) {
      if (diff.inMinutes < 60) {
        diffText = 'In ${diff.inMinutes} mins';
      } else {
        diffText = 'In ${diff.inHours} ${diff.inHours == 1 ? 'hour' : 'hours'}';
      }
    }

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [AppColors.primaryColor, AppColors.secondaryColor],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: AppColors.primaryColor.withValues(alpha: 0.35),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Text(
                  'NEXT CLASS',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1,
                  ),
                ),
              ),
              Text(
                diffText,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          Text(
            lesson.subjectName,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 26,
              fontWeight: FontWeight.bold,
              letterSpacing: -0.5,
            ),
          ),
          const SizedBox(height: 6),
          Row(
            children: [
              Icon(Icons.location_on_outlined,
                  color: Colors.white.withValues(alpha: 0.8), size: 14),
              const SizedBox(width: 4),
              Text(
                'Room ${lesson.room}',
                style: TextStyle(
                  color: Colors.white.withValues(alpha: 0.9),
                  fontSize: 14,
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          Container(
            padding: const EdgeInsets.symmetric(vertical: 16),
            decoration: BoxDecoration(
              border: Border(
                top: BorderSide(color: Colors.white.withValues(alpha: 0.15)),
              ),
            ),
            child: Row(
              children: [
                const Icon(Icons.access_time_filled,
                    color: Colors.white, size: 18),
                const SizedBox(width: 8),
                Text(
                  lesson.time,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(width: 32),
                const Icon(Icons.person, color: Colors.white, size: 18),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    lesson.teacherName,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  StudentLesson? _findNextClass(List<StudentWeeklyTimetableDay> timetable) {
    final idx = _todayIndex();
    if (idx == -1 || idx >= timetable.length) return null;

    final todayData = timetable[idx];
    if (todayData.lessons.isEmpty) return null;

    final now = TimeOfDay.now();
    final nowMinutes = now.hour * 60 + now.minute;

    for (var lesson in todayData.lessons) {
      final lessonTime = _parseTime(lesson.time);
      if (lessonTime != null) {
        final lessonMinutes = lessonTime.hour * 60 + lessonTime.minute;
        if (lessonMinutes > nowMinutes) {
          return lesson;
        }
      }
    }
    return null;
  }

  TimeOfDay? _parseTime(String raw) {
    final trimmed = raw.trim();
    final re24 = RegExp(r'^(\d{1,2}):(\d{2})$');
    final m24 = re24.firstMatch(trimmed);
    if (m24 != null) {
      return TimeOfDay(
        hour: int.parse(m24.group(1)!),
        minute: int.parse(m24.group(2)!),
      );
    }
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

  Duration? _calculateTimeDiff(String timeStr) {
    final lessonTime = _parseTime(timeStr);
    if (lessonTime == null) return null;

    final now = DateTime.now();
    final lessonDateTime = DateTime(
      now.year,
      now.month,
      now.day,
      lessonTime.hour,
      lessonTime.minute,
    );

    return lessonDateTime.difference(now);
  }
}
