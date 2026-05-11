import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:school_system/core/api/api_service.dart';
import 'package:school_system/core/utils/app_colors.dart';
import 'package:school_system/core/utils/app_text_style.dart';
import 'package:school_system/core/widgets/custom_snack_bar.dart';
import 'package:school_system/features/teacher/data/models/submission_model.dart';
import 'package:school_system/features/teacher/data/repos/submissions_repo.dart';
import 'package:school_system/features/teacher/presentation/manager/submissions_cubit/submissions_cubit.dart';
import 'package:school_system/features/teacher/presentation/views/widgets/review_submissions_view_body.dart';

import 'package:open_filex/open_filex.dart';
import 'package:school_system/core/utils/pdf_generator.dart';
import 'package:school_system/features/teacher/data/models/teacher_class_model.dart';

class ReviewSubmissionsView extends StatelessWidget {
  final String homeworkId;
  final String homeworkTitle;
  final String? subtitle;
  final List<TeacherStudentModel> classStudents;
  final bool isExam;
  final double? totalMarks;

  const ReviewSubmissionsView({
    super.key,
    required this.homeworkId,
    this.homeworkTitle = 'Submissions',
    this.subtitle,
    this.classStudents = const [],
    this.isExam = false,
    this.totalMarks,
  });

  static const String routeName = '/review_submissions';

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => SubmissionsCubit(
        repo: SubmissionsRepo(ApiService()),
        homeworkId: homeworkId,
        isExam: isExam,
        totalMarks: totalMarks,
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
            actions: [
              BlocBuilder<SubmissionsCubit, SubmissionsState>(
                builder: (context, state) {
                  List<SubmissionModel> currentSubmissions = [];
                  if (state is SubmissionsSuccess) {
                    currentSubmissions = state.submissions;
                  }
                  if (state is GradeSuccess) {
                    currentSubmissions = state.submissions;
                  }
                  if (state is GradeFailure) {
                    currentSubmissions = state.submissions;
                  }

                  if (currentSubmissions.isEmpty) {
                    return const SizedBox.shrink();
                  }

                  return IconButton(
                    icon: Icon(Icons.download_outlined,
                        color: AppColors.primaryColor),
                    onPressed: () async {
                      // Merge API submissions with class students for the PDF
                      final mergedSubmissions = <SubmissionModel>[];
                      for (final student in classStudents) {
                        final existing = currentSubmissions.where((s) =>
                            s.studentEmail.toLowerCase() ==
                                student.email.toLowerCase() ||
                            s.studentName.toLowerCase() ==
                                student.fullName.toLowerCase());

                        if (existing.isNotEmpty) {
                          mergedSubmissions.add(existing.first);
                        } else {
                          mergedSubmissions.add(
                            SubmissionModel(
                              id: student.oid,
                              studentName: student.fullName,
                              studentEmail: student.email,
                              content: '',
                              status: 'NotSubmitted',
                              submittedAt: '',
                              isLate: false,
                            ),
                          );
                        }
                      }

                      // Add any extra submissions not in the roster
                      for (final s in currentSubmissions) {
                        if (!mergedSubmissions.any((ms) =>
                            ms.id == s.id || ms.studentEmail == s.studentEmail)) {
                          mergedSubmissions.add(s);
                        }
                      }

                      final finalData = mergedSubmissions.isEmpty
                          ? currentSubmissions
                          : mergedSubmissions;

                      final path = await PdfGenerator.generateSubmissionsPdf(
                        title: homeworkTitle,
                        subtitle: subtitle,
                        submissions: finalData,
                      );
                      await OpenFilex.open(path);
                    },
                  );
                },
              ),
              const SizedBox(width: 8),
            ],
          ),
          body: ReviewSubmissionsViewBody(classStudents: classStudents),
        ),
      ),
    );
  }
}
