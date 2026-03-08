import 'package:flutter/material.dart';
import 'package:school_system/core/utils/app_colors.dart';
import 'package:school_system/core/utils/app_text_style.dart';

class CustomBackToLogin extends StatelessWidget {
  const CustomBackToLogin({super.key, this.showArrow = true});
  final bool showArrow;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        if (showArrow) ...[
          const Icon(Icons.arrow_back, size: 20, color: AppColors.primaryColor),
          const SizedBox(width: 8),
        ],
        GestureDetector(
          onTap: () => Navigator.pop(context),
          child: Text(
            'Back to Login',
            style: AppTextStyle.semiBold14.copyWith(
              color: const Color(0xFF0F52BD),
            ),
          ),
        ),
      ],
    );
  }
}
