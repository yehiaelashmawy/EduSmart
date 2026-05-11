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
import 'package:school_system/features/parent/presentation/views/widgets/recent_activity_item.dart';
import 'package:school_system/features/parent/presentation/views/widgets/upcoming_event_card.dart';
import 'package:school_system/features/parent/presentation/views/parent_payments_view.dart';

class ParentHomeViewBody extends StatelessWidget {
  final VoidCallback? onViewAll;
  const ParentHomeViewBody({super.key, this.onViewAll});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          ParentDashboardCubit(ParentDashboardRepo(ApiService()))
            ..fetchDashboard(),
      child: _ParentHomeViewBodyContent(onViewAll: onViewAll),
    );
  }
}

class _ParentHomeViewBodyContent extends StatelessWidget {
  final VoidCallback? onViewAll;
  const _ParentHomeViewBodyContent({this.onViewAll});

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
                  Container(width: 200, height: 32, color: Colors.white),
                  const SizedBox(height: 16),
                  Container(
                    width: double.infinity,
                    height: 80,
                    color: Colors.white,
                  ),
                  const SizedBox(height: 32),
                  Container(width: 100, height: 24, color: Colors.white),
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
          Text(error, style: AppTextStyle.medium16.copyWith(color: Colors.red)),
        ],
      ),
    );
  }

  Widget _buildContent(BuildContext context, ParentDashboardModel data) {
    return RefreshIndicator(
      onRefresh: () async {
        await context.read<ParentDashboardCubit>().fetchDashboard();
      },
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
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Academic Curator',
                            style: AppTextStyle.bold30.copyWith(
                              color: AppColors.secondaryColor,
                              height: 1.1,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Your family academic overview',
                            style: AppTextStyle.medium14.copyWith(
                              color: AppColors.grey,
                            ),
                          ),
                        ],
                      ),
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: AppColors.primaryColor.withValues(alpha: 0.08),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          Icons.auto_graph_rounded,
                          color: AppColors.primaryColor,
                          size: 24,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  _ActionGridItem(
                    title: 'Fee Payments',
                    icon: Icons.payments_outlined,
                    color: const Color(0xff12B76A),
                    onTap: () {
                      Navigator.pushNamed(
                        context,
                        ParentPaymentsView.routeName,
                      );
                    },
                  ),
                  const SizedBox(height: 32),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _buildSectionTitle('My Children'),
                      TextButton(
                        onPressed: onViewAll,
                        child: Text(
                          'View All',
                          style: AppTextStyle.bold14.copyWith(
                            color: AppColors.primaryColor,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  ...data.children
                      .take(2)
                      .map(
                        (child) => ChildCard(
                          name: child.name,
                          grade: 'Grade ${child.gradeLevel}',
                          gpa: child.gpa,
                          attendance: child.attendance,
                          subjectsCount: child.subjectsCount,
                          onTap: null,
                        ),
                      ),
                  const SizedBox(height: 32),
                  _buildSectionTitle('Recent Updates'),
                  const SizedBox(height: 16),
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: AppColors.lightGrey.withValues(alpha: 0.3),
                      ),
                    ),
                    child: Column(
                      children: [
                        if (data.recentActivities.isNotEmpty)
                          ...data.recentActivities
                              .take(3)
                              .map(
                                (activity) => RecentActivityItem.fromActivity(
                                  activity: activity.activity,
                                  timeAgo: activity.timeAgo,
                                  status: activity.status,
                                ),
                              )
                        else
                          Padding(
                            padding: const EdgeInsets.all(24.0),
                            child: Text(
                              'No recent activities',
                              style: AppTextStyle.medium14.copyWith(
                                color: AppColors.grey,
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 32),
                  _buildSectionTitle('Upcoming Events'),
                  const SizedBox(height: 16),
                  if (data.upcomingEvents.isNotEmpty)
                    ...data.upcomingEvents.map(
                      (event) => UpcomingEventCard.fromEvent(
                        title: event.title,
                        date: event.date,
                        type: event.type,
                      ),
                    )
                  else
                    Text(
                      'No upcoming events',
                      style: AppTextStyle.medium14.copyWith(
                        color: AppColors.grey,
                      ),
                    ),
                  const SizedBox(height: 40),
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

class _ActionGridItem extends StatelessWidget {
  final String title;
  final IconData icon;
  final Color color;
  final VoidCallback onTap;

  const _ActionGridItem({
    required this.title,
    required this.icon,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: AppColors.lightGrey.withValues(alpha: 0.3)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.02),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: color, size: 24),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  title,
                  style: AppTextStyle.bold14.copyWith(
                    color: AppColors.darkBlue,
                    height: 1.2,
                  ),
                ),
                Icon(
                  Icons.arrow_forward_ios_rounded,
                  color: AppColors.grey.withValues(alpha: 0.5),
                  size: 14,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
