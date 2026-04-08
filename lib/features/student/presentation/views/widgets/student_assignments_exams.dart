import 'package:flutter/material.dart';
import 'package:school_system/core/utils/app_colors.dart';

class StudentAssignmentsExams extends StatelessWidget {
  const StudentAssignmentsExams({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Expanded(
          child: _TaskCard(
            title: 'ASSIGNMENTS',
            date: 'TOMORROW',
            task: 'Essay: Macbeth',
            dotColor: Colors.red,
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: _TaskCard(
            title: 'EXAMS',
            date: 'FRIDAY',
            task: 'Midterm Quiz',
            dotColor: AppColors.primaryColor,
          ),
        ),
      ],
    );
  }
}

class _TaskCard extends StatelessWidget {
  final String title;
  final String date;
  final String task;
  final Color dotColor;

  const _TaskCard({
    required this.title,
    required this.date,
    required this.task,
    required this.dotColor,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: 10,
            fontWeight: FontWeight.bold,
            color: AppColors.grey,
            letterSpacing: 1,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: AppColors.lightGrey.withValues(alpha: 0.3)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    width: 8,
                    height: 8,
                    decoration: BoxDecoration(
                      color: dotColor,
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    date,
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                      color: dotColor,
                      letterSpacing: 0.5,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                task,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: AppColors.darkBlue,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
