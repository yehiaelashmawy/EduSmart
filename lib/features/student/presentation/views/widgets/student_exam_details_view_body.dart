import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:school_system/features/student/data/models/student_exam_model.dart';
import 'package:school_system/features/student/presentation/views/widgets/student_exam_details_hero_card.dart';
import 'package:school_system/features/student/presentation/views/widgets/student_exam_teacher_instructions.dart';
import 'package:school_system/features/student/presentation/views/widgets/student_exam_reference_materials.dart';
import 'package:school_system/features/student/presentation/views/widgets/student_exam_submission_box.dart';
import 'package:school_system/features/student/presentation/views/widgets/student_exam_my_submission.dart';

class StudentExamDetailsViewBody extends StatelessWidget {
  final StudentExamModel exam;

  const StudentExamDetailsViewBody({
    super.key,
    required this.exam,
  });

  @override
  Widget build(BuildContext context) {
    String formattedDate = '';
    if (exam.date != null) {
      try {
        final date = DateTime.parse(exam.date!);
        formattedDate = DateFormat('MMM dd, yyyy').format(date);
      } catch (e) {
        formattedDate = exam.date!;
      }
    }

    final hasSubmission = exam.mySubmission != null;

    return ListView(
      padding: const EdgeInsets.all(24.0),
      children: [
        StudentExamDetailsHeroCard(
          status: exam.status ?? '',
          title: exam.name ?? '',
          date: formattedDate,
          time: exam.startTime ?? '',
          duration: exam.duration ?? '',
          room: exam.room ?? '',
        ),
        const SizedBox(height: 32),
        StudentExamTeacherInstructions(
          instructions: [exam.instructions ?? ''],
        ),
        const SizedBox(height: 32),
        StudentExamReferenceMaterials(
          materials: exam.materials ?? [],
        ),
        const SizedBox(height: 32),
        if (hasSubmission)
          StudentExamMySubmission(submission: exam.mySubmission!)
        else ...[
          StudentExamSubmissionBox(examId: exam.examId ?? ''),
          const SizedBox(height: 16),
        ],
      ],
    );
  }
}
