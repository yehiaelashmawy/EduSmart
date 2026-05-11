import 'package:flutter/material.dart';
import 'package:school_system/features/parent/presentation/views/widgets/kid_section_header.dart';
import 'package:school_system/features/parent/presentation/views/widgets/subject_performance_list.dart';
import 'package:school_system/features/parent/presentation/views/widgets/recent_activity_list.dart';
import 'package:school_system/features/parent/presentation/views/widgets/upcoming_events_list.dart';
import 'package:school_system/features/parent/presentation/views/widgets/view_schedule_button.dart';

class KidOverviewTab extends StatelessWidget {
  final String? childId;
  const KidOverviewTab({super.key, this.childId});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: ViewScheduleButton(childId: childId),
        ),
        const SizedBox(height: 32),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const KidSectionHeader(
                icon: Icons.bar_chart_rounded,
                title: 'Performance Overview',
              ),
              const SizedBox(height: 16),
              const SubjectPerformanceList(),
              const SizedBox(height: 32),
              const KidSectionHeader(
                icon: Icons.history_rounded,
                title: 'Recent Activities',
              ),
              const SizedBox(height: 16),
              const RecentActivityList(),
              const SizedBox(height: 32),
              const KidSectionHeader(
                icon: Icons.event_note_rounded,
                title: 'Upcoming Schedule',
              ),
              const SizedBox(height: 16),
              const UpcomingEventsList(),
              const SizedBox(height: 40),
            ],
          ),
        ),
      ],
    );
  }
}
