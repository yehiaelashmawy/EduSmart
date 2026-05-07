import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:school_system/core/api/api_service.dart';
import 'package:school_system/core/utils/app_colors.dart';
import 'package:school_system/core/utils/app_text_style.dart';
import 'package:school_system/features/student/data/repos/student_weekly_schedule_repo.dart';
import 'package:school_system/features/student/presentation/manager/student_weekly_schedule_cubit/student_weekly_schedule_cubit.dart';
import 'package:school_system/features/parent/presentation/views/widgets/parent_weekly_schedule_view_body.dart';

class ParentWeeklyScheduleView extends StatelessWidget {
  const ParentWeeklyScheduleView({super.key});
  static const String routeName = 'parent_weekly_schedule_view';

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => StudentWeeklyScheduleCubit(
        StudentWeeklyScheduleRepo(ApiService()),
      )..fetchWeeklySchedule(),
      child: Scaffold(
        backgroundColor: const Color(0xFFF8F9FE),
        appBar: AppBar(
          backgroundColor: const Color(0xFFF8F9FE),
          elevation: 0,
          leading: IconButton(
            icon: Icon(Icons.arrow_back, color: AppColors.primaryColor),
            onPressed: () => Navigator.pop(context),
          ),
          title: Text(
            'Child Schedule',
            style: AppTextStyle.bold18.copyWith(
              color: AppColors.darkBlue,
            ),
          ),
        ),
        body: const ParentWeeklyScheduleViewBody(),
      ),
    );
  }
}
