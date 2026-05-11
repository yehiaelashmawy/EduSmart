import 'package:flutter/material.dart';
import 'package:school_system/core/utils/app_colors.dart';
import 'package:school_system/core/utils/app_text_style.dart';

class KidComingSoon extends StatelessWidget {
  const KidComingSoon({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 60, horizontal: 32),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(28),
              decoration: BoxDecoration(
                color: AppColors.primaryColor.withValues(alpha: 0.05),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.auto_awesome_mosaic_rounded,
                size: 48,
                color: AppColors.primaryColor.withValues(alpha: 0.4),
              ),
            ),
            const SizedBox(height: 24),
            Text(
              'Coming Soon',
              style: AppTextStyle.bold18.copyWith(color: AppColors.darkBlue),
            ),
            const SizedBox(height: 8),
            Text(
              "We're working on bringing more\ndetails for this section.",
              textAlign: TextAlign.center,
              style: AppTextStyle.medium14.copyWith(color: AppColors.grey),
            ),
          ],
        ),
      ),
    );
  }
}
