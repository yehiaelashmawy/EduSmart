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
                  color: const Color(0xFF334155),
                  fontSize: SizeConfig.getResponsiveFontSize(
                    context,
                    fontSize: 14,
                  ),
                ),
              ),
              const SizedBox(height: 8),
              const CustomTextField(
                hintText: 'student@edusmart.edu',
                prefixIcon: Icon(
                  Icons.mail_outline,
                  color: Color(0xFF94A3B8),
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
                  color: const Color(0xFF334155),
                  fontSize: SizeConfig.getResponsiveFontSize(
                    context,
                    fontSize: 14,
                  ),
                ),
              ),
              const SizedBox(height: 8),
              const CustomTextField(
                hintText: '******************',
                prefixIcon: Icon(
                  Icons.lock_outline,
                  color: Color(0xFF94A3B8),
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
            shadows: const [
              BoxShadow(
                color: Color(0x330F52BD),
                blurRadius: 6,
                offset: Offset(0, 4),
                spreadRadius: -4,
              ),
              BoxShadow(
                color: Color(0x330F52BD),
                blurRadius: 15,
                offset: Offset(0, 10),
                spreadRadius: -3,
              ),
            ],
            onPressed: () {
              final role = ModalRoute.of(context)?.settings.arguments as String?;
              if (role == 'student') {
                Navigator.pushNamed(context, StudentHomeView.routeName);
              } else if (role == 'parent') {
                Navigator.pushNamed(context, ParentHomeView.routeName);
              } else {
                Navigator.pushNamed(context, TeacherHomeView.routeName);
              }
            },
          ),
          const SizedBox(height: 16),
          const Divider(color: Color(0xFFE2E8F0)),
          const SizedBox(height: 16),
          CustomButton(
            text: 'Back To Role',
            backgroundColor: Colors.white,
            textColor: const Color(0xFF334155),
            borderColor: const Color(0xFFE2E8F0),
            onPressed: () {
              Navigator.pushNamed(context, AuthView.routeName);
            },
          ),
        ],
      ),
    );
  }
}
