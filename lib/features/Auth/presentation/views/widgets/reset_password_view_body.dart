import 'package:flutter/material.dart';
import 'package:school_system/core/utils/app_colors.dart';
import 'package:school_system/core/utils/app_text_style.dart';
import 'package:school_system/core/utils/size_config.dart';
import 'package:school_system/core/widgets/custom_app_bar.dart';
import 'package:school_system/core/widgets/custom_button.dart';
import 'package:school_system/core/widgets/custom_snack_bar.dart';
import 'package:school_system/core/widgets/custom_text_field.dart';
import 'package:school_system/features/Auth/presentation/views/scusse_view.dart';
import 'package:school_system/features/Auth/presentation/views/widgets/custom_back_to_login.dart';
import 'package:school_system/features/Auth/presentation/views/widgets/password_requirements_box.dart';
import 'package:svg_flutter/svg.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:school_system/features/Auth/presentation/manager/auth_cubit/auth_cubit.dart';
import 'package:school_system/features/Auth/presentation/manager/auth_cubit/auth_state.dart';
import 'package:skeletonizer/skeletonizer.dart';

class ResetPasswordViewBody extends StatefulWidget {
  final String email;
  final String otpCode;

  const ResetPasswordViewBody({
    super.key,
    required this.email,
    required this.otpCode,
  });

  @override
  State<ResetPasswordViewBody> createState() => _ResetPasswordViewBodyState();
}

class _ResetPasswordViewBodyState extends State<ResetPasswordViewBody> {
  final TextEditingController _newPasswordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();

  bool _hasMinLength = false;
  bool _hasSymbolOrNumber = false;

  @override
  void initState() {
    super.initState();
    _newPasswordController.addListener(_validatePassword);
  }

  void _validatePassword() {
    final password = _newPasswordController.text;
    setState(() {
      _hasMinLength = password.length >= 8;
      _hasSymbolOrNumber = password.contains(RegExp(r'[0-9!@#$%^&*(),.?":{}|<>]'));
    });
  }

  @override
  void dispose() {
    _newPasswordController.removeListener(_validatePassword);
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthCubit, AuthState>(
      listener: (context, state) {
        if (state is ResetPasswordSuccess) {
          CustomSnackBar.showSuccess(context, 'Password reset successfully!');
          Navigator.pushNamed(context, ScusseView.routeName);
        } else if (state is AuthFailure) {
          CustomSnackBar.showError(context, state.errorMessage);
        }
      },
      builder: (context, state) {
        return Scaffold(
          backgroundColor: AppColors.backgroundColor,
          body: Skeletonizer(
            enabled: state is AuthLoading,
            child: SingleChildScrollView(
              child: Column(
                children: [
                  const SizedBox(height: 70),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 17),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 16,
                      ),
                      decoration: ShapeDecoration(
                        color: AppColors.white,
                        shape: RoundedRectangleBorder(
                          side: BorderSide(width: 1, color: AppColors.lightGrey),
                          borderRadius: BorderRadius.circular(32),
                        ),
                      ),
                      child: Column(
                        children: [
                          const CustomAppBar(title: 'Reset Password'),
                          Divider(thickness: 0, color: AppColors.lightGrey),
                          const SizedBox(height: 24),
                          Container(
                            width: 64,
                            height: 64,
                            decoration: ShapeDecoration(
                              color: AppColors.lightGrey,
                              shape: const CircleBorder(),
                            ),
                            child: SvgPicture.asset(
                              'assets/images/reset_password.svg',
                            ),
                          ),
                          const SizedBox(height: 24),
                          Text(
                            'Create New Password',
                            textAlign: TextAlign.center,
                            style: AppTextStyle.bold24.copyWith(
                              fontSize: SizeConfig.getResponsiveFontSize(
                                context,
                                fontSize: 24,
                              ),
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Your new password must be different from previously used passwords to keep your account secure.',
                            textAlign: TextAlign.center,
                            style: AppTextStyle.regular16.copyWith(
                              color: AppColors.grey,
                              fontSize: SizeConfig.getResponsiveFontSize(
                                context,
                                fontSize: 16,
                              ),
                            ),
                          ),
                          const SizedBox(height: 32),
                          Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              'New Password',
                              style: AppTextStyle.semiBold14.copyWith(
                                fontSize: SizeConfig.getResponsiveFontSize(
                                  context,
                                  fontSize: 14,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 8),
                          CustomTextField(
                            hintText: 'Enter new password',
                            obscureText: true,
                            controller: _newPasswordController,
                          ),
                          const SizedBox(height: 24),
                          Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              'Confirm New Password',
                              style: AppTextStyle.semiBold14.copyWith(
                                fontSize: SizeConfig.getResponsiveFontSize(
                                  context,
                                  fontSize: 14,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 8),
                          CustomTextField(
                            hintText: 'Re-enter new password',
                            obscureText: true,
                            controller: _confirmPasswordController,
                          ),
                          const SizedBox(height: 24),
                          PasswordRequirementsBox(
                            requirements: [
                              PasswordRequirementModel(
                                text: 'At least 8 characters long',
                                isValid: _hasMinLength,
                              ),
                              PasswordRequirementModel(
                                text: 'Must include a symbol or number',
                                isValid: _hasSymbolOrNumber,
                              ),
                            ],
                          ),
                          const SizedBox(height: 32),
                          CustomButton(
                            text: 'Reset Password',
                            onPressed: () {
                              final newPassword = _newPasswordController.text;
                              final confirmPassword = _confirmPasswordController.text;

                              if (newPassword.isEmpty || confirmPassword.isEmpty) {
                                CustomSnackBar.showError(context, 'Please fill all fields');
                                return;
                              }

                              if (newPassword != confirmPassword) {
                                CustomSnackBar.showError(context, 'Passwords do not match');
                                return;
                              }

                              context.read<AuthCubit>().resetPassword(
                                email: widget.email,
                                otpCode: widget.otpCode,
                                newPassword: newPassword,
                                confirmPassword: confirmPassword,
                              );
                            },
                          ),
                          const SizedBox(height: 24),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'Remember your password? ',
                                style: AppTextStyle.regular14.copyWith(
                                  color: AppColors.grey,
                                  fontSize: SizeConfig.getResponsiveFontSize(
                                    context,
                                    fontSize: 14,
                                  ),
                                ),
                              ),
                              const CustomBackToLogin(showArrow: false),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
