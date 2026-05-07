import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:school_system/core/utils/app_colors.dart';
import 'package:school_system/core/utils/app_text_style.dart';
import 'package:school_system/features/student/presentation/manager/student_weekly_schedule_cubit/student_weekly_schedule_cubit.dart';
import 'package:school_system/features/student/presentation/manager/student_weekly_schedule_cubit/student_weekly_schedule_state.dart';

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
    return BlocBuilder<StudentWeeklyScheduleCubit, StudentWeeklyScheduleState>(
      builder: (context, state) {
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
                'Oct 22 - Oct 27',
                style: AppTextStyle.bold24.copyWith(
                  color: AppColors.darkBlue,
                  fontSize: 20,
                ),
              ),
              const SizedBox(height: 32),
              _buildDaySelector(),
              const SizedBox(height: 32),
              _buildScheduleList(),
              const SizedBox(height: 32),
            ],
          ),
        );
      },
    );
  }

  Widget _buildDaySelector() {
    final days = [
      {'name': 'SUN', 'day': '22'},
      {'name': 'MON', 'day': '23'},
      {'name': 'TUE', 'day': '24'},
      {'name': 'WED', 'day': '25'},
      {'name': 'THU', 'day': '26'},
    ];

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
                    day['name']!,
                    style: AppTextStyle.bold12.copyWith(
                      color: isSelected ? Colors.white : AppColors.grey,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    day['day']!,
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

  Widget _buildScheduleList() {
    return Column(
      children: [
        _buildClassCard(
          title: 'Advanced Mathematics',
          teacher: 'Dr. Eleanor Vance',
          time: '08:30 AM',
          range: '08:30 AM - 09:30 AM',
          icon: Icons.calculate_outlined,
        ),
        _buildBreakCard(
          title: 'MORNING BREAK',
          duration: '15 MIN',
          icon: Icons.coffee_outlined,
          bgColor: AppColors.primaryColor.withValues(alpha: 0.05),
          iconColor: Colors.brown,
        ),
        _buildClassCard(
          title: 'Physics Laboratory',
          teacher: 'Prof. Marcus Thorne',
          time: '09:45 AM',
          range: '09:45 AM - 11:15 AM',
          icon: Icons.science_outlined,
        ),
        _buildClassCard(
          title: 'English Literature',
          teacher: 'Ms. Sarah Jenkins',
          time: '11:30 AM',
          range: '11:30 AM - 12:30 PM',
          icon: Icons.menu_book_outlined,
        ),
        _buildBreakCard(
          title: 'LUNCH PERIOD',
          duration: '45 MIN',
          icon: Icons.restaurant_outlined,
          bgColor: Colors.orange.withValues(alpha: 0.1),
          iconColor: Colors.orange,
        ),
        _buildClassCard(
          title: 'Visual Arts',
          teacher: 'Mr. Julian Grey',
          time: '01:15 PM',
          range: '01:15 PM - 02:45 PM',
          icon: Icons.palette_outlined,
        ),
      ],
    );
  }

  Widget _buildClassCard({
    required String title,
    required String teacher,
    required String time,
    required String range,
    required IconData icon,
  }) {
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
                      title,
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
                        time,
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
                  teacher,
                  style: AppTextStyle.medium14.copyWith(color: AppColors.grey),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Icon(Icons.access_time, size: 14, color: AppColors.grey),
                    const SizedBox(width: 6),
                    Text(
                      range,
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

  Widget _buildBreakCard({
    required String title,
    required String duration,
    required IconData icon,
    required Color bgColor,
    required Color iconColor,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Icon(icon, size: 20, color: iconColor),
          const SizedBox(width: 16),
          Text(
            title,
            style: AppTextStyle.bold12.copyWith(
              color: iconColor,
              letterSpacing: 0.5,
            ),
          ),
          const Spacer(),
          Text(
            duration,
            style: AppTextStyle.bold12.copyWith(color: iconColor, fontSize: 10),
          ),
        ],
      ),
    );
  }
}
