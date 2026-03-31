import 'package:flutter/material.dart';
import 'package:school_system/core/utils/app_colors.dart';
import 'package:school_system/core/utils/app_text_style.dart';
import 'package:school_system/core/utils/theme_manager.dart';
import 'smart_tutor_view_body.dart';

class SmartTutorView extends StatelessWidget {
  const SmartTutorView({super.key});
  static const String routeName = 'smart_tutor_view';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ThemeManager.isDarkMode ? AppColors.backgroundColor : AppColors.white,
      appBar: AppBar(
        backgroundColor: ThemeManager.isDarkMode ? AppColors.backgroundColor : AppColors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: ThemeManager.isDarkMode ? Colors.white : AppColors.darkBlue,
          ),
          onPressed: () => Navigator.pop(context),
        ),
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: AppColors.primaryColor.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.psychology,
                color: Color(0xff004182), // Use hardcoded color to be safe if AppColors.primaryColor isn't const
              ),
            ),
            const SizedBox(width: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'SmartTutor AI',
                  style: AppTextStyle.medium18.copyWith(
                    color: ThemeManager.isDarkMode ? Colors.white : AppColors.darkBlue,
                  ),
                ),
                Text(
                  'Online',
                  style: AppTextStyle.regular12.copyWith(
                    color: AppColors.primaryColor,
                  ),
                ),
              ],
            ),
          ],
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1.0),
          child: Container(
            color: ThemeManager.isDarkMode
                ? AppColors.lightGrey.withOpacity(0.3)
                : const Color(0xffE2E8F0),
            height: 1.0,
          ),
        ),
      ),
      body: const SafeArea(
        child: SmartTutorViewBody(),
      ),
    );
  }
}
