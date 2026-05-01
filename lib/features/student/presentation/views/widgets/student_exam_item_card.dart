import 'package:flutter/material.dart';
import 'package:school_system/core/utils/app_colors.dart';
import 'package:school_system/core/utils/app_text_style.dart';

class StudentExamItemCard extends StatelessWidget {
  final IconData iconData;
  final Color iconColor;
  final Color iconBackgroundColor;

  final String badgeText;
  final Color badgeTextColor;
  final Color badgeBackgroundColor;

  final String title;
  final String subtitle;

  final String bottomLabel;
  final String bottomValue;
  final Color bottomValueColor;

  final VoidCallback onViewDetails;
  final bool isPrimaryButton;

  const StudentExamItemCard({
    super.key,
    required this.iconData,
    required this.iconColor,
    required this.iconBackgroundColor,
    required this.badgeText,
    required this.badgeTextColor,
    required this.badgeBackgroundColor,
    required this.title,
    required this.subtitle,
    required this.bottomLabel,
    required this.bottomValue,
    required this.bottomValueColor,
    required this.onViewDetails,
    this.isPrimaryButton = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header Row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: iconBackgroundColor,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(iconData, color: iconColor, size: 24),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: badgeBackgroundColor,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  badgeText.toUpperCase(),
                  style: AppTextStyle.bold12.copyWith(
                    color: badgeTextColor,
                    fontSize: 10,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          
          // Title and Subtitle
          Text(
            title,
            style: AppTextStyle.bold16.copyWith(
              color: AppColors.darkBlue,
              fontSize: 18,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 8),
          Text(
            subtitle,
            style: AppTextStyle.medium12.copyWith(
              color: AppColors.grey,
              height: 1.5,
            ),
          ),
          
          const SizedBox(height: 24),
          
          // Bottom Row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      bottomLabel.toUpperCase(),
                      style: AppTextStyle.bold12.copyWith(
                        color: AppColors.grey,
                        fontSize: 10,
                        letterSpacing: 0.5,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    FittedBox(
                      fit: BoxFit.scaleDown,
                      alignment: Alignment.centerLeft,
                      child: Text(
                        bottomValue,
                        style: AppTextStyle.bold24.copyWith(
                          color: bottomValueColor,
                          fontSize: 22,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              SizedBox(
                height: 36,
                child: isPrimaryButton
                    ? ElevatedButton(
                        onPressed: onViewDetails,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.secondaryColor,
                          elevation: 0,
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: Text(
                          'View Details',
                          style: AppTextStyle.bold12.copyWith(
                            color: Colors.white,
                          ),
                        ),
                      )
                    : TextButton(
                        onPressed: onViewDetails,
                        style: TextButton.styleFrom(
                          backgroundColor: AppColors.primaryColor.withValues(alpha: 0.1),
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: Text(
                          'View Details',
                          style: AppTextStyle.bold12.copyWith(
                            color: AppColors.secondaryColor,
                          ),
                        ),
                      ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
