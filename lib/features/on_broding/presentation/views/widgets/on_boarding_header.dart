import 'package:flutter/material.dart';
import 'package:school_system/core/utils/app_colors.dart';
import 'package:school_system/core/utils/app_text_style.dart';
import 'package:school_system/core/widgets/custom_app_bar.dart';

class OnBoardingHeader extends StatelessWidget {
  const OnBoardingHeader({
    super.key,
    required this.currentIndex,
    required this.pageController,
    this.headerTitle,
  });

  final int currentIndex;
  final PageController pageController;
  final String? headerTitle;

  @override
  Widget build(BuildContext context) {
    if (currentIndex == 2) {
      return CustomAppBar(
        title: headerTitle ?? '',
        onBackPressed: () {
          pageController.previousPage(
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOut,
          );
        },
      );
    }
    return SizedBox(
      height: 56,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Positioned(
            right: 8,
            child: TextButton(
              onPressed: () {
                pageController.animateToPage(
                  2,
                  duration: const Duration(milliseconds: 500),
                  curve: Curves.easeInOut,
                );
              },
              child: Text(
                'Skip',
                style: AppTextStyle.bold16.copyWith(
                  color: AppColors.primaryColor,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
