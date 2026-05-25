import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:school_system/core/api/api_service.dart';
import 'package:school_system/core/utils/app_colors.dart';
import 'package:school_system/core/utils/app_text_style.dart';
import 'package:school_system/features/student/data/repos/student_weekly_schedule_repo.dart';
import 'package:school_system/features/student/presentation/manager/student_weekly_schedule_cubit/student_weekly_schedule_cubit.dart';
import 'package:school_system/features/student/presentation/views/widgets/weekly_schedule_view_body.dart';
import 'package:school_system/core/helper/localization_helper.dart';

class WeeklyScheduleView extends StatelessWidget {
  const WeeklyScheduleView({super.key});
  static const String routeName = 'weekly_schedule_view';

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => StudentWeeklyScheduleCubit(
        StudentWeeklyScheduleRepo(ApiService()),
      )..fetchWeeklySchedule(),
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
            'weekly_schedule'.tr(),
            style: AppTextStyle.bold16.copyWith(
              color: AppColors.darkBlue,
              fontSize: 18,
            ),
          ),
        ),
        body: const WeeklyScheduleViewBody(),
      ),
    );
  }
}

