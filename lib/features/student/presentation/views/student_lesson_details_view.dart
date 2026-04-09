import 'package:flutter/material.dart';
import 'package:school_system/core/utils/app_colors.dart';
import 'package:school_system/core/utils/app_text_style.dart';
import 'package:school_system/features/student/presentation/views/widgets/student_lesson_details_view_body.dart';

class StudentLessonDetailsView extends StatelessWidget {
  static const String routeName = 'student_lesson_details_view';
  final String lessonTitle;

  const StudentLessonDetailsView({super.key, required this.lessonTitle});

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
          icon: Icon(Icons.arrow_back, color: AppColors.secondaryColor),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          lessonTitle,
          style: AppTextStyle.bold16.copyWith(
            color: AppColors.darkBlue,
            fontSize: 18,
          ),
        ),
      ),
      body: StudentLessonDetailsViewBody(lessonTitle: lessonTitle),
    );
  }
}
