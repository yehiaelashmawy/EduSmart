import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:school_system/core/api/api_service.dart';
import 'package:school_system/core/utils/app_colors.dart';
import 'package:school_system/core/utils/app_text_style.dart';
import 'package:school_system/core/widgets/custom_snack_bar.dart';
import 'package:school_system/features/teacher/data/repos/submissions_repo.dart';
import 'package:school_system/features/teacher/presentation/manager/submissions_cubit/submissions_cubit.dart';
import 'package:school_system/features/teacher/presentation/views/widgets/review_submissions_view_body.dart';

import 'package:school_system/features/teacher/data/models/teacher_class_model.dart';

class ReviewSubmissionsView extends StatelessWidget {
  final String homeworkId;
  final String homeworkTitle;
  final String? subtitle;
  final List<TeacherStudentModel> classStudents;

  const ReviewSubmissionsView({
    super.key,
    required this.homeworkId,
    this.homeworkTitle = 'Submissions',
    this.subtitle,
    this.classStudents = const [],
  });

  static const String routeName = '/review_submissions';

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => SubmissionsCubit(
        repo: SubmissionsRepo(ApiService()),
        homeworkId: homeworkId,
      )..fetchSubmissions(),
      child: BlocListener<SubmissionsCubit, SubmissionsState>(
        listener: (context, state) {
          if (state is GradeSuccess) {
            CustomSnackBar.showSuccess(context, state.message);
          } else if (state is GradeFailure) {
            CustomSnackBar.showError(context, state.errorMessage);
          }
        },
        child: Scaffold(
          backgroundColor: AppColors.backgroundColor,
          appBar: AppBar(
            title: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  homeworkTitle,
                  style: AppTextStyle.bold16.copyWith(color: AppColors.black),
                ),
                if (subtitle != null) ...[
                  const SizedBox(height: 2),
                  Text(
                    subtitle!,
                    style:
                        AppTextStyle.regular12.copyWith(color: AppColors.grey),
                  ),
                ],
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
          body: ReviewSubmissionsViewBody(classStudents: classStudents),
        ),
      ),
    );
  }
}
