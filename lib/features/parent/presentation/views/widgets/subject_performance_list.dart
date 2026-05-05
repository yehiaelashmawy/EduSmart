import 'package:flutter/material.dart';
import 'package:school_system/core/utils/app_colors.dart';
import 'package:school_system/core/utils/app_text_style.dart';

class SubjectPerformanceList extends StatelessWidget {
  const SubjectPerformanceList({super.key});

  @override
  Widget build(BuildContext context) {
    final subjects = [
      {'name': 'Mathematics', 'score': 0.94, 'percent': '94%'},
      {'name': 'Computer Science', 'score': 0.88, 'percent': '88%'},
      {'name': 'World History', 'score': 0.91, 'percent': '91%'},
      {'name': 'Modern Chemistry', 'score': 0.85, 'percent': '85%'},
    ];

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.primaryColor.withValues(alpha: 0.03),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        children: subjects.map((subject) {
          return Padding(
            padding: const EdgeInsets.only(bottom: 20),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      subject['name'] as String,
                      style: AppTextStyle.semiBold14.copyWith(
                        color: AppColors.darkBlue,
                      ),
                    ),
                    Text(
                      subject['percent'] as String,
                      style: AppTextStyle.bold14.copyWith(
                        color: AppColors.primaryColor,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                LinearProgressIndicator(
                  value: subject['score'] as double,
                  backgroundColor: AppColors.primaryColor.withValues(alpha: 0.1),
                  valueColor: AlwaysStoppedAnimation<Color>(AppColors.primaryColor),
                  minHeight: 8,
                  borderRadius: BorderRadius.circular(4),
                ),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }
}
