import 'package:flutter/material.dart';
import 'package:school_system/features/student/presentation/views/widgets/student_exam_details_hero_card.dart';
import 'package:school_system/features/student/presentation/views/widgets/student_exam_teacher_instructions.dart';
import 'package:school_system/features/student/presentation/views/widgets/student_exam_reference_materials.dart';
import 'package:school_system/features/student/presentation/views/widgets/student_exam_submission_box.dart';

class StudentExamDetailsViewBody extends StatelessWidget {
  final String status;
  final String title;
  final String date;
  final String time;
  final String duration;
  final String room;
  final List<String> instructions;

  const StudentExamDetailsViewBody({
    super.key,
    required this.status,
    required this.title,
    required this.date,
    required this.time,
    required this.duration,
    required this.room,
    required this.instructions,
  });

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(24.0),
      children: [
        StudentExamDetailsHeroCard(
          status: status,
          title: title,
          date: date,
          time: time,
          duration: duration,
          room: room,
        ),
        const SizedBox(height: 32),
        StudentExamTeacherInstructions(instructions: instructions),
        const SizedBox(height: 32),
        const StudentExamReferenceMaterials(),
        const SizedBox(height: 32),
        const StudentExamSubmissionBox(),
        const SizedBox(height: 16),
      ],
    );
  }
}
