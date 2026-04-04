import 'package:flutter/material.dart';
import 'package:school_system/core/utils/app_colors.dart';
import 'package:school_system/core/utils/app_text_style.dart';

class AttendanceReportMonthFilter extends StatelessWidget {
  final String currentMonth;
  final VoidCallback onPrevious;
  final VoidCallback onNext;

  const AttendanceReportMonthFilter({
    super.key,
    required this.currentMonth,
    required this.onPrevious,
    required this.onNext,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        InkWell(
          onTap: onPrevious,
          borderRadius: BorderRadius.circular(8),
          child: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              border: Border.all(color: AppColors.lightGrey.withOpacity(0.5)),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              Icons.chevron_left_rounded,
              color: AppColors.black,
            ),
          ),
        ),
        Text(
          currentMonth,
          style: AppTextStyle.semiBold16.copyWith(
            color: AppColors.black,
            fontSize: 18,
          ),
        ),
        InkWell(
          onTap: onNext,
          borderRadius: BorderRadius.circular(8),
          child: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              border: Border.all(color: AppColors.lightGrey.withOpacity(0.5)),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              Icons.chevron_right_rounded,
              color: AppColors.black,
            ),
          ),
        ),
      ],
    );
  }
}
