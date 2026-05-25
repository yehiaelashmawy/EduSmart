import 'package:school_system/core/utils/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:school_system/features/on_broding/presentation/views/widgets/on_boarding_header.dart';
import 'package:school_system/features/on_broding/presentation/views/widgets/on_boarding_page_view.dart';
import 'package:school_system/features/on_broding/presentation/views/widgets/on_bording_footer.dart';
import 'package:school_system/features/on_broding/presentation/views/widgets/onberding_page_model.dart';
import 'package:school_system/core/helper/localization_helper.dart';

class OnBordingViewBody extends StatefulWidget {
  const OnBordingViewBody({super.key});

  @override
  State<OnBordingViewBody> createState() => _OnBordingViewBodyState();
}

class _OnBordingViewBodyState extends State<OnBordingViewBody> {
  late PageController pageController;
  int currentIndex = 0;

  @override
  void initState() {
    pageController = PageController();
    super.initState();
  }

  @override
  void dispose() {
    pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final List<OnBoardingPageModel> pages = [
      OnBoardingPageModel(
        title: 'onboarding_title_1'.tr(),
        description: 'onboarding_desc_1'.tr(),
        image: 'assets/images/onboarding_bage_1.png',
        hasImagePadding: true,
      ),
      OnBoardingPageModel(
        title: 'onboarding_title_2'.tr(),
        description: 'onboarding_desc_2'.tr(),
        image: 'assets/images/onboarding_bage_2.png',
        hasImagePadding: true,
      ),
      OnBoardingPageModel(
        title: 'onboarding_title_3'.tr(),
        description: 'onboarding_desc_3'.tr(),
        image: 'assets/images/onboarding_bage_3.png',
        headerTitle: 'SmartTutor AI',
        hasImagePadding: false,
      ),
    ];

    return Scaffold(
      backgroundColor: AppColors.white,
      body: SafeArea(
        child: Column(
          children: [
            OnBoardingHeader(
              currentIndex: currentIndex,
              pageController: pageController,
              headerTitle: pages[currentIndex].headerTitle,
            ),
            const SizedBox(height: 16),
            Expanded(
              child: OnBoardingPageView(
                pageController: pageController,
                pages: pages,
                onPageChanged: (index) {
                  setState(() {
                    currentIndex = index;
                  });
                },
              ),
            ),
            OnBoardingFooter(
              currentIndex: currentIndex,
              pageController: pageController,
              pagesCount: pages.length,
            ),
          ],
        ),
      ),
    );
  }
}
