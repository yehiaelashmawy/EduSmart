import 'package:flutter/material.dart';
import 'package:school_system/features/parent/presentation/views/widgets/kid_homework_card.dart';
import 'package:school_system/features/parent/presentation/views/widgets/kid_section_header.dart';

class KidHomeworkTab extends StatelessWidget {
  const KidHomeworkTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const KidSectionHeader(
            icon: Icons.assignment_outlined,
            title: 'Homework Assignments',
          ),
          const SizedBox(height: 24),
          const KidHomeworkCard(
            title: 'Algebra Worksheet 4.2',
            subject: 'Mathematics',
            info: 'Due: Tomorrow, 11:59 PM',
            status: 'PENDING',
          ),
          const KidHomeworkCard(
            title: 'Physics Lab Report',
            subject: 'Science',
            info: 'Submitted: Oct 23, 2024',
            status: 'SUBMITTED',
          ),
          const KidHomeworkCard(
            title: 'English Essay: The Great Gatsby',
            subject: 'Literature',
            info: 'Submitted: Oct 18, 2024',
            status: 'GRADED',
            grade: '95/100',
            comment: 'Excellent analysis!',
          ),
          const KidHomeworkCard(
            title: 'World History Chapter 5 Quiz',
            subject: 'History',
            info: 'Submitted: Oct 15, 2024',
            status: 'GRADED',
            grade: '98/100',
          ),
          const SizedBox(height: 32),
        ],
      ),
    );
  }
}
