import 'package:flutter/material.dart';
import 'package:school_system/core/utils/app_colors.dart';
import 'package:school_system/core/utils/app_text_style.dart';

class StudentExamTeacherInstructions extends StatelessWidget {
  final List<String> instructions;

  const StudentExamTeacherInstructions({super.key, required this.instructions});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppColors.lightGrey.withValues(alpha: 0.2), // Light tinted background
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.campaign, color: AppColors.secondaryColor, size: 20),
              const SizedBox(width: 8),
              Text(
                'Teacher\'s Instructions',
                style: AppTextStyle.bold16.copyWith(
                  color: AppColors.darkBlue,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          ...instructions.map((instruction) => _buildInstructionItem(instruction)),
        ],
      ),
    );
  }

  Widget _buildInstructionItem(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 18,
            width: 3,
            margin: const EdgeInsets.only(top: 2),
            decoration: BoxDecoration(
              color: AppColors.primaryColor.withValues(alpha: 0.5),
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              text,
              style: AppTextStyle.medium12.copyWith(
                color: AppColors.grey,
                height: 1.5,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
