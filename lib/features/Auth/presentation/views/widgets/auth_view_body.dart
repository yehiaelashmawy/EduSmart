import 'package:flutter/material.dart';
import 'package:school_system/core/utils/app_colors.dart';
import 'package:school_system/core/utils/app_images.dart';
import 'package:school_system/core/utils/app_text_style.dart';
import 'package:school_system/features/Auth/presentation/views/login_view.dart';
import 'package:school_system/features/Auth/presentation/views/widgets/role_card.dart';

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
                const Text('Choose Your Role', style: AppTextStyle.bold30),
                const SizedBox(height: 8),
                Text(
                  'Select how you want to use the platform today',
                  textAlign: TextAlign.center,
                  style: AppTextStyle.regular16.copyWith(color: AppColors.grey),
                ),
                const SizedBox(height: 61),
                RoleCard(
                  title: 'Teacher',
                  description:
                      'Manage your classes, track student progress, and share learning resources effortlessly with your students.',
                  imagePath: Assets.imagesTeatherAuth,
                  icon: Icons.school,
                  onContinue: () {
                    Navigator.pushNamed(context, LoginView.routeName, arguments: 'teacher');
                  },
                ),
                RoleCard(
                  title: 'Student',
                  description:
                      'Access your assignments, join interactive live classes, and visualize your personal learning journey.',
                  imagePath: Assets.imagesStudentAuth,
                  icon: Icons.laptop_chromebook,
                  onContinue: () {
                    Navigator.pushNamed(context, LoginView.routeName, arguments: 'student');
                  },
                ),
                RoleCard(
                  title: 'Parent',
                  description:
                      'Stay updated with your child\'s academic performance, daily attendance, and school-wide announcements.',
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
                      'Need help? ',
                      style: AppTextStyle.regular16.copyWith(
                        color: Color(0xff64748B),
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
                        'Contact Support',
                        style: AppTextStyle.regular16.copyWith(
                          color: Color(0xff0F52BD),
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
