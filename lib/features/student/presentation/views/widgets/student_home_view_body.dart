import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:school_system/core/api/api_service.dart';
import 'package:school_system/features/student/data/repos/student_weekly_schedule_repo.dart';
import 'package:school_system/features/student/presentation/manager/student_weekly_schedule_cubit/student_weekly_schedule_cubit.dart';
import 'package:school_system/features/student/presentation/views/widgets/next_class_card.dart';
import 'package:school_system/features/student/presentation/views/widgets/smart_tutor_banner.dart';
import 'package:school_system/features/student/presentation/views/widgets/student_assignments_exams.dart';
import 'package:school_system/features/student/presentation/views/widgets/student_home_action_cards.dart';
import 'package:school_system/features/student/presentation/views/widgets/student_home_header.dart';
import 'package:school_system/features/student/presentation/views/widgets/student_today_schedule.dart';

class StudentHomeViewBody extends StatelessWidget {
  const StudentHomeViewBody({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => StudentWeeklyScheduleCubit(
        StudentWeeklyScheduleRepo(ApiService()),
      )..fetchWeeklySchedule(),
      child: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const StudentHomeHeader(),
              const SizedBox(height: 24),
              const StudentHomeActionCards(),
              const SizedBox(height: 20),
              const SmartTutorBanner(),
              const SizedBox(height: 24),
              const NextClassCard(),
              const SizedBox(height: 32),
              const StudentTodaySchedule(),
              const SizedBox(height: 32),
              const StudentAssignmentsExams(),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}
