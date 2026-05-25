import 'package:flutter/material.dart';
import 'package:school_system/core/utils/app_colors.dart';
import 'package:school_system/core/utils/app_text_style.dart';
import 'package:school_system/core/widgets/custom_app_bar.dart';
import 'package:school_system/core/widgets/custom_button.dart';
import 'package:school_system/core/widgets/custom_snack_bar.dart';
import 'package:school_system/core/widgets/custom_text_field.dart';
import 'package:school_system/features/Auth/presentation/views/verification_view.dart';
import 'package:school_system/features/Auth/presentation/views/widgets/custom_back_to_login.dart';
import 'package:school_system/features/Auth/presentation/views/widgets/custom_buttom_logo.dart';
import 'package:svg_flutter/svg.dart';
import 'package:school_system/core/helper/localization_helper.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:school_system/features/Auth/presentation/manager/auth_cubit/auth_cubit.dart';
import 'package:school_system/features/Auth/presentation/manager/auth_cubit/auth_state.dart';
import 'package:skeletonizer/skeletonizer.dart';

class ForgotPasswordViewBody extends StatefulWidget {
  const ForgotPasswordViewBody({super.key});

  @override
  State<ForgotPasswordViewBody> createState() => _ForgotPasswordViewBodyState();
}

class _ForgotPasswordViewBodyState extends State<ForgotPasswordViewBody> {
  final TextEditingController _emailController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthCubit, AuthState>(
      listener: (context, state) {
        if (state is ForgotPasswordSuccess) {
          CustomSnackBar.showSuccess(
            context,
            LocalizationHelper.isArabic
                ? 'تم إرسال رابط إعادة التعيين لبريدك الإلكتروني!'
                : 'Reset link sent to your email!',
          );
          Navigator.pushNamed(
            context,
            VerificationView.routeName,
            arguments: VerificationViewArgs(email: _emailController.text.trim()),
          );
        } else if (state is AuthFailure) {
          CustomSnackBar.showError(context, state.errorMessage);
        }
      },
      builder: (context, state) {
        return Scaffold(
          backgroundColor: AppColors.backgroundColor,
          body: SafeArea(
            child: Skeletonizer(
              enabled: state is AuthLoading,
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    CustomAppBar(title: 'forgot_password_title'.tr()),
                    const SizedBox(height: 24),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 24,
                          vertical: 40,
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
                            SvgPicture.asset('assets/images/reset_password.svg'),
                            const SizedBox(height: 56),
                            Text(
                              'reset_password_title'.tr(),
                              textAlign: TextAlign.center,
                              style: AppTextStyle.bold24,
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'forgot_password_subtitle'.tr(),
                              textAlign: TextAlign.center,
                              style: AppTextStyle.regular16,
                            ),
                            const SizedBox(height: 32),
                            Align(
                              alignment: AlignmentDirectional.centerStart,
                              child: Text(
                                'email'.tr(),
                                style: AppTextStyle.semiBold16,
                              ),
                            ),
                            const SizedBox(height: 8),
                            CustomTextField(
                              hintText: 'name@email.com',
                              controller: _emailController,
                            ),
                            const SizedBox(height: 24),
                            CustomButton(
                              text: 'send_code'.tr(),
                              onPressed: () {
                                final email = _emailController.text.trim();
                                if (email.isNotEmpty) {
                                  context.read<AuthCubit>().forgotPassword(email);
                                } else {
                                  CustomSnackBar.showError(
                                    context,
                                    LocalizationHelper.isArabic
                                        ? 'الرجاء إدخال البريد الإلكتروني'
                                        : 'Please enter your email',
                                  );
                                }
                              },
                            ),
                            const SizedBox(height: 28),
                            const CustomBackToLogin(),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 48),
                    const CustomButtomLogo(),
                    const SizedBox(height: 8),
                    Text(
                      LocalizationHelper.isArabic
                          ? 'منصة تعلم احترافية'
                          : 'Professional Learning Platform',
                      style: AppTextStyle.regular14,
                    ),
                    const SizedBox(height: 24),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
