import 'package:flutter/material.dart';
import 'package:school_system/core/utils/app_colors.dart';
import 'package:school_system/core/utils/app_text_style.dart';

class KidSectionHeader extends StatelessWidget {
  final IconData icon;
  final String title;

  const KidSectionHeader({super.key, required this.icon, required this.title});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, color: AppColors.primaryColor, size: 20),
        const SizedBox(width: 8),
        Text(
          title.toUpperCase(),
          style: AppTextStyle.bold14.copyWith(
            color: AppColors.darkBlue,
            letterSpacing: 0.5,
          ),
        ),
      ],
    );
  }
}
