import 'package:flutter/material.dart';
import 'package:school_system/core/utils/app_colors.dart';
import 'package:school_system/core/utils/app_text_style.dart';
import 'package:school_system/features/parent/presentation/views/parent_weekly_schedule_view.dart';
import 'package:school_system/features/parent/presentation/views/widgets/recent_activity_item.dart';
import 'package:school_system/features/parent/presentation/views/widgets/upcoming_event_card.dart';

class ChildDetailsViewBody extends StatefulWidget {
  const ChildDetailsViewBody({super.key});

  @override
  State<ChildDetailsViewBody> createState() => _ChildDetailsViewBodyState();
}

class _ChildDetailsViewBodyState extends State<ChildDetailsViewBody> {
  int _selectedTabIndex = 0;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 24),
          _buildTabs(),
          const SizedBox(height: 24),
          GestureDetector(
            onTap: () {
              Navigator.pushNamed(context, ParentWeeklyScheduleView.routeName);
            },
            child: _buildViewScheduleBanner(),
          ),
          const SizedBox(height: 32),
          _buildSectionTitle(Icons.history_outlined, 'Recent Activity'),
          const SizedBox(height: 20),
          _buildRecentActivityList(),
          const SizedBox(height: 32),
          _buildSectionTitle(Icons.calendar_today_outlined, 'Upcoming Events'),
          const SizedBox(height: 20),
          _buildUpcomingEventsList(),
          const SizedBox(height: 32),
        ],
      ),
    );
  }

  Widget _buildTabs() {
    final tabs = ['Quick Actions', 'Attendance', 'Grades', 'Homework'];
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: tabs.asMap().entries.map((entry) {
          final isSelected = _selectedTabIndex == entry.key;
          return GestureDetector(
            onTap: () => setState(() => _selectedTabIndex = entry.key),
            child: Container(
              margin: const EdgeInsets.only(right: 12),
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              decoration: BoxDecoration(
                color: isSelected
                    ? AppColors.primaryColor.withValues(alpha: 0.1)
                    : Colors.transparent,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                entry.value,
                style: AppTextStyle.bold14.copyWith(
                  color: isSelected ? AppColors.primaryColor : AppColors.grey,
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildViewScheduleBanner() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.secondaryColor,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: AppColors.secondaryColor.withValues(alpha: 0.3),
            blurRadius: 15,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(
              Icons.calendar_month_outlined,
              color: Colors.white,
            ),
          ),
          const SizedBox(width: 20),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'View Schedule',
                  style: AppTextStyle.bold16.copyWith(color: Colors.white),
                ),
                const SizedBox(height: 4),
                Text(
                  'Access daily timetable and class locations',
                  style: AppTextStyle.regular12.copyWith(
                    color: Colors.white.withValues(alpha: 0.8),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(IconData icon, String title) {
    return Row(
      children: [
        Icon(icon, color: AppColors.primaryColor, size: 24),
        const SizedBox(width: 12),
        Text(
          title,
          style: AppTextStyle.bold18.copyWith(color: AppColors.darkBlue),
        ),
      ],
    );
  }

  Widget _buildRecentActivityList() {
    return Column(
      children: [
        RecentActivityItem(
          title: 'New Grade Posted',
          description: 'Advanced Mathematics - Mid-term Quiz',
          time: '2h ago',
          icon: Icons.star_outline,
          iconBgColor: AppColors.primaryColor.withValues(alpha: 0.1),
          iconColor: AppColors.primaryColor,
        ),
        RecentActivityItem(
          title: 'Assignment Submitted',
          description: 'English Literature: Modernism Essay',
          time: 'Yesterday',
          icon: Icons.check_circle_outline,
          iconBgColor: AppColors.peach,
          iconColor: Colors.orange,
        ),
        RecentActivityItem(
          title: 'Teacher Note',
          description: 'Mr. Henderson left a comment on Physics lab',
          time: 'Oct 24',
          icon: Icons.chat_bubble_outline,
          iconBgColor: AppColors.lightGrey.withValues(alpha: 0.2),
          iconColor: AppColors.grey,
        ),
      ],
    );
  }

  Widget _buildUpcomingEventsList() {
    return Column(
      children: [
        UpcomingEventCard(
          month: 'OCT',
          day: '28',
          title: 'Parent-Teacher Conference',
          details: '3:30 PM • Room 204 (Block B)',
          dateBgColor: AppColors.primaryColor.withValues(alpha: 0.1),
        ),
        const UpcomingEventCard(
          month: 'NOV',
          day: '02',
          title: 'Regional Science Fair',
          details: 'All Day • Campus Auditorium',
          dateBgColor: Color(0xFFF1F5F9),
        ),
        UpcomingEventCard(
          month: 'NOV',
          day: '05',
          title: 'Physics Project Deadline',
          details: 'Due at 11:59 PM',
          dateBgColor: AppColors.peach,
        ),
      ],
    );
  }
}
