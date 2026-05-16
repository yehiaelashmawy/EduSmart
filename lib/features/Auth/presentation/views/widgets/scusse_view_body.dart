import 'package:flutter/material.dart';
import 'package:school_system/core/utils/app_colors.dart';
import 'package:school_system/core/utils/app_text_style.dart';
import 'package:school_system/core/utils/size_config.dart';
import 'package:school_system/core/widgets/custom_button.dart';
import 'package:school_system/features/Auth/presentation/views/auth_view.dart';
import 'package:svg_flutter/svg.dart';

class ScusseViewBody extends StatelessWidget {
  const ScusseViewBody({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            children: [
              const Spacer(flex: 3),
              Text(
                'Success',
                style: AppTextStyle.bold24.copyWith(
                  color: AppColors.darkBlue,
                  fontSize: SizeConfig.getResponsiveFontSize(
                    context,
                    fontSize: 24,
                  ),
                ),
              ),
              const Spacer(flex: 1),
              Container(
                width: 128,
                height: 128,
                decoration: const ShapeDecoration(
                  color: Color(0xFFE6F7EF),
                  shape: CircleBorder(),
                ),
                child: Center(
                  child: SvgPicture.asset(
                    'assets/images/success.svg',
                    width: 80,
                    height: 80,
                  ),
                ),
              ),
              const Spacer(flex: 1),
              Text(
                'Password Reset Successful!',
                textAlign: TextAlign.center,
                style: AppTextStyle.bold24.copyWith(
                  color: AppColors.darkBlue,
                  fontSize: SizeConfig.getResponsiveFontSize(
                    context,
                    fontSize: 24,
                  ),
                ),
              ),
              const SizedBox(height: 12),
              Text(
                'Your password has been updated. You can now log in with your new credentials.',
                textAlign: TextAlign.center,
                style: AppTextStyle.regular16.copyWith(
                  color: AppColors.grey,
                  fontSize: SizeConfig.getResponsiveFontSize(
                    context,
                    fontSize: 16,
                  ),
                ),
              ),
              const SizedBox(height: 50),
              CustomButton(
                text: 'Back to Login',
                onPressed: () {
                  Navigator.pushNamedAndRemoveUntil(
                    context,
                    AuthView.routeName,
                    (route) => false,
                  );
                },
              ),
              const Spacer(flex: 4),
            ],
          ),
        ),
      ),
    );
  }
}
