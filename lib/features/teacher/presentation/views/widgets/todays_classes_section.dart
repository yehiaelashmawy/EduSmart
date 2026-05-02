import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:school_system/core/utils/app_colors.dart';
import 'package:school_system/core/utils/app_text_style.dart';
import 'package:school_system/features/teacher/data/models/teacher_timetable_entry_model.dart';
import 'package:school_system/features/teacher/presentation/manager/teacher_timetable_cubit/teacher_timetable_cubit.dart';
import 'package:school_system/features/teacher/presentation/manager/teacher_timetable_cubit/teacher_timetable_state.dart';
import 'package:school_system/features/teacher/presentation/views/teacher_weekly_schedule_view.dart';

class TodaysClassesSection extends StatelessWidget {
  const TodaysClassesSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Text('Today\'s Classes', style: AppTextStyle.bold20),
            TextButton(
              onPressed: () {
                Navigator.pushNamed(
                  context,
                  TeacherWeeklyScheduleView.routeName,
                );
              },
              style: TextButton.styleFrom(
                padding: EdgeInsets.zero,
                minimumSize: Size.zero,
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              ),
              child: Text(
                'View Schedule',
                style: AppTextStyle.semiBold14.copyWith(
                  color: AppColors.primaryColor,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        BlocBuilder<TeacherTimetableCubit, TeacherTimetableState>(
          builder: (context, state) {
            if (state is TeacherTimetableLoading) {
              final skeletonClasses = List.generate(
                3,
                (_) => TeacherTimetableEntryModel(
                  time: '08:00 AM - 09:00 AM',
                  subjectName: 'Mathematics',
                  teacherName: 'Teacher Name',
                  room: 'Room 101',
                  className: 'Grade 10 - A',
                  classOid: '',
                  subjectOid: '',
                  day: 'Monday',
                  startTime: '08:00',
                  endTime: '09:00',
                  period: 1,
                ),
              );
              return SizedBox(
                height: 160,
                child: Skeletonizer(
                  enabled: true,
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    clipBehavior: Clip.none,
                    itemCount: skeletonClasses.length,
                    separatorBuilder: (_, _) => const SizedBox(width: 16),
                    itemBuilder: (context, index) {
                      return _buildClassCard(skeletonClasses[index]);
                    },
                  ),
                ),
              );
            }

            if (state is TeacherTimetableFailure) {
              return SizedBox(
                height: 160,
                child: Center(
                  child: Text(
                    state.error.errorMessage,
                    textAlign: TextAlign.center,
                    style: AppTextStyle.regular14.copyWith(
                      color: AppColors.grey,
                    ),
                  ),
                ),
              );
            }

            if (state is TeacherTimetableSuccess) {
              if (state.classes.isEmpty) {
                return SizedBox(
                  height: 160,
                  child: Center(
                    child: Text(
                      'No classes scheduled for today.',
                      style: AppTextStyle.regular14.copyWith(
                        color: AppColors.grey,
                      ),
                    ),
                  ),
                );
              }

              return SizedBox(
                height: 160,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  clipBehavior: Clip.none,
                  itemCount: state.classes.length,
                  separatorBuilder: (_, _) => const SizedBox(width: 16),
                  itemBuilder: (context, index) {
                    final item = state.classes[index];
                    return _buildClassCard(item);
                  },
                ),
              );
            }

            return const SizedBox.shrink();
          },
        ),
      ],
    );
  }

  Widget _buildClassCard(TeacherTimetableEntryModel classItem) {
    return Container(
      width: 260,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: AppColors.black.withValues(alpha: 0.04),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: const Color(0xFFF0F5FF),
                  shape: BoxShape.circle,
                ),
                child: Text(
                  classItem.subjectName[0],
                  style: AppTextStyle.bold20.copyWith(
                    color: AppColors.primaryColor,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(classItem.subjectName, style: AppTextStyle.bold16),
                  const SizedBox(height: 2),
                  Text(
                    classItem.className,
                    style: AppTextStyle.regular14.copyWith(
                      color: AppColors.grey,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              Icon(Icons.access_time, size: 18, color: AppColors.grey),
              const SizedBox(width: 8),
              Text(
                classItem.time,
                style: AppTextStyle.regular14.copyWith(color: AppColors.grey),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Icon(Icons.location_on_outlined, size: 18, color: AppColors.grey),
              const SizedBox(width: 8),
              Text(
                classItem.room,
                style: AppTextStyle.regular14.copyWith(color: AppColors.grey),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
