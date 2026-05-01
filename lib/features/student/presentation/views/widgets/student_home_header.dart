import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:school_system/core/helper/shared_prefs_helper.dart';
import 'package:school_system/core/helper/url_helper.dart';
import 'package:school_system/core/utils/app_colors.dart';
import 'package:school_system/core/utils/app_text_style.dart';
import 'package:school_system/features/teacher/data/repos/profile_repo.dart';
import 'package:school_system/features/teacher/presentation/manager/profile_cubit/profile_cubit.dart';
import 'package:school_system/features/teacher/presentation/manager/profile_cubit/profile_state.dart';

class StudentHomeHeader extends StatelessWidget {
  const StudentHomeHeader({super.key});

  String _getGreeting() {
    final hour = DateTime.now().hour;
    if (hour < 12) {
      return 'Good Morning,';
    } else if (hour < 17) {
      return 'Good Afternoon,';
    } else {
      return 'Good Evening,';
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ProfileCubit(ProfileRepo())..fetchProfile(),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 8),
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
                  backgroundColor: AppColors.primaryColor,
                  backgroundImage: (imageUrl != null && imageUrl.isNotEmpty)
                      ? NetworkImage(imageUrl)
                      : null,
                  child: (imageUrl == null || imageUrl.isEmpty)
                      ? Icon(Icons.person, color: AppColors.white)
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
                    style: AppTextStyle.regular14.copyWith(
                      color: AppColors.grey,
                    ),
                  ),
                  BlocBuilder<ProfileCubit, ProfileState>(
                    builder: (context, state) {
                      final studentName = state is ProfileSuccess
                          ? (state.profile.fullName?.trim().isNotEmpty ?? false)
                                ? state.profile.fullName!.trim()
                                : 'Student'
                          : (SharedPrefsHelper.fullName?.trim().isNotEmpty ??
                                false)
                          ? SharedPrefsHelper.fullName!.trim()
                          : 'Student';

                      return Text(
                        studentName,
                        style: AppTextStyle.bold16.copyWith(
                          color: AppColors.primaryColor,
                        ),
                        overflow: TextOverflow.ellipsis,
                      );
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
