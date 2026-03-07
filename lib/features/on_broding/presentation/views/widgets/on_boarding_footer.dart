import 'package:flutter/material.dart';
import 'package:school_system/features/on_broding/presentation/views/widgets/custom_dot_indicator.dart';
import 'package:school_system/features/on_broding/presentation/views/widgets/on_boarding_button.dart';

class OnBoardingFooter extends StatelessWidget {
  const OnBoardingFooter({
    super.key,
    required this.currentIndex,
    required this.pageController,
    required this.pagesCount,
  });

  final int currentIndex;
  final PageController pageController;
  final int pagesCount;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 48),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(
                  pagesCount,
                  (index) =>
                      CustomDotIndicator(isActive: index == currentIndex),
                ),
              ),
              const SizedBox(height: 46),
              OnBoardingButton(
                onPressed: () {
                  if (currentIndex < 2) {
                    pageController.nextPage(
                      duration: const Duration(milliseconds: 300),
                      curve: Curves.easeInOut,
                    );
                  } else {
                    // Navigate to Login/Home
                  }
                },
                text: currentIndex == 2 ? 'Get started' : 'Next',
                showArrow: currentIndex != 2,
              ),
              const SizedBox(height: 32),
            ],
          ),
        ),
      ],
    );
  }
}
