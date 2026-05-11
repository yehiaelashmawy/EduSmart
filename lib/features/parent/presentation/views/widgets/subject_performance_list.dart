import 'package:flutter/material.dart';
import 'package:school_system/core/utils/app_colors.dart';
import 'package:school_system/core/utils/app_text_style.dart';

class SubjectPerformanceList extends StatelessWidget {
  const SubjectPerformanceList({super.key});

  @override
  Widget build(BuildContext context) {
    final subjects = [
      {'name': 'Mathematics', 'score': 0.94, 'percent': '94%', 'icon': Icons.calculate_outlined, 'color': const Color(0xff004EEB)},
      {'name': 'Computer Science', 'score': 0.88, 'percent': '88%', 'icon': Icons.computer_rounded, 'color': const Color(0xff0F52BD)},
      {'name': 'World History', 'score': 0.91, 'percent': '91%', 'icon': Icons.public_rounded, 'color': const Color(0xff12B76A)},
      {'name': 'Modern Chemistry', 'score': 0.85, 'percent': '85%', 'icon': Icons.science_outlined, 'color': const Color(0xffF04438)},
    ];

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: AppColors.lightGrey.withValues(alpha: 0.3)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      padding: const EdgeInsets.all(20),
      child: Column(
        children: subjects.map((subject) {
          final color = subject['color'] as Color;
          return Padding(
            padding: const EdgeInsets.only(bottom: 20),
            child: Column(
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: color.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Icon(subject['icon'] as IconData, size: 18, color: color),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        subject['name'] as String,
                        style: AppTextStyle.bold14.copyWith(
                          color: AppColors.darkBlue,
                        ),
                      ),
                    ),
                    Text(
                      subject['percent'] as String,
                      style: AppTextStyle.bold14.copyWith(
                        color: AppColors.darkBlue,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: LinearProgressIndicator(
                    value: subject['score'] as double,
                    backgroundColor: AppColors.lightGrey.withValues(alpha: 0.3),
                    valueColor: AlwaysStoppedAnimation<Color>(color),
                    minHeight: 6,
                  ),
                ),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }
}
