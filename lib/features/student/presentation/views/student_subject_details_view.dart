import 'package:flutter/material.dart';
import 'package:school_system/core/utils/app_colors.dart';
import 'package:school_system/core/utils/app_text_style.dart';
import 'package:school_system/features/student/data/models/student_subject_model.dart';
import 'package:school_system/features/student/presentation/views/widgets/student_subject_details_view_body.dart';

class StudentSubjectDetailsView extends StatelessWidget {
  static const String routeName = 'student_subject_details_view';
  final StudentSubjectModel subject;

  const StudentSubjectDetailsView({super.key, required this.subject});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      appBar: AppBar(
        backgroundColor: AppColors.backgroundColor,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: false,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: AppColors.primaryColor),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          subject.subjectName,
          style: AppTextStyle.bold16.copyWith(
            color: AppColors.darkBlue,
            fontSize: 18,
          ),
        ),
      ),
      body: StudentSubjectDetailsViewBody(subject: subject),
    );
  }
}
