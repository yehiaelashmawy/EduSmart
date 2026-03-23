import 'package:flutter/material.dart';
import 'package:school_system/core/utils/app_colors.dart';

class LearningObjectivesSection extends StatelessWidget {
  const LearningObjectivesSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFFDCE8F5), // Light grey matching design
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(
                Icons.fact_check_outlined,
                color: AppColors.darkBlue,
                size: 20,
              ),
              SizedBox(width: 8),
              Text(
                'Learning Objectives',
                style: TextStyle(
                  color: AppColors.darkBlue,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          _buildObjectiveItem(
            'Understand the conceptual definition of a Limit.',
          ),
          const SizedBox(height: 12),
          _buildObjectiveItem('Apply power rules for basic differentiation.'),
          const SizedBox(height: 12),
          _buildObjectiveItem(
            'Solve real-world optimization problems using derivatives.',
          ),
        ],
      ),
    );
  }

  Widget _buildObjectiveItem(String text) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.only(top: 2.0),
          child: Icon(
            Icons.check_circle_outline,
            color: Color(0xff0F52BD),
            size: 16,
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            text,
            style: const TextStyle(
              color: AppColors.grey,
              fontSize: 13,
              height: 1.4,
            ),
          ),
        ),
      ],
    );
  }
}
