import 'package:flutter/material.dart';
import 'package:school_system/core/utils/app_colors.dart';
import 'package:school_system/core/utils/app_text_style.dart';

class DashedUploadButton extends StatelessWidget {
  const DashedUploadButton({
    super.key,
    required this.title,
    required this.icon,
    required this.onTap,
  });

  final String title;
  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: const Color(0xffBFDBFE), width: 1.5),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: AppColors.primaryColor, size: 20),
            const SizedBox(width: 8),
            Text(
              title,
              style: AppTextStyle.semiBold14.copyWith(
                color: AppColors.primaryColor,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
