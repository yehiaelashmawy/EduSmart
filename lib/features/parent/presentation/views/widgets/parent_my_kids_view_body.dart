import 'package:flutter/material.dart';
import 'package:school_system/core/utils/app_colors.dart';
import 'package:school_system/core/utils/app_text_style.dart';
import 'package:school_system/features/parent/presentation/views/widgets/child_details_header.dart';
import 'package:school_system/features/parent/presentation/views/widgets/quick_actions_tabs.dart';
import 'package:school_system/features/parent/presentation/views/widgets/recent_activity_list.dart';
import 'package:school_system/features/parent/presentation/views/widgets/subject_performance_list.dart';
import 'package:school_system/features/parent/presentation/views/widgets/upcoming_events_list.dart';
import 'package:school_system/features/parent/presentation/views/widgets/view_schedule_button.dart';

class ParentMyKidsViewBody extends StatefulWidget {
  const ParentMyKidsViewBody({super.key});

  @override
  State<ParentMyKidsViewBody> createState() => _ParentMyKidsViewBodyState();
}

class _ParentMyKidsViewBodyState extends State<ParentMyKidsViewBody> {
  int _selectedTabIndex = 0;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const ChildDetailsHeader(),
          const SizedBox(height: 16),
          QuickActionsTabs(
            currentIndex: _selectedTabIndex,
            onTabChanged: (index) {
              setState(() {
                _selectedTabIndex = index;
              });
            },
          ),
          const SizedBox(height: 24),
          // Content changes based on selection
          _buildTabContent(),
        ],
      ),
    );
  }

  Widget _buildTabContent() {
    // For now, we only have the "Quick Actions" content implemented as seen in the image.
    // If other tabs are selected, we can show different content.
    if (_selectedTabIndex != 0) {
      return Padding(
        padding: const EdgeInsets.all(32),
        child: Center(
          child: Column(
            children: [
              Icon(Icons.construction,
                  size: 64, color: AppColors.grey.withValues(alpha: 0.3)),
              const SizedBox(height: 16),
              Text(
                'Content for this tab is coming soon',
                style: AppTextStyle.medium16.copyWith(color: AppColors.grey),
              ),
            ],
          ),
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const ViewScheduleButton(),
        const SizedBox(height: 24),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildSectionHeader(Icons.bar_chart, 'SUBJECT PERFORMANCE'),
              const SizedBox(height: 16),
              const SubjectPerformanceList(),
              const SizedBox(height: 32),
              _buildSectionHeader(Icons.history, 'Recent Activity'),
              const SizedBox(height: 16),
              const RecentActivityList(),
              const SizedBox(height: 32),
              _buildSectionHeader(Icons.calendar_today, 'Upcoming Events'),
              const SizedBox(height: 16),
              const UpcomingEventsList(),
              const SizedBox(height: 32),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildSectionHeader(IconData icon, String title) {
    return Row(
      children: [
        Icon(icon, color: AppColors.primaryColor, size: 20),
        const SizedBox(width: 8),
        Text(
          title.toUpperCase(),
          style: AppTextStyle.bold14.copyWith(
            color: AppColors.darkBlue,
            letterSpacing: 0.5,
          ),
        ),
      ],
    );
  }
}
