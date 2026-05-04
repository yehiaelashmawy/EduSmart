import 'package:flutter/material.dart';
import 'package:school_system/core/utils/app_colors.dart';
import 'package:school_system/core/utils/app_text_style.dart';
import 'package:school_system/features/teacher/data/models/submission_model.dart';
import 'package:school_system/features/teacher/presentation/views/widgets/grade_submission_view_body.dart';

class GradeSubmissionView extends StatelessWidget {
  final SubmissionModel submission;
  final String homeworkId;
  final bool isExam;

  const GradeSubmissionView({
    super.key,
    required this.submission,
    required this.homeworkId,
    this.isExam = false,
  });

  static const String routeName = '/grade_submission';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              submission.studentName,
              style: AppTextStyle.bold18.copyWith(color: AppColors.black),
            ),
            const SizedBox(height: 2),
            Text(
              submission.studentEmail,
              style: AppTextStyle.regular12.copyWith(color: AppColors.grey),
            ),
          ],
        ),
        backgroundColor: AppColors.backgroundColor,
        elevation: 0,
        centerTitle: false,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: AppColors.primaryColor),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: GradeSubmissionViewBody(
        submission: submission,
        homeworkId: homeworkId,
        isExam: isExam,
      ),
    );
  }
}
