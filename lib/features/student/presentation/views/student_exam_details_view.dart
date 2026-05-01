import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:school_system/core/api/api_service.dart';
import 'package:school_system/core/utils/app_colors.dart';
import 'package:school_system/core/utils/app_text_style.dart';
import 'package:school_system/features/student/data/models/student_exam_model.dart';
import 'package:school_system/features/student/data/repos/student_submit_exam_repo.dart';
import 'package:school_system/features/student/presentation/manager/student_exams_cubit/student_exams_cubit.dart';
import 'package:school_system/features/student/presentation/manager/student_submit_exam_cubit/student_submit_exam_cubit.dart';
import 'package:school_system/features/student/presentation/views/widgets/student_exam_details_view_body.dart';

class StudentExamDetailsArgs {
  final StudentExamModel exam;
  final StudentExamsCubit examsCubit;

  StudentExamDetailsArgs({
    required this.exam,
    required this.examsCubit,
  });
}

class StudentExamDetailsView extends StatelessWidget {
  static const String routeName = 'student_exam_details_view';

  final StudentExamModel exam;
  final StudentExamsCubit examsCubit;

  const StudentExamDetailsView({
    super.key,
    required this.exam,
    required this.examsCubit,
  });

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider.value(value: examsCubit),
        BlocProvider(
          create: (context) =>
              StudentSubmitExamCubit(StudentSubmitExamRepo(ApiService())),
        ),
      ],
      child: Scaffold(
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
      ),
    );
  }
}
