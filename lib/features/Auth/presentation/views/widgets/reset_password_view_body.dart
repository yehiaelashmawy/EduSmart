import 'package:flutter/material.dart';
import 'package:school_system/core/utils/app_colors.dart';
import 'package:school_system/core/utils/app_text_style.dart';
import 'package:school_system/core/widgets/custom_app_bar.dart';
import 'package:school_system/core/widgets/custom_button.dart';
import 'package:school_system/core/widgets/custom_text_field.dart';
import 'package:school_system/features/Auth/presentation/views/widgets/custom_back_to_login.dart';

class ResetPasswordViewBody extends StatelessWidget {
  const ResetPasswordViewBody({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FB),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              const CustomAppBar(title: 'Reset Password'),
              const SizedBox(height: 24),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 32,
                  ),
                  decoration: ShapeDecoration(
                    color: Colors.white,
                    shape: RoundedRectangleBorder(
                      side: const BorderSide(
                        width: 1,
                        color: Color(0xFFE2E8F0),
                      ),
                      borderRadius: BorderRadius.circular(32),
                    ),
                  ),
                  child: Column(
                    children: [
                      Container(
                        width: 80,
                        height: 80,
                        decoration: const ShapeDecoration(
                          color: Color(0xFFE0E7FF),
                          shape: CircleBorder(),
                        ),
                        child: const Icon(
                          Icons.restart_alt,
                          size: 40,
                          color: AppColors.primaryColor,
                        ),
                      ),
                      const SizedBox(height: 24),
                      const Text(
                        'Create New Password',
                        textAlign: TextAlign.center,
                        style: AppTextStyle.bold24,
                      ),
                      const SizedBox(height: 12),
                      const Text(
                        'Your new password must be different from previously used passwords to keep your account secure.',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: AppColors.grey,
                          fontSize: 16,
                          height: 1.5,
                        ),
                      ),
                      const SizedBox(height: 32),
                      const Align(
                        alignment: Alignment.centerLeft,
                        child: Text('New Password', style: AppTextStyle.bold14),
                      ),
                      const SizedBox(height: 8),
                      const CustomTextField(
                        hintText: 'Enter new password',
                        obscureText: true,
                      ),
                      const SizedBox(height: 24),
                      const Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          'Confirm New Password',
                          style: AppTextStyle.bold14,
                        ),
                      ),
                      const SizedBox(height: 8),
                      const CustomTextField(
                        hintText: 'Re-enter new password',
                        obscureText: true,
                      ),
                      const SizedBox(height: 24),
                      const PasswordRequirementsBox(),
                      const SizedBox(height: 32),
                      const CustomButton(text: 'Reset Password'),
                      const SizedBox(height: 24),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Remember your password? ',
                            style: AppTextStyle.regular14.copyWith(
                              color: AppColors.grey,
                            ),
                          ),
                          const CustomBackToLogin(),
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
  }
}

class PasswordRequirementsBox extends StatelessWidget {
  const PasswordRequirementsBox({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: ShapeDecoration(
        color: const Color(0xFFF1F5F9),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      ),
      child: const Column(
        children: [
          RequirementItem(text: 'At least 8 characters long', isValid: true),
          SizedBox(height: 12),
          RequirementItem(
            text: 'Must include a symbol or number',
            isValid: false,
          ),
        ],
      ),
    );
  }
}

class RequirementItem extends StatelessWidget {
  const RequirementItem({super.key, required this.text, required this.isValid});

  final String text;
  final bool isValid;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(
          isValid ? Icons.check_circle_outline : Icons.circle_outlined,
          size: 18,
          color: isValid ? const Color(0xFF22C55E) : const Color(0xFFCBD5E1),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            text,
            style: AppTextStyle.medium18.copyWith(
              fontSize: 14,
              color: isValid
                  ? const Color(0xFF475569)
                  : const Color(0xFF94A3B8),
            ),
          ),
        ),
      ],
    );
  }
}
