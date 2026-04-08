import 'package:flutter/material.dart';
import 'package:school_system/features/student/presentation/views/widgets/next_class_card.dart';
import 'package:school_system/features/student/presentation/views/widgets/smart_tutor_banner.dart';
import 'package:school_system/features/student/presentation/views/widgets/student_assignments_exams.dart';
import 'package:school_system/features/student/presentation/views/widgets/student_home_action_cards.dart';
import 'package:school_system/features/student/presentation/views/widgets/student_home_header.dart';
import 'package:school_system/features/student/presentation/views/widgets/student_today_schedule.dart';

class StudentHomeViewBody extends StatelessWidget {
  const StudentHomeViewBody({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            StudentHomeHeader(),
            SizedBox(height: 24),
            StudentHomeActionCards(),
            SizedBox(height: 20),
            SmartTutorBanner(),
            SizedBox(height: 24),
            NextClassCard(),
            SizedBox(height: 32),
            StudentTodaySchedule(),
            SizedBox(height: 32),
            StudentAssignmentsExams(),
            SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}
