import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:school_system/core/utils/app_colors.dart';
import 'package:school_system/core/utils/app_text_style.dart';
import 'package:school_system/features/student/data/models/student_homework_model.dart';
import 'package:school_system/features/student/presentation/views/widgets/student_assignment_details_view_body.dart';

import 'package:school_system/features/student/presentation/manager/student_homework_cubit/student_homework_cubit.dart';

class StudentAssignmentDetailsArgs {
  final StudentHomeworkItemModel homework;
  final StudentHomeworkCubit homeworkCubit;

  StudentAssignmentDetailsArgs({
    required this.homework,
    required this.homeworkCubit,
  });
}

class StudentAssignmentDetailsView extends StatelessWidget {
  static const String routeName = 'student_assignment_details_view';

  final StudentHomeworkItemModel homework;
  final StudentHomeworkCubit homeworkCubit;

  const StudentAssignmentDetailsView({
    super.key,
    required this.homework,
    required this.homeworkCubit,
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
      body: BlocProvider.value(
        value: homeworkCubit,
        child: StudentAssignmentDetailsViewBody(homework: homework),
      ),
    );
  }
}
