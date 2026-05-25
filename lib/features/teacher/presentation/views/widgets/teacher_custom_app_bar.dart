import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:school_system/core/utils/app_colors.dart';
import 'package:school_system/core/utils/app_text_style.dart';
import 'package:school_system/features/teacher/presentation/manager/profile_cubit/profile_cubit.dart';
import 'package:school_system/features/teacher/presentation/manager/profile_cubit/profile_state.dart';

import '../../../../../core/helper/url_helper.dart';

import 'package:school_system/core/helper/localization_helper.dart';

class TeacherCustomAppBar extends StatelessWidget {
  const TeacherCustomAppBar({super.key});

  String _getGreeting() {
    final hour = DateTime.now().hour;
    if (LocalizationHelper.isArabic) {
      if (hour < 12) {
        return 'صباح الخير،';
      } else {
        return 'مساء الخير،';
      }
    } else {
      if (hour < 12) {
        return 'Good Morning,';
      } else if (hour < 17) {
        return 'Good Afternoon,';
      } else {
        return 'Good Evening,';
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      decoration: BoxDecoration(color: AppColors.white),
      child: Row(
        children: [
          BlocBuilder<ProfileCubit, ProfileState>(
            builder: (context, state) {
              String? imageUrl;

              if (state is ProfileSuccess) {
                imageUrl = UrlHelper.getFullImageUrl(state.profile.avatar);
              }

              return CircleAvatar(
                radius: 24,
                backgroundColor: const Color(0xFF8B9272),
                backgroundImage: (imageUrl != null && imageUrl.isNotEmpty)
                    ? NetworkImage(imageUrl)
                    : null,
                child: (imageUrl == null || imageUrl.isEmpty)
                    ? Icon(Icons.person, color: AppColors.white, size: 28)
                    : null,
              );
            },
          ),

          const SizedBox(width: 12),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _getGreeting(),
                  style: AppTextStyle.regular14.copyWith(color: AppColors.grey),
                ),

                BlocBuilder<ProfileCubit, ProfileState>(
                  builder: (context, state) {
                    final teacherName = state is ProfileSuccess
                        ? (state.profile.fullName?.trim().isNotEmpty ?? false)
                              ? state.profile.fullName!.trim()
                              : 'teacher'.tr()
                        : 'teacher'.tr();

                    return Text(
                      teacherName,
                      style: AppTextStyle.bold16,
                      overflow: TextOverflow.ellipsis,
                    );
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
