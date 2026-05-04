import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:school_system/core/api/api_service.dart';
import 'package:school_system/core/utils/app_colors.dart';
import 'package:school_system/core/utils/app_text_style.dart';
import 'package:school_system/features/teacher/data/models/teacher_class_model.dart';
import 'package:school_system/features/teacher/data/repos/attendance_repo.dart';
import 'package:school_system/features/teacher/presentation/manager/start_attendance_cubit/start_attendance_cubit.dart';
import 'package:school_system/features/teacher/presentation/manager/teacher_classes_cubit/teacher_classes_cubit.dart';
import 'package:school_system/features/teacher/presentation/views/widgets/attendance_method_view_body.dart';

class AttendanceMethodViewArgs {
  final TeacherClassModel teacherClass;
  final String? lessonId;
  final TeacherClassesCubit? teacherClassesCubit;

  AttendanceMethodViewArgs({
    required this.teacherClass,
    this.lessonId,
    this.teacherClassesCubit,
  });
}

class AttendanceMethodView extends StatelessWidget {
  static const String routeName = '/attendance_method_view';

  final TeacherClassModel teacherClass;
  final String? lessonId;
  final TeacherClassesCubit? teacherClassesCubit;

  const AttendanceMethodView({
    super.key,
    required this.teacherClass,
    this.lessonId,
    this.teacherClassesCubit,
  });

  @override
  Widget build(BuildContext context) {
    Widget content = AttendanceMethodViewBody(
      teacherClass: teacherClass,
      lessonId: lessonId,
    );

    // If a cubit was passed (e.g. from a different navigator scope), provide it here
    if (teacherClassesCubit != null) {
      content = BlocProvider.value(
        value: teacherClassesCubit!,
        child: content,
      );
    }

    return BlocProvider(
      create: (context) => StartAttendanceCubit(AttendanceRepo(ApiService())),
      child: Scaffold(
        backgroundColor: AppColors.backgroundColor,
        appBar: AppBar(
          backgroundColor: AppColors.backgroundColor,
          elevation: 0,
          leading: IconButton(
            icon: Icon(Icons.arrow_back, color: AppColors.secondaryColor),
            onPressed: () => Navigator.pop(context),
          ),
          title: Text(
            'Select Attendance Method',
            style: AppTextStyle.bold16.copyWith(
              color: AppColors.darkBlue,
              fontSize: 18,
            ),
          ),
        ),
        body: content,
      ),
    );
  }
}
