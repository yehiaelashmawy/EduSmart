import 'package:flutter/material.dart';
import 'package:school_system/core/utils/app_colors.dart';
import 'package:school_system/core/utils/app_text_style.dart';

import 'package:school_system/features/parent/data/models/children_dashboard_model.dart';

class SubjectPerformanceList extends StatelessWidget {
  final List<SubjectScore>? subjects;
  const SubjectPerformanceList({super.key, this.subjects});

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> displaySubjects = subjects?.map((s) {
      return {
        'name': s.name,
        'score': s.percentage / 100.0,
        'percent': '${s.percentage}%',
        'icon': _getIconForSubject(s.name),
        'color': _getColorForSubject(s.name),
      };
    }).toList() ?? [
      {'name': 'Mathematics', 'score': 0.94, 'percent': '94%', 'icon': Icons.calculate_outlined, 'color': const Color(0xff004EEB)},
      {'name': 'Computer Science', 'score': 0.88, 'percent': '88%', 'icon': Icons.computer_rounded, 'color': const Color(0xff0F52BD)},
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
        children: displaySubjects.map((subject) {
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

  IconData _getIconForSubject(String name) {
    name = name.toLowerCase();
    if (name.contains('math')) return Icons.calculate_outlined;
    if (name.contains('computer')) return Icons.computer_rounded;
    if (name.contains('history')) return Icons.public_rounded;
    if (name.contains('chemistry') || name.contains('science')) return Icons.science_outlined;
    if (name.contains('arabic')) return Icons.language_rounded;
    return Icons.book_outlined;
  }

  Color _getColorForSubject(String name) {
    name = name.toLowerCase();
    if (name.contains('math')) return const Color(0xff004EEB);
    if (name.contains('computer')) return const Color(0xff0F52BD);
    if (name.contains('history')) return const Color(0xff12B76A);
    if (name.contains('chemistry') || name.contains('science')) return const Color(0xffF04438);
    if (name.contains('arabic')) return Colors.orange;
    return Colors.blueGrey;
  }
}
