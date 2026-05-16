import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:school_system/features/parent/presentation/manager/children_dashboard_cubit/children_dashboard_cubit.dart';
import 'package:school_system/features/parent/presentation/views/widgets/kid_section_header.dart';
import 'package:school_system/features/parent/presentation/views/widgets/subject_performance_list.dart';
import 'package:school_system/features/parent/presentation/views/widgets/recent_activity_list.dart';
import 'package:school_system/features/parent/presentation/views/widgets/upcoming_events_list.dart';
import 'package:school_system/features/parent/presentation/views/widgets/view_schedule_button.dart';
import 'package:skeletonizer/skeletonizer.dart';

class KidOverviewTab extends StatelessWidget {
  final String? childId;
  const KidOverviewTab({super.key, this.childId});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ChildrenDashboardCubit, ChildrenDashboardState>(
      builder: (context, state) {
        if (state is ChildrenDashboardLoading) {
          return const Skeletonizer(
            enabled: true,
            child: _KidOverviewContent(childId: null),
          );
        } else if (state is ChildrenDashboardSuccess) {
          final childData = state.data.children.firstWhere(
            (c) => c.studentOid == childId,
            orElse: () => state.data.children.first,
          );
          return _KidOverviewContent(childId: childId, data: childData);
        } else if (state is ChildrenDashboardFailure) {
          return Center(child: Text(state.error.errorMessage));
        }
        return const SizedBox.shrink();
      },
    );
  }
}

class _KidOverviewContent extends StatelessWidget {
  final String? childId;
  final dynamic data;

  const _KidOverviewContent({this.childId, this.data});

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
              SubjectPerformanceList(
                subjects: data?.subjectPerformance.subjects,
              ),
              const SizedBox(height: 32),
              const KidSectionHeader(
                icon: Icons.history_rounded,
                title: 'Recent Activities',
              ),
              const SizedBox(height: 16),
              RecentActivityList(activities: data?.recentActivities),
              const SizedBox(height: 32),
              const KidSectionHeader(
                icon: Icons.event_note_rounded,
                title: 'Upcoming Schedule',
              ),
              const SizedBox(height: 16),
              UpcomingEventsList(events: data?.upcomingEvents),
              const SizedBox(height: 40),
            ],
          ),
        ),
      ],
    );
  }
}
