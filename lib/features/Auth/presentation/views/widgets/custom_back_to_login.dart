import 'package:flutter/material.dart';
import 'package:school_system/core/utils/app_colors.dart';
import 'package:school_system/core/utils/app_text_style.dart';
import 'package:school_system/features/Auth/presentation/views/login_view.dart';

import 'package:school_system/core/helper/localization_helper.dart';

class CustomBackToLogin extends StatelessWidget {
  const CustomBackToLogin({super.key, this.showArrow = true});
  final bool showArrow;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        if (showArrow) ...[
          Transform.scale(
            scaleX: LocalizationHelper.isArabic ? -1 : 1,
            child: Icon(Icons.arrow_back, size: 20, color: AppColors.primaryColor),
          ),
          const SizedBox(width: 8),
        ],
        GestureDetector(
          onTap: () => Navigator.pushNamed(context, LoginView.routeName),
          child: Text(
            'back_to_login'.tr(),
            style: AppTextStyle.semiBold14.copyWith(
              color: AppColors.secondaryColor,
            ),
          ),
        ),
      ],
    );
  }
}
