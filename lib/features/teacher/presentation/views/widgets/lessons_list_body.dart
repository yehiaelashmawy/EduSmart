import 'package:flutter/material.dart';
import 'package:school_system/features/teacher/presentation/views/widgets/lesson_list_item.dart';

class LessonsListBody extends StatelessWidget {
  const LessonsListBody({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xffF8FAFC),
      child: Column(
        children: [
          const SizedBox(height: 16),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              children: const [
                LessonListItem(
                  title: 'Introduction to Calculus',
                  dateInfo: 'Oct 12, 2023 - 09:00 AM',
                  image: 'assets/images/lesson1.png',
                ),
                SizedBox(height: 16),
                LessonListItem(
                  title: 'Trigonometric Functions',
                  dateInfo: 'Oct 10, 2023 - 10:30 AM',
                  image: 'assets/images/lesson2.png',
                ),
                SizedBox(height: 16),
                LessonListItem(
                  title: 'Limits and Continuity',
                  dateInfo: 'Oct 08, 2023 - 01:00 PM',
                  image: 'assets/images/lesson3.png',
                ),
                SizedBox(height: 16),
                LessonListItem(
                  title: 'Differentiation Rules',
                  dateInfo: 'Oct 05, 2023 - 09:00 AM',
                  image: 'assets/images/lesson4.png',
                ),
                SizedBox(height: 24),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
