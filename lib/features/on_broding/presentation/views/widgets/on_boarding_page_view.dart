import 'package:flutter/material.dart';
import 'package:school_system/features/on_broding/presentation/views/widgets/onboarding_page_item.dart';
import 'package:school_system/features/on_broding/presentation/views/widgets/onberding_page_model.dart';

class OnBoardingPageView extends StatelessWidget {
  const OnBoardingPageView({
    super.key,
    required this.pageController,
    required this.pages,
    required this.onPageChanged,
  });

  final PageController pageController;
  final List<OnBoardingPageModel> pages;
  final ValueChanged<int> onPageChanged;

  @override
  Widget build(BuildContext context) {
    return PageView.builder(
      controller: pageController,
      itemCount: pages.length,
      onPageChanged: onPageChanged,
      itemBuilder: (context, index) {
        return OnBoardingPageItem(pageModel: pages[index]);
      },
    );
  }
}
