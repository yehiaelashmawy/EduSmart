import 'package:flutter/material.dart';
import 'package:school_system/core/utils/app_colors.dart';
import 'package:school_system/core/utils/app_text_style.dart';
import 'package:school_system/features/teacher/presentation/views/widgets/grade_submission_view_body.dart';

class GradeSubmissionView extends StatelessWidget {
  const GradeSubmissionView({super.key});

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
              'Alex Johnson',
              style: AppTextStyle.bold18.copyWith(color: AppColors.black),
            ),
            const SizedBox(height: 4),
            Text(
              'Assignment: World History Essay',
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
        actions: [
          IconButton(
            icon: Icon(Icons.more_vert, color: AppColors.grey),
            onPressed: () {},
          ),
        ],
      ),
      body: const GradeSubmissionViewBody(),
    );
  }
}
