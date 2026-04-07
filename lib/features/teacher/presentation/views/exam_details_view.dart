import 'package:flutter/material.dart';
import 'package:school_system/core/utils/app_colors.dart';
import 'package:school_system/core/utils/app_text_style.dart';
import 'package:school_system/features/teacher/presentation/views/widgets/exam_details_view_body.dart';

class ExamDetailsView extends StatelessWidget {
  const ExamDetailsView({super.key});

  static const String routeName = '/exam_details';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      appBar: AppBar(
        title: Text(
          'Exam Details',
          style: AppTextStyle.bold18.copyWith(color: AppColors.darkBlue),
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
            icon: Icon(Icons.more_vert, color: AppColors.darkBlue),
            onPressed: () {},
          ),
        ],
      ),
      body: const ExamDetailsViewBody(),
    );
  }
}
