import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:school_system/core/api/api_service.dart';
import 'package:school_system/core/utils/app_colors.dart';
import 'package:school_system/core/utils/app_text_style.dart';
import 'package:school_system/features/parent/data/models/parent_dashboard_model.dart';
import 'package:school_system/features/parent/data/repos/parent_dashboard_repo.dart';
import 'package:school_system/features/parent/presentation/manager/parent_dashboard_cubit/parent_dashboard_cubit.dart';
import 'package:school_system/features/parent/presentation/manager/parent_dashboard_cubit/parent_dashboard_state.dart';
import 'package:school_system/features/parent/presentation/views/widgets/child_card.dart';
import 'package:school_system/features/parent/presentation/views/widgets/parent_home_header.dart';
import 'package:school_system/features/parent/presentation/views/widgets/quick_action_card.dart';
import 'package:school_system/features/parent/presentation/views/widgets/recent_activity_item.dart';
import 'package:school_system/features/parent/presentation/views/widgets/upcoming_event_card.dart';
import 'package:school_system/features/parent/presentation/views/parent_payments_view.dart';

class ParentHomeViewBody extends StatelessWidget {
  const ParentHomeViewBody({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ParentDashboardCubit(ParentDashboardRepo(ApiService()))..fetchDashboard(),
      child: const _ParentHomeViewBodyContent(),
    );
  }
}

class _ParentHomeViewBodyContent extends StatelessWidget {
  const _ParentHomeViewBodyContent();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      body: SafeArea(
        child: BlocBuilder<ParentDashboardCubit, ParentDashboardState>(
          builder: (context, state) {
            if (state is ParentDashboardLoading) {
              return _buildLoadingState();
            } else if (state is ParentDashboardFailure) {
              return _buildErrorState(state.error.errorMessage);
            } else if (state is ParentDashboardSuccess) {
              return _buildContent(context, state.data);
            }
            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }

  Widget _buildLoadingState() {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const ParentHomeHeader(),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Skeletonizer(
              enabled: true,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 24),
                  Container(
                    width: 200,
                    height: 32,
                    color: Colors.white,
                  ),
                  const SizedBox(height: 16),
                  Container(
                    width: double.infinity,
                    height: 80,
                    color: Colors.white,
                  ),
                  const SizedBox(height: 32),
                  Container(
                    width: 100,
                    height: 24,
                    color: Colors.white,
                  ),
                  const SizedBox(height: 16),
                  Container(
                    width: double.infinity,
                    height: 80,
                    color: Colors.white,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorState(String error) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.error_outline, color: Colors.red, size: 48),
          const SizedBox(height: 16),
          Text(
            error,
            style: AppTextStyle.medium16.copyWith(color: Colors.red),
          ),
        ],
      ),
    );
  }

  Widget _buildContent(BuildContext context, ParentDashboardModel data) {
    return RefreshIndicator(
      onRefresh: () async {},
      child: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const ParentHomeHeader(),
            const SizedBox(height: 8),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Academic Curator',
                    style: AppTextStyle.bold30.copyWith(
                      color: AppColors.secondaryColor,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Monitor your children\'s academic progress',
                    style: AppTextStyle.medium14.copyWith(
                      color: AppColors.grey,
                    ),
                  ),
                  const SizedBox(height: 24),
                  QuickActionCard(
                    title: 'Contact Teacher',
                    icon: Icons.chat_bubble_outline,
                    backgroundColor: AppColors.secondaryColor,
                    contentColor: Colors.white,
                    onTap: () {},
                  ),
                  const SizedBox(height: 12),
                  QuickActionCard(
                    title: 'Payments',
                    icon: Icons.payments_outlined,
                    backgroundColor: Colors.white,
                    contentColor: AppColors.darkBlue,
                    onTap: () {
                      Navigator.pushNamed(context, ParentPaymentsView.routeName);
                    },
                  ),
                  const SizedBox(height: 32),
                  _buildSectionTitle('Children'),
                  const SizedBox(height: 16),
                  ...data.children.map((child) => ChildCard(
                        name: child.name,
                        grade: 'Grade ${child.gradeLevel}',
                        gpa: child.gpa,
                        attendance: child.attendance,
                        subjectsCount: child.subjectsCount,
                      )),
                  const SizedBox(height: 32),
                  _buildSectionTitle('Recent Activity'),
                  const SizedBox(height: 16),
                  if (data.recentActivities.isNotEmpty)
                    ...data.recentActivities.map((activity) => RecentActivityItem.fromActivity(
                          activity: activity.activity,
                          timeAgo: activity.timeAgo,
                          status: activity.status,
                        ))
                  else
                    Text(
                      'No recent activities',
                      style: AppTextStyle.medium14.copyWith(color: AppColors.grey),
                    ),
                  const SizedBox(height: 32),
                  _buildSectionTitle('Upcoming Events'),
                  const SizedBox(height: 16),
                  if (data.upcomingEvents.isNotEmpty)
                    ...data.upcomingEvents.map((event) => UpcomingEventCard.fromEvent(
                          title: event.title,
                          date: event.date,
                          type: event.type,
                        ))
                  else
                    Text(
                      'No upcoming events',
                      style: AppTextStyle.medium14.copyWith(color: AppColors.grey),
                    ),
                  const SizedBox(height: 24),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: AppTextStyle.bold20.copyWith(color: AppColors.darkBlue),
    );
  }
}