import 'package:flutter/material.dart';
import 'package:school_system/core/utils/app_colors.dart';
import 'package:school_system/core/utils/size_config.dart';
import 'package:school_system/core/utils/theme_manager.dart';

class DateSeparator extends StatelessWidget {
  final String dateText;

  const DateSeparator({super.key, required this.dateText});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
        decoration: BoxDecoration(
          color: ThemeManager.isDarkMode
              ? const Color(0xFF1E293B)
              : const Color(0xffE2E8F0).withValues(alpha: 0.5),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Text(
          dateText,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: AppColors.grey,
            letterSpacing: 0.5,
            fontSize: SizeConfig.getResponsiveFontSize(context, fontSize: 10),
          ),
        ),
      ),
    );
  }
}
