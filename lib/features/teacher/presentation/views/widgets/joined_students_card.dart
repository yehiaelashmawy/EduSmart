import 'package:flutter/material.dart';
import 'package:school_system/core/utils/app_colors.dart';
import 'package:school_system/core/utils/app_text_style.dart';
import 'package:school_system/core/utils/theme_manager.dart';

class JoinedStudentsCard extends StatelessWidget {
  final int joined;
  final int total;

  const JoinedStudentsCard({
    super.key,
    required this.joined,
    required this.total,
  });

  double get _progress => total == 0 ? 0 : joined / total;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Joined Students',
                    style: AppTextStyle.medium14.copyWith(color: AppColors.grey),
                  ),
                  const SizedBox(height: 4),
                  RichText(
                    text: TextSpan(
                      children: [
                        TextSpan(
                          text: '$joined',
                          style: AppTextStyle.bold24.copyWith(
                            color: AppColors.black,
                            fontSize: 30,
                          ),
                        ),
                        TextSpan(
                          text: ' / $total',
                          style: AppTextStyle.medium14.copyWith(
                            color: AppColors.grey,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: ThemeManager.isDarkMode
                      ? AppColors.lightGrey.withOpacity(0.2)
                      : const Color(0xffEEF1F8),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Icon(
                  Icons.groups_rounded,
                  color: AppColors.grey,
                  size: 24,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: LinearProgressIndicator(
              value: _progress,
              minHeight: 8,
              backgroundColor: const Color(0xffEEF1F8),
              valueColor: const AlwaysStoppedAnimation<Color>(
                Color(0xff065AD8),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
