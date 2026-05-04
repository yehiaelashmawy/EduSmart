import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:school_system/core/api/api_service.dart';
import 'package:school_system/core/utils/app_colors.dart';
import 'package:school_system/core/utils/app_text_style.dart';
import 'package:school_system/features/teacher/data/models/teacher_class_model.dart';
import 'package:school_system/features/teacher/data/repos/attendance_repo.dart';
import 'package:school_system/features/teacher/presentation/manager/attendance_report_cubit/attendance_report_cubit.dart';
import 'package:school_system/features/teacher/presentation/views/widgets/attendance_report_view_body.dart';

class AttendanceReportView extends StatelessWidget {
  static const String routeName = '/attendance_report_view';

  final TeacherClassModel teacherClass;

  const AttendanceReportView({super.key, required this.teacherClass});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          AttendanceReportCubit(AttendanceRepo(ApiService()))
            ..fetchClassStats(teacherClass.oid),
      child: Scaffold(
        backgroundColor: AppColors.backgroundColor,
        appBar: AppBar(
          title: Text(
            'Attendance Report',
            style: AppTextStyle.bold16.copyWith(
              color: AppColors.darkBlue,
              fontSize: 18,
            ),
          ),
          backgroundColor: AppColors.backgroundColor,
          elevation: 0,
          leading: IconButton(
            icon: Icon(Icons.arrow_back, color: AppColors.secondaryColor),
            onPressed: () => Navigator.pop(context),
          ),
          centerTitle: false,
        ),
        body: AttendanceReportViewBody(teacherClass: teacherClass),
      ),
    );
  }
}
