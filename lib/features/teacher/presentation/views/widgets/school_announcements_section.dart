import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:school_system/core/utils/app_colors.dart';
import 'package:school_system/core/utils/app_text_style.dart';
import 'package:school_system/features/teacher/presentation/manager/announcements_cubit/announcements_cubit.dart';
import 'package:school_system/features/teacher/presentation/manager/announcements_cubit/announcements_state.dart';

class SchoolAnnouncementsSection extends StatelessWidget {
  const SchoolAnnouncementsSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.primaryColor.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.campaign_outlined,
                color: AppColors.primaryColor,
                size: 24,
              ),
              const SizedBox(width: 12),
              Text('School Announcements', style: AppTextStyle.bold18),
            ],
          ),
          const SizedBox(height: 20),
          BlocBuilder<AnnouncementsCubit, AnnouncementsState>(
            builder: (context, state) {
              if (state is AnnouncementsLoading) {
                return Skeletonizer(
                  enabled: true,
                  child: Column(
                    children: List.generate(
                      3,
                      (i) => Padding(
                        padding: EdgeInsets.only(bottom: i == 2 ? 0 : 16),
                        child: _buildAnnouncementItem(
                          title: 'School Event Announcement',
                          subtitle:
                              'Important update about upcoming school activity and schedule changes.',
                          timeAgo: '2h ago',
                        ),
                      ),
                    ),
                  ),
                );
              } else if (state is AnnouncementsFailure) {
                return Text(
                  state.error.errorMessage,
                  style: const TextStyle(color: Colors.red, fontSize: 13),
                );
              } else if (state is AnnouncementsSuccess) {
                if (state.announcements.isEmpty) {
                  return Text(
                    'No announcements at this time.',
                    style: AppTextStyle.regular14.copyWith(
                      color: AppColors.grey,
                    ),
                  );
                }
                return Column(
                  children: state.announcements.asMap().entries.map((entry) {
                    final i = entry.key;
                    final announcement = entry.value;
                    return Column(
                      children: [
                        if (i > 0) const SizedBox(height: 16),
                        _buildAnnouncementItem(
                          title: announcement.title,
                          subtitle: announcement.contentEn,
                          timeAgo: announcement.timeAgo,
                        ),
                      ],
                    );
                  }).toList(),
                );
              }
              return const SizedBox.shrink();
            },
          ),
        ],
      ),
    );
  }

  Widget _buildAnnouncementItem({
    required String title,
    required String subtitle,
    String? timeAgo,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          margin: const EdgeInsets.only(top: 6),
          width: 8,
          height: 8,
          decoration: BoxDecoration(
            color: AppColors.primaryColor,
            shape: BoxShape.circle,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: AppTextStyle.semiBold14.copyWith(
                  color: AppColors.darkBlue,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                subtitle,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: AppTextStyle.regular14.copyWith(color: AppColors.grey),
              ),
              if (timeAgo != null && timeAgo.isNotEmpty) ...[
                const SizedBox(height: 4),
                Text(
                  timeAgo,
                  style: TextStyle(
                    fontSize: 11,
                    color: AppColors.grey.withValues(alpha: 0.7),
                  ),
                ),
              ],
            ],
          ),
        ),
      ],
    );
  }
}
