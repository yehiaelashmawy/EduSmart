import 'package:flutter/material.dart';
import 'package:school_system/core/utils/app_colors.dart';
import 'package:school_system/core/utils/app_text_style.dart';
import 'package:school_system/core/utils/theme_manager.dart';

class CodeOptionButton extends StatelessWidget {
  final String code;
  final bool isActive;
  final VoidCallback onTap;

  const CodeOptionButton({
    super.key,
    required this.code,
    required this.isActive,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeInOut,
        width: 80,
        padding: const EdgeInsets.symmetric(vertical: 20),
        decoration: BoxDecoration(
          color: isActive
              ? const Color(0xff065AD8)
              : ThemeManager.isDarkMode
              ? AppColors.lightGrey.withValues(alpha: 0.2)
              : const Color(0xffEEF1F8),
          borderRadius: BorderRadius.circular(16),
          boxShadow: isActive
              ? [
                  BoxShadow(
                    color: const Color(0xff065AD8).withValues(alpha: 0.3),
                    blurRadius: 12,
                    offset: const Offset(0, 6),
                  ),
                ]
              : [],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              code,
              style: AppTextStyle.bold24.copyWith(
                color: isActive ? Colors.white : AppColors.black,
                fontSize: 28,
              ),
            ),
            if (isActive) ...[
              const SizedBox(height: 6),
              Text(
                'ACTIVE',
                style: AppTextStyle.bold12.copyWith(
                  color: Colors.white.withValues(alpha: 0.8),
                  fontSize: 9,
                  letterSpacing: 1.2,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
