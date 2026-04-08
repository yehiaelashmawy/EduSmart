import 'package:flutter/material.dart';
import 'package:school_system/core/utils/app_colors.dart';
import 'package:school_system/core/utils/app_text_style.dart';

class StudentSubjectsAppBar extends StatelessWidget {
  final VoidCallback? onFilterTap;

  const StudentSubjectsAppBar({super.key, this.onFilterTap});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(24, 20, 24, 16),
      color: Colors.white,
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: AppColors.primaryColor.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(Icons.school_outlined, color: AppColors.primaryColor),
          ),
          const SizedBox(width: 12),
          Text(
            'My Subjects',
            style: AppTextStyle.bold20.copyWith(color: AppColors.darkBlue),
          ),
          const Spacer(),
          InkWell(
            onTap: onFilterTap,
            child: Icon(Icons.filter_list, color: AppColors.darkBlue, size: 28),
          ),
        ],
      ),
    );
  }
}
