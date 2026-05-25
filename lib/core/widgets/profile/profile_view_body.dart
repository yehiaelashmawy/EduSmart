import 'package:flutter/material.dart';
import 'package:school_system/core/utils/app_colors.dart';
import 'package:school_system/core/utils/app_text_style.dart';
import 'package:school_system/features/Auth/presentation/views/auth_view.dart';
import 'package:school_system/features/teacher/presentation/views/personal_information_view.dart';
import 'package:school_system/features/teacher/presentation/views/change_password_view.dart';
import 'package:school_system/features/teacher/presentation/views/settings_view.dart';
import 'package:school_system/core/widgets/profile/profile_logout_button.dart';
import 'package:school_system/core/widgets/profile/profile_menu_tile.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:school_system/core/widgets/profile/profile_avatar.dart';
import 'package:school_system/core/helper/shared_prefs_helper.dart';
import 'package:school_system/core/helper/localization_helper.dart';

import 'package:school_system/features/teacher/presentation/manager/profile_cubit/profile_cubit.dart';
import 'package:school_system/features/teacher/presentation/manager/profile_cubit/profile_state.dart';
import 'package:school_system/features/teacher/data/repos/profile_repo.dart';

class ProfileViewBody extends StatelessWidget {
  const ProfileViewBody({
    super.key,
    required this.name,
    required this.roleTitle,
  });

  final String name;
  final String roleTitle;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        children: [
          // Header
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 20.0),
            child: Center(
              child: Text(
                'profile'.tr(),
                style: AppTextStyle.bold16.copyWith(
                  color: AppColors.darkBlue,
                  fontSize: 18,
                ),
              ),
            ),
          ),

          Expanded(
            child: BlocProvider(
              create: (context) => ProfileCubit(ProfileRepo())..fetchProfile(),
              child: Builder(
                builder: (context) {
                  return SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24.0,
                      vertical: 12.0,
                    ),
                    child: Column(
                      children: [
                        BlocBuilder<ProfileCubit, ProfileState>(
                          builder: (context, state) {
                            String displayAvatarName = name;
                            String displayAvatarTitle = roleTitle;
                            String? avatarUrl;

                            if (state is ProfileLoading) {
                              displayAvatarName = 'loading'.tr();
                              displayAvatarTitle = 'loading'.tr();
                            } else if (state is ProfileSuccess) {
                              displayAvatarName = state.profile.fullName ?? name;
                              displayAvatarTitle =
                                  state.profile.position ?? roleTitle;
                              avatarUrl = state.profile.avatar;
                            }

                            return ProfileAvatar(
                              name: displayAvatarName,
                              title: displayAvatarTitle,
                              networkImageUrl: avatarUrl,
                              onEditTap: () {
                                Navigator.pushNamed(
                                  context,
                                  PersonalInformationView.routeName,
                                ).then((_) {
                                  if (!context.mounted) return;
                                  context.read<ProfileCubit>().fetchProfile();
                                });
                              },
                            );
                          },
                        ),

                        const SizedBox(height: 40),

                        ProfileMenuTile(
                          title: 'personal_information'.tr(),
                          icon: Icons.person_outline,
                          onTap: () {
                            Navigator.pushNamed(
                              context,
                              PersonalInformationView.routeName,
                            ).then((_) {
                              if (!context.mounted) return;
                              context.read<ProfileCubit>().fetchProfile();
                            });
                          },
                        ),
                        const SizedBox(height: 16),
                        ProfileMenuTile(
                          title: 'settings'.tr(),
                          icon: Icons.settings_outlined,
                          onTap: () {
                            Navigator.pushNamed(context, SettingsView.routeName);
                          },
                        ),
                        const SizedBox(height: 16),
                        ProfileMenuTile(
                          title: 'change_password_title'.tr(),
                          icon: Icons.lock_outline,
                          onTap: () {
                            Navigator.pushNamed(
                              context,
                              ChangePasswordView.routeName,
                            );
                          },
                        ),

                        const SizedBox(height: 40),

                        ProfileLogoutButton(
                          onTap: () async {
                            final confirm = await showDialog<bool>(
                              context: context,
                              builder: (dialogContext) {
                                return AlertDialog(
                                  backgroundColor: AppColors.white,
                                  title: Text('logout'.tr(), style: AppTextStyle.bold16.copyWith(color: AppColors.darkBlue)),
                                  content: Text('logout_confirm'.tr(), style: AppTextStyle.regular14),
                                  actions: [
                                    TextButton(
                                      onPressed: () => Navigator.pop(dialogContext, false),
                                      child: Text('no'.tr(), style: AppTextStyle.medium14.copyWith(color: AppColors.grey)),
                                    ),
                                    TextButton(
                                      onPressed: () => Navigator.pop(dialogContext, true),
                                      child: Text('yes'.tr(), style: AppTextStyle.bold14.copyWith(color: Colors.red)),
                                    ),
                                  ],
                                );
                              },
                            );

                            if (confirm == true) {
                              await SharedPrefsHelper.clearAuth();
                              if (!context.mounted) return;
                              Navigator.of(
                                context,
                                rootNavigator: true,
                              ).pushNamedAndRemoveUntil(
                                AuthView.routeName,
                                (route) => false,
                              );
                            }
                          },
                        ),

                        const SizedBox(height: 24),
                      ],
                    ),
                  );
                }
              ),
            ),
          ),
        ],
      ),
    );
  }
}
