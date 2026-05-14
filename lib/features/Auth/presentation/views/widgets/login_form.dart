import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:skeletonizer/skeletonizer.dart';

import 'package:school_system/core/utils/app_colors.dart';
import 'package:school_system/core/utils/app_text_style.dart';
import 'package:school_system/core/utils/size_config.dart';
import 'package:school_system/core/widgets/custom_button.dart';
import 'package:school_system/core/widgets/custom_text_field.dart';
import 'package:school_system/features/Auth/presentation/manager/auth_cubit/auth_cubit.dart';
import 'package:school_system/features/Auth/presentation/manager/auth_cubit/auth_state.dart';
import 'package:school_system/features/Auth/presentation/views/auth_view.dart';
import 'package:school_system/features/Auth/presentation/views/widgets/remember_me_and_forgot_password.dart';
import 'package:school_system/features/teacher/presentation/views/teacher_home_view.dart';
import 'package:school_system/features/student/presentation/views/student_home_view.dart';
import 'package:school_system/features/parent/presentation/views/parent_home_view.dart';
import 'package:school_system/core/helper/shared_prefs_helper.dart';

class LoginForm extends StatefulWidget {
  const LoginForm({super.key});

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _rememberMe = false;
  bool _isInitialized = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_isInitialized) {
      final role = ModalRoute.of(context)?.settings.arguments as String?;
      if (role != null) {
        _loadSavedCredentials(role);
      }
      _isInitialized = true;
    }
  }

  void _loadSavedCredentials(String role) {
    _rememberMe = SharedPrefsHelper.getRememberMe(role);
    if (_rememberMe) {
      _emailController.text = SharedPrefsHelper.getSavedEmail(role) ?? '';
      _passwordController.text = SharedPrefsHelper.getSavedPassword(role) ?? '';
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthCubit, AuthState>(
      listener: (context, state) async {
        if (state is AuthFailure) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Row(
                children: [
                  const Icon(Icons.error_outline, color: Colors.white),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      state.errorMessage,
                      style: AppTextStyle.semiBold14.copyWith(
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
              backgroundColor: Colors.redAccent,
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              margin: const EdgeInsets.all(24),
              duration: const Duration(seconds: 3),
            ),
          );
        } else if (state is AuthSuccess) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Row(
                children: [
                  const Icon(Icons.check_circle_outline, color: Colors.white),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      'Welcome ${state.user.fullName}',
                      style: AppTextStyle.semiBold14.copyWith(
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
              backgroundColor: Colors.green,
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              margin: const EdgeInsets.all(24),
              duration: const Duration(seconds: 2),
            ),
          );

          await SharedPrefsHelper.setIsAuthenticated(true);
          await SharedPrefsHelper.setUserRole(state.user.role.toString());
          await SharedPrefsHelper.setToken(state.user.token);
          await SharedPrefsHelper.setFullName(state.user.fullName);
          await SharedPrefsHelper.setUserId(state.user.userId);
          await SharedPrefsHelper.setTeacherOid(
            (state.user.teacherId?.trim().isNotEmpty ?? false)
                ? state.user.teacherId!.trim()
                : state.user.userId,
          );

          // Handle Remember Me
          final roleArg =
              ModalRoute.of(context)?.settings.arguments as String?;
          if (roleArg != null) {
            if (_rememberMe) {
              await SharedPrefsHelper.setRememberMe(roleArg, true);
              await SharedPrefsHelper.setSavedEmail(
                roleArg,
                _emailController.text.trim(),
              );
              await SharedPrefsHelper.setSavedPassword(
                roleArg,
                _passwordController.text.trim(),
              );
            } else {
              await SharedPrefsHelper.clearSavedCredentials(roleArg);
            }
          }

          if (!context.mounted) return;

          if (state.user.role == 3) {
            Navigator.pushReplacementNamed(context, StudentHomeView.routeName);
          } else if (state.user.role == 4) {
            Navigator.pushReplacementNamed(context, ParentHomeView.routeName);
          } else {
            Navigator.pushReplacementNamed(context, TeacherHomeView.routeName);
          }
        }
      },
      builder: (context, state) {
        return Skeletonizer(
          enabled: state is AuthLoading,
          child: Container(
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
                    'Email Address',
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
                    controller: _emailController,
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
                    controller: _passwordController,
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
              RememberMeAndForgotPassword(
                initialValue: _rememberMe,
                onChanged: (value) {
                  _rememberMe = value;
                },
              ),
              const SizedBox(height: 32),
              CustomButton(
                      text: 'Login',
                      shadows: [
                        BoxShadow(
                          color: AppColors.secondaryColor.withValues(
                            alpha: 0.2,
                          ),
                          blurRadius: 6,
                          offset: const Offset(0, 4),
                          spreadRadius: -4,
                        ),
                        BoxShadow(
                          color: AppColors.secondaryColor.withValues(
                            alpha: 0.2,
                          ),
                          blurRadius: 15,
                          offset: const Offset(0, 10),
                          spreadRadius: -3,
                        ),
                      ],
                      onPressed: () {
                        final email = _emailController.text.trim();
                        final password = _passwordController.text.trim();

                        if (email.isEmpty || password.isEmpty) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Row(
                                children: [
                                  const Icon(
                                    Icons.warning_amber_rounded,
                                    color: Colors.white,
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: Text(
                                      'Please perfectly fill all text fields.',
                                      style: AppTextStyle.semiBold14.copyWith(
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              backgroundColor: Colors.orangeAccent.shade700,
                              behavior: SnackBarBehavior.floating,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              margin: const EdgeInsets.all(24),
                              duration: const Duration(seconds: 2),
                            ),
                          );
                          return;
                        }

                        final role =
                            ModalRoute.of(context)?.settings.arguments
                                as String?;
                        if (role != null) {
                          context.read<AuthCubit>().login(
                            email: email,
                            password: password,
                            roleName: role,
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
        ),
      );
    },
    );
  }
}
