import 'package:flutter/material.dart';
import 'package:school_system/core/utils/app_colors.dart';
import 'package:school_system/core/utils/app_text_style.dart';
import 'package:school_system/features/student/data/models/student_homework_model.dart';
import 'package:school_system/features/student/presentation/views/widgets/student_assignment_details_view_body.dart';

class StudentAssignmentDetailsArgs {
  final StudentHomeworkItemModel homework;

  StudentAssignmentDetailsArgs({
    required this.homework,
  });
}

class StudentAssignmentDetailsView extends StatelessWidget {
  static const String routeName = 'student_assignment_details_view';

  final StudentHomeworkItemModel homework;

  const StudentAssignmentDetailsView({
    super.key,
    required this.homework,
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
          'Assignment Details',
          style: AppTextStyle.bold16.copyWith(
            color: AppColors.black,
            fontSize: 18,
          ),
        ),
      ),
      body: StudentAssignmentDetailsViewBody(
        homework: homework,
      ),
    );
  }
}
