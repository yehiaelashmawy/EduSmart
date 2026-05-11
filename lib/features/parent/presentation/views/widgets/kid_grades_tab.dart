import 'package:flutter/material.dart';
import 'package:school_system/features/parent/presentation/views/widgets/kid_subject_grade_card.dart';

class KidGradesTab extends StatelessWidget {
  const KidGradesTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        children: [
          KidSubjectGradeCard(
            subject: 'Mathematics',
            percent: '94%',
            letterGrade: 'A',
            quizzes: const [
              {'title': 'Mid-term Exam', 'date': 'Oct 15, 2023', 'percent': 92},
              {
                'title': 'Chapter 4 Quiz',
                'date': 'Oct 02, 2023',
                'percent': 96,
              },
            ],
            assignments: const [
              {'title': 'Problem Set 5', 'date': 'Oct 20, 2023', 'percent': 95},
              {
                'title': 'Problem Set 4',
                'date': 'Oct 10, 2023',
                'percent': 100,
              },
            ],
          ),
          const SizedBox(height: 20),
          KidSubjectGradeCard(
            subject: 'Physics',
            percent: '88%',
            letterGrade: 'B+',
            quizzes: const [
              {'title': 'Mid-term Exam', 'date': 'Oct 18, 2023', 'percent': 85},
              {
                'title': 'Kinematics Quiz',
                'date': 'Sep 25, 2023',
                'percent': 90,
              },
            ],
            assignments: const [
              {
                'title': 'Lab Report: Free Fall',
                'date': 'Oct 22, 2023',
                'percent': 92,
              },
              {'title': 'Homework 3', 'date': 'Oct 12, 2023', 'percent': 88},
            ],
          ),
          const SizedBox(height: 32),
        ],
      ),
    );
  }
}
