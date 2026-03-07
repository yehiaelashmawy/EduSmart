import 'package:flutter/material.dart';
import 'package:school_system/core/utils/app_colors.dart';
import 'package:school_system/core/utils/app_text_style.dart';

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
    return SizedBox(
      height: 56,
      child: Stack(
        alignment: Alignment.center,
        children: [
          if (currentIndex == 2)
            Align(
              alignment: Alignment.centerLeft,
              child: Padding(
                padding: const EdgeInsets.only(left: 8),
                child: IconButton(
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                  onPressed: () {
                    pageController.previousPage(
                      duration: const Duration(milliseconds: 300),
                      curve: Curves.easeInOut,
                    );
                  },
                  icon: const Icon(Icons.arrow_back, color: AppColors.darkBlue),
                ),
              ),
            ),
          if (headerTitle != null)
            Text(
              headerTitle!,
              style: AppTextStyle.bold20.copyWith(color: AppColors.darkBlue),
            ),
          if (currentIndex < 2)
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
