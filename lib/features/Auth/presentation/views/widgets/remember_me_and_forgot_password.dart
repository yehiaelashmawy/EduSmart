import 'package:flutter/material.dart';
import 'package:school_system/core/utils/app_colors.dart';
import 'package:school_system/core/utils/app_text_style.dart';
import 'package:school_system/features/Auth/presentation/views/forgot_password_view.dart';

class RememberMeAndForgotPassword extends StatefulWidget {
  const RememberMeAndForgotPassword({
    super.key,
    required this.onChanged,
    this.initialValue = false,
  });

  final ValueChanged<bool> onChanged;
  final bool initialValue;

  @override
  State<RememberMeAndForgotPassword> createState() =>
      _RememberMeAndForgotPasswordState();
}

class _RememberMeAndForgotPasswordState
    extends State<RememberMeAndForgotPassword> {
  late bool isChecked;

  @override
  void initState() {
    super.initState();
    isChecked = widget.initialValue;
  }

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
            widget.onChanged(isChecked);
          },
          borderRadius: BorderRadius.circular(8),
          child: Row(
            children: [
              Container(
                width: 16,
                height: 16,
                decoration: ShapeDecoration(
                  color: isChecked ? AppColors.primaryColor : AppColors.white,
                  shape: RoundedRectangleBorder(
                    side: BorderSide(
                      width: 1,
                      color: isChecked
                          ? AppColors.primaryColor
                          : AppColors.lightGrey,
                    ),
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
                child: isChecked
                    ? Icon(Icons.check, color: AppColors.white, size: 12)
                    : null,
              ),
              const SizedBox(width: 8),
              Text(
                'Remember me',
                style: AppTextStyle.regular14.copyWith(
                  color: AppColors.grey,
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
              color: AppColors.secondaryColor,
            ),
          ),
        ),
      ],
    );
  }
}
