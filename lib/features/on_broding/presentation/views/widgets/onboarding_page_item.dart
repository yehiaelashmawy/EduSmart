import 'package:flutter/material.dart';
import 'package:school_system/core/utils/app_colors.dart';
import 'package:school_system/core/utils/app_text_style.dart';
import 'package:school_system/features/on_broding/presentation/views/widgets/onberding_page_model.dart';

class OnBoardingPageItem extends StatelessWidget {
  const OnBoardingPageItem({super.key, required this.pageModel});

  final OnBoardingPageModel pageModel;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.symmetric(
              horizontal: pageModel.hasImagePadding ? 24 : 0,
            ),
            child: Image.asset(
              pageModel.image,
              width: double.infinity,
              fit: BoxFit.contain,
            ),
          ),
          const SizedBox(height: 32),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              children: [
                Text(
                  pageModel.title,
                  textAlign: TextAlign.center,
                  style: AppTextStyle.bold32.copyWith(
                    color: AppColors.darkBlue,
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  pageModel.description,
                  textAlign: TextAlign.center,
                  style: AppTextStyle.regular18.copyWith(color: AppColors.grey),
                ),
                const SizedBox(height: 24), // Added bottom padding for safety
              ],
            ),
          ),
        ],
      ),
    );
  }
}
