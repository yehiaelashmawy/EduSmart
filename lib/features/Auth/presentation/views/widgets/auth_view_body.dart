import 'package:flutter/material.dart';
import 'package:school_system/core/utils/app_colors.dart';
import 'package:school_system/core/utils/app_images.dart';
import 'package:school_system/core/utils/app_text_style.dart';
import 'package:school_system/features/Auth/presentation/views/login_view.dart';
import 'package:school_system/features/Auth/presentation/views/widgets/role_card.dart';
import 'package:school_system/core/helper/localization_helper.dart';

class AuthViewBody extends StatelessWidget {
  const AuthViewBody({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 52, bottom: 16),
          child: Text(
            'EduSmart',
            textAlign: TextAlign.center,
            style: AppTextStyle.bold18,
          ),
        ),
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 31),
                Text('select_role'.tr(), style: AppTextStyle.bold30, textAlign: TextAlign.center),
                const SizedBox(height: 8),
                Text(
                  'select_role_desc'.tr(),
                  textAlign: TextAlign.center,
                  style: AppTextStyle.regular16.copyWith(color: AppColors.grey),
                ),
                const SizedBox(height: 61),
                RoleCard(
                  title: 'teacher'.tr(),
                  description: 'teacher_desc'.tr(),
                  imagePath: Assets.imagesTeatherAuth,
                  icon: Icons.school,
                  onContinue: () {
                    Navigator.pushNamed(context, LoginView.routeName, arguments: 'teacher');
                  },
                ),
                RoleCard(
                  title: 'student'.tr(),
                  description: 'student_desc'.tr(),
                  imagePath: Assets.imagesStudentAuth,
                  icon: Icons.laptop_chromebook,
                  onContinue: () {
                    Navigator.pushNamed(context, LoginView.routeName, arguments: 'student');
                  },
                ),
                RoleCard(
                  title: 'parent'.tr(),
                  description: 'parent_desc'.tr(),
                  imagePath: Assets.imagesParentAuth,
                  icon: Icons.people,
                  onContinue: () {
                    Navigator.pushNamed(context, LoginView.routeName, arguments: 'parent');
                  },
                ),
                const SizedBox(height: 24),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'need_help'.tr(),
                      style: AppTextStyle.regular16.copyWith(
                        color: AppColors.grey,
                      ),
                    ),
                    TextButton(
                      onPressed: () {},
                      style: TextButton.styleFrom(
                        padding: EdgeInsets.zero,
                        minimumSize: Size.zero,
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      ),
                      child: Text(
                        'contact_support'.tr(),
                        style: AppTextStyle.regular16.copyWith(
                          color: AppColors.secondaryColor,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
