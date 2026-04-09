import 'package:flutter/material.dart';
import 'package:school_system/core/utils/app_colors.dart';
import 'package:school_system/core/utils/app_text_style.dart';
import 'package:school_system/core/utils/size_config.dart';
import 'package:school_system/core/widgets/custom_button.dart';
import 'package:school_system/core/widgets/custom_text_field.dart';
import 'package:school_system/features/Auth/presentation/views/auth_view.dart';
import 'package:school_system/features/Auth/presentation/views/widgets/remember_me_and_forgot_password.dart';
import 'package:school_system/features/teacher/presentation/views/teacher_home_view.dart';
import 'package:school_system/features/student/presentation/views/student_home_view.dart';
import 'package:school_system/features/parent/presentation/views/parent_home_view.dart';
import 'package:school_system/core/helper/shared_prefs_helper.dart';

class LoginForm extends StatelessWidget {
  const LoginForm({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(32),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Text(
                  'Welcome ',
                  style: AppTextStyle.bold24.copyWith(
                    color: AppColors.darkBlue,
                    fontSize: SizeConfig.getResponsiveFontSize(
                      context,
                      fontSize: 24,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 4),
              Center(
                child: Text(
                  'Log in to continue your learning journey',
                  textAlign: TextAlign.center,
                  style: AppTextStyle.regular14.copyWith(
                    color: AppColors.grey,
                    fontSize: SizeConfig.getResponsiveFontSize(
                      context,
                      fontSize: 14,
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 32),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Email / Phone',
                style: AppTextStyle.semiBold14.copyWith(
                  color: AppColors.darkBlue,
                  fontSize: SizeConfig.getResponsiveFontSize(
                    context,
                    fontSize: 14,
                  ),
                ),
              ),
              const SizedBox(height: 8),
              CustomTextField(
                hintText: 'student@edusmart.edu',
                prefixIcon: Icon(
                  Icons.mail_outline,
                  color: AppColors.lightGrey,
                  size: 20,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Password',
                style: AppTextStyle.semiBold14.copyWith(
                  color: AppColors.darkBlue,
                  fontSize: SizeConfig.getResponsiveFontSize(
                    context,
                    fontSize: 14,
                  ),
                ),
              ),
              const SizedBox(height: 8),
              CustomTextField(
                hintText: '******************',
                prefixIcon: Icon(
                  Icons.lock_outline,
                  color: AppColors.lightGrey,
                  size: 20,
                ),
                obscureText: true,
              ),
              const SizedBox(height: 4),
            ],
          ),
          const SizedBox(height: 16),
          const RememberMeAndForgotPassword(),
          const SizedBox(height: 32),
          CustomButton(
            text: 'Login',
            shadows: [
              BoxShadow(
                color: AppColors.secondaryColor.withValues(alpha: 0.2),
                blurRadius: 6,
                offset: Offset(0, 4),
                spreadRadius: -4,
              ),
              BoxShadow(
                color: AppColors.secondaryColor.withValues(alpha: 0.2),
                blurRadius: 15,
                offset: Offset(0, 10),
                spreadRadius: -3,
              ),
            ],
            onPressed: () async {
              final role =
                  ModalRoute.of(context)?.settings.arguments as String?;

              await SharedPrefsHelper.setIsAuthenticated(true);
              if (role != null) {
                await SharedPrefsHelper.setUserRole(role);
              }

              if (!context.mounted) return;

              if (role == 'student') {
                Navigator.pushReplacementNamed(
                  context,
                  StudentHomeView.routeName,
                );
              } else if (role == 'parent') {
                Navigator.pushReplacementNamed(
                  context,
                  ParentHomeView.routeName,
                );
              } else {
                Navigator.pushReplacementNamed(
                  context,
                  TeacherHomeView.routeName,
                );
              }
            },
          ),
          const SizedBox(height: 16),
          Divider(color: AppColors.lightGrey),
          const SizedBox(height: 16),
          CustomButton(
            text: 'Back To Role',
            backgroundColor: AppColors.white,
            textColor: AppColors.darkBlue,
            borderColor: AppColors.lightGrey,
            onPressed: () {
              Navigator.pushNamed(context, AuthView.routeName);
            },
          ),
        ],
      ),
    );
  }
}
