import 'package:flutter/material.dart';
import 'package:school_system/core/utils/app_colors.dart';
import 'package:school_system/core/utils/app_text_style.dart';
import 'package:school_system/features/Auth/presentation/views/forgot_password_view.dart';

class RememberMeAndForgotPassword extends StatefulWidget {
  const RememberMeAndForgotPassword({super.key});

  @override
  State<RememberMeAndForgotPassword> createState() =>
      _RememberMeAndForgotPasswordState();
}

class _RememberMeAndForgotPasswordState
    extends State<RememberMeAndForgotPassword> {
  bool isChecked = false;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        InkWell(
          onTap: () {
            setState(() {
              isChecked = !isChecked;
            });
          },
          borderRadius: BorderRadius.circular(8),
          child: Row(
            children: [
              Container(
                width: 16,
                height: 16,
                decoration: ShapeDecoration(
                  color: isChecked ? AppColors.primaryColor : Colors.white,
                  shape: RoundedRectangleBorder(
                    side: BorderSide(
                      width: 1,
                      color: isChecked
                          ? AppColors.primaryColor
                          : const Color(0xFFCBD5E1),
                    ),
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
                child: isChecked
                    ? const Icon(Icons.check, color: Colors.white, size: 12)
                    : null,
              ),
              const SizedBox(width: 8),
              Text(
                'Remember me',
                style: AppTextStyle.regular14.copyWith(
                  color: const Color(0xFF475569),
                ),
              ),
            ],
          ),
        ),
        GestureDetector(
          onTap: () {
            Navigator.pushNamed(context, ForgotPasswordView.routeName);
          },
          child: Text(
            'Forgot Password?',
            style: AppTextStyle.semiBold14.copyWith(
              color: const Color(0xFF0F52BD),
            ),
          ),
        ),
      ],
    );
  }
}
