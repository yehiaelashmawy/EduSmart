import 'package:flutter/material.dart';
import 'package:school_system/core/utils/app_colors.dart';
import 'package:school_system/core/utils/app_text_style.dart';
import 'package:school_system/features/teacher/presentation/views/widgets/exam_results_view_body.dart';

class ExamResultsView extends StatelessWidget {
  const ExamResultsView({super.key});
  static const String routeName = '/exam_results';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Exam Results',
              style: AppTextStyle.bold16.copyWith(color: AppColors.black),
            ),
            const SizedBox(height: 4),
            Text(
              'Mathematics • Grade 10 - A',
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
            icon: Icon(Icons.download_outlined, color: AppColors.primaryColor),
            onPressed: () {},
          ),
        ],
      ),
      body: const ExamResultsViewBody(),
    );
  }
}
