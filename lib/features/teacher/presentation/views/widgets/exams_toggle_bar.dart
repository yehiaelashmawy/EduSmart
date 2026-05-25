import 'package:flutter/material.dart';
import 'package:school_system/core/utils/app_colors.dart';
import 'package:school_system/core/utils/app_text_style.dart';
import 'package:school_system/core/helper/localization_helper.dart';

class ExamsToggleBar extends StatelessWidget {
  const ExamsToggleBar({
    super.key,
    required this.isUpcomingExams,
    required this.onToggle,
  });

  final bool isUpcomingExams;
  final ValueChanged<bool> onToggle;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.lightGrey.withValues(alpha: 0.3),
          borderRadius: BorderRadius.circular(30),
        ),
        child: Row(
          children: [
            Expanded(
              child: GestureDetector(
                onTap: () => onToggle(true),
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  decoration: BoxDecoration(
                    color: isUpcomingExams
                        ? AppColors.white
                        : Colors.transparent,
                    borderRadius: BorderRadius.circular(30),
                    boxShadow: isUpcomingExams
                        ? [
                            BoxShadow(
                              color: AppColors.black.withValues(alpha: 0.05),
                              blurRadius: 4,
                              offset: const Offset(0, 2),
                            ),
                          ]
                        : [],
                  ),
                  child: Center(
                    child: Text(
                      LocalizationHelper.isArabic ? 'الاختبارات القادمة' : 'Upcoming Exams',
                      style: AppTextStyle.semiBold14.copyWith(
                        color: isUpcomingExams
                            ? AppColors.secondaryColor
                            : AppColors.grey,
                      ),
                    ),
                  ),
                ),
              ),
            ),
            Expanded(
              child: GestureDetector(
                onTap: () => onToggle(false),
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  decoration: BoxDecoration(
                    color: !isUpcomingExams
                        ? AppColors.white
                        : Colors.transparent,
                    borderRadius: BorderRadius.circular(30),
                    boxShadow: !isUpcomingExams
                        ? [
                            BoxShadow(
                              color: AppColors.black.withValues(alpha: 0.05),
                              blurRadius: 4,
                              offset: const Offset(0, 2),
                            ),
                          ]
                        : [],
                  ),
                  child: Center(
                    child: Text(
                      LocalizationHelper.isArabic ? 'الاختبارات الماضية' : 'Past Exams',
                      style: AppTextStyle.semiBold14.copyWith(
                        color: !isUpcomingExams
                            ? AppColors.secondaryColor
                            : AppColors.grey,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
