import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:school_system/core/utils/app_colors.dart';
import 'package:school_system/core/utils/app_text_style.dart';
import 'package:school_system/features/parent/presentation/manager/child_weekly_schedule_cubit/child_weekly_schedule_cubit.dart';
import 'package:school_system/features/parent/presentation/manager/child_weekly_schedule_cubit/child_weekly_schedule_state.dart';
import 'package:school_system/features/parent/data/models/parent_weekly_schedule_model.dart';

class ParentWeeklyScheduleViewBody extends StatefulWidget {
  const ParentWeeklyScheduleViewBody({super.key});

  @override
  State<ParentWeeklyScheduleViewBody> createState() =>
      _ParentWeeklyScheduleViewBodyState();
}

class _ParentWeeklyScheduleViewBodyState
    extends State<ParentWeeklyScheduleViewBody> {
  int _selectedDayIndex = 0; // Sunday

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ChildWeeklyScheduleCubit, ChildWeeklyScheduleState>(
      builder: (context, state) {
        if (state is ChildWeeklyScheduleLoading) {
          return const Center(child: CircularProgressIndicator());
        } else if (state is ChildWeeklyScheduleFailure) {
          return Center(child: Text(state.error.errorMessage));
        } else if (state is ChildWeeklyScheduleSuccess) {
          final schedule = state.schedule;
          if (schedule.weeklySchedule.isEmpty) {
            return const Center(child: Text('No schedule available'));
          }

          // Ensure selected index is within bounds
          if (_selectedDayIndex >= schedule.weeklySchedule.length) {
            _selectedDayIndex = 0;
          }

          return SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 24),
                Text(
                  'WEEKLY SCHEDULE',
                  style: AppTextStyle.bold12.copyWith(
                    color: AppColors.grey.withValues(alpha: 0.6),
                    letterSpacing: 1.2,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  schedule.childName,
                  style: AppTextStyle.bold24.copyWith(
                    color: AppColors.darkBlue,
                    fontSize: 20,
                  ),
                ),
                const SizedBox(height: 32),
                _buildDaySelector(schedule.weeklySchedule),
                const SizedBox(height: 32),
                _buildScheduleList(schedule.weeklySchedule[_selectedDayIndex]),
                const SizedBox(height: 32),
              ],
            ),
          );
        }
        return const SizedBox.shrink();
      },
    );
  }

  Widget _buildDaySelector(List<ParentWeeklyScheduleDay> days) {
    return SizedBox(
      height: 80,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        clipBehavior: Clip.none,
        itemCount: days.length,
        separatorBuilder: (context, index) => const SizedBox(width: 10),
        itemBuilder: (context, index) {
          final day = days[index];
          final isSelected = _selectedDayIndex == index;

          return GestureDetector(
            onTap: () => setState(() => _selectedDayIndex = index),
            child: Container(
              width: 75,
              padding: const EdgeInsets.symmetric(vertical: 10),
              decoration: BoxDecoration(
                color: isSelected ? AppColors.primaryColor : Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  if (isSelected)
                    BoxShadow(
                      color: AppColors.primaryColor.withValues(alpha: 0.3),
                      blurRadius: 15,
                      offset: const Offset(0, 8),
                    )
                  else
                    BoxShadow(
                      color: AppColors.black.withValues(alpha: 0.02),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    day.dayName.toUpperCase().substring(0, 3),
                    style: AppTextStyle.bold12.copyWith(
                      color: isSelected ? Colors.white : AppColors.grey,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '${index + 1}', // Placeholder for day number if not available, or just use day name
                    style: AppTextStyle.bold18.copyWith(
                      color: isSelected ? Colors.white : AppColors.darkBlue,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildScheduleList(ParentWeeklyScheduleDay day) {
    if (day.classes.isEmpty) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.only(top: 40),
          child: Text('No classes scheduled for this day'),
        ),
      );
    }
    return Column(
      children: day.classes.map((cls) => _buildClassCard(cls)).toList(),
    );
  }

  Widget _buildClassCard(ParentClassModel cls) {
    final icon = _getIconForSubject(cls.subjectName);
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: AppColors.black.withValues(alpha: 0.02),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppColors.primaryColor.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: AppColors.primaryColor, size: 24),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      cls.subjectName,
                      style: AppTextStyle.bold16.copyWith(
                        color: AppColors.darkBlue,
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.primaryColor.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        cls.startTime,
                        style: AppTextStyle.bold12.copyWith(
                          color: AppColors.primaryColor,
                          fontSize: 10,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  cls.teacherName,
                  style: AppTextStyle.medium14.copyWith(color: AppColors.grey),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Icon(Icons.access_time, size: 14, color: AppColors.grey),
                    const SizedBox(width: 6),
                    Text(
                      '${cls.startTime} - ${cls.endTime}',
                      style: AppTextStyle.regular12.copyWith(
                        color: AppColors.grey,
                      ),
                    ),
                    const Spacer(),
                    Icon(
                      Icons.location_on_outlined,
                      size: 14,
                      color: AppColors.grey,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      cls.roomNumber,
                      style: AppTextStyle.regular12.copyWith(
                        color: AppColors.grey,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  IconData _getIconForSubject(String subjectName) {
    subjectName = subjectName.toLowerCase();
    if (subjectName.contains('math')) return Icons.calculate_outlined;
    if (subjectName.contains('science') ||
        subjectName.contains('chemist') ||
        subjectName.contains('biolog') ||
        subjectName.contains('physic'))
      // ignore: curly_braces_in_flow_control_structures
      return Icons.science_outlined;
    if (subjectName.contains('english') ||
        subjectName.contains('arabic') ||
        subjectName.contains('literat'))
      // ignore: curly_braces_in_flow_control_structures
      return Icons.menu_book_outlined;
    if (subjectName.contains('art')) return Icons.palette_outlined;
    if (subjectName.contains('history')) return Icons.history_edu_outlined;
    return Icons.school_outlined;
  }
}
