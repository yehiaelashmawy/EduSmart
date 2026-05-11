import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:school_system/core/api/api_service.dart';
import 'package:school_system/core/utils/app_colors.dart';
import 'package:school_system/features/student/data/repos/student_grades_repo.dart';
import 'package:school_system/features/student/presentation/manager/student_grades_cubit/student_grades_cubit.dart';
import 'package:school_system/features/student/presentation/manager/student_grades_cubit/student_grades_state.dart';
import 'package:school_system/features/student/presentation/manager/student_homework_cubit/student_homework_cubit.dart';
import 'package:school_system/features/student/presentation/manager/student_homework_cubit/student_homework_state.dart';

class StudentHomeActionCards extends StatelessWidget {
  const StudentHomeActionCards({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => StudentGradesCubit(
        StudentGradesRepo(ApiService()),
      )..fetchGradesDashboard(),
      child: Row(
        children: [
          Expanded(
            child: GestureDetector(
              onTap: () {
                Navigator.pushNamed(context, 'student_homework_view');
              },
              child: BlocBuilder<StudentHomeworkCubit, StudentHomeworkState>(
                builder: (context, state) {
                  String subtitle = 'Loading...';
                  bool isLoading = state is StudentHomeworkLoading || state is StudentHomeworkInitial;

                  if (state is StudentHomeworkSuccess) {
                    final pending = state.data.stats?.pending ?? 0;
                    subtitle = '$pending Pending Tasks';
                  } else if (state is StudentHomeworkFailure) {
                    subtitle = 'Failed to load';
                  }

                  return Skeletonizer(
                    enabled: isLoading,
                    child: _ActionCard(
                      title: 'Homework',
                      subtitle: subtitle,
                      icon: Icons.assignment,
                    ),
                  );
                },
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: GestureDetector(
              onTap: () {
                Navigator.pushNamed(context, 'student_grades_view');
              },
              child: BlocBuilder<StudentGradesCubit, StudentGradesState>(
                builder: (context, state) {
                  String subtitle = 'Loading...';
                  bool isLoading = state is StudentGradesLoading || state is StudentGradesInitial;

                  if (state is StudentGradesSuccess) {
                    final gpa = state.data.overallGPA?.gpa ?? 0.0;
                    final grade = state.data.overallGPA?.overallGrade ?? 0.0;
                    subtitle = 'GPA: ${gpa.toStringAsFixed(1)} | Grade: ${grade.toStringAsFixed(0)}%';
                  } else if (state is StudentGradesFailure) {
                    subtitle = 'Failed to load';
                  }

                  return Skeletonizer(
                    enabled: isLoading,
                    child: _ActionCard(
                      title: 'My Grades',
                      subtitle: subtitle,
                      icon: Icons.bar_chart,
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ActionCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;

  const _ActionCard({
    required this.title,
    required this.subtitle,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.lightGrey.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: AppColors.white,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: AppColors.primaryColor),
          ),
          const SizedBox(height: 16),
          Text(
            title,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: AppColors.darkBlue,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            subtitle,
            style: TextStyle(
              fontSize: 12,
              color: AppColors.grey,
            ),
          ),
        ],
      ),
    );
  }
}
