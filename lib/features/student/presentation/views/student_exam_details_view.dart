import 'package:flutter/material.dart';
import 'package:school_system/core/utils/app_colors.dart';
import 'package:school_system/core/utils/app_text_style.dart';
import 'package:school_system/features/student/data/models/student_exam_model.dart';
import 'package:school_system/features/student/presentation/views/widgets/student_exam_details_view_body.dart';

class StudentExamDetailsArgs {
  final StudentExamModel exam;

  StudentExamDetailsArgs({
    required this.exam,
  });
}

class StudentExamDetailsView extends StatelessWidget {
  static const String routeName = 'student_exam_details_view';

  final StudentExamModel exam;

  const StudentExamDetailsView({
    super.key,
    required this.exam,
  });

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
          'Exam Details',
          style: AppTextStyle.bold16.copyWith(
            color: AppColors.black,
            fontSize: 18,
          ),
        ),
      ),
      body: StudentExamDetailsViewBody(
        exam: exam,
      ),
      bottomNavigationBar: exam.mySubmission != null
          ? null
          : SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: ElevatedButton.icon(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.secondaryColor,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 0,
                  ),
                  icon: const SizedBox.shrink(),
                  label: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Submit Exam',
                        style: AppTextStyle.bold16.copyWith(color: Colors.white),
                      ),
                      const SizedBox(width: 8),
                      const Icon(Icons.send_rounded,
                          color: Colors.white, size: 20),
                    ],
                  ),
                ),
              ),
            ),
    );
  }
}
