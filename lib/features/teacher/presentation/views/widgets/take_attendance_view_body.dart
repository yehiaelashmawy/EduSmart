import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:school_system/core/utils/app_colors.dart';
import 'package:school_system/core/utils/app_text_style.dart';
import 'package:school_system/features/teacher/data/models/teacher_class_model.dart';
import 'package:school_system/features/teacher/presentation/manager/teacher_classes_cubit/teacher_classes_cubit.dart';
import 'package:school_system/features/teacher/presentation/manager/teacher_classes_cubit/teacher_classes_state.dart';
import 'package:school_system/features/teacher/presentation/views/widgets/take_attendance_card.dart';
import 'package:school_system/features/teacher/presentation/views/attendance_report_view.dart';
import 'package:school_system/features/teacher/presentation/views/attendance_method_view.dart';

class TakeAttendanceViewBody extends StatelessWidget {
  const TakeAttendanceViewBody({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TeacherClassesCubit, TeacherClassesState>(
      builder: (context, state) {
        if (state is TeacherClassesLoading) {
          return Skeletonizer(
            enabled: true,
            child: _buildList(
              context,
              List.generate(
                3,
                (index) => TeacherClassModel(
                  oid: 'skeleton-$index',
                  name: 'Mathematics',
                  level: 'Grade 10-A',
                  createdAt: '',
                  studentsCount: 24,
                  sectionsCount: 1,
                ),
              ),
            ),
          );
        } else if (state is TeacherClassesFailure) {
          return Center(child: Text(state.error.errorMessage));
        } else if (state is TeacherClassesSuccess) {
          return _buildList(context, state.classes);
        }
        return const SizedBox.shrink();
      },
    );
  }

  Widget _buildList(BuildContext context, List<TeacherClassModel> classes) {
    return ListView(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
      children: [
        SafeArea(
          bottom: false,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Your Classes Today',
                style: AppTextStyle.bold24.copyWith(color: AppColors.black),
              ),
              const SizedBox(height: 4),
              Text(
                'Monday, Oct 24th',
                style: AppTextStyle.medium16.copyWith(color: AppColors.grey),
              ),
            ],
          ),
        ),
        const SizedBox(height: 24),
        ...classes.map((c) {
          final todayStr = DateTime.now().toIso8601String().split('T')[0];
          bool hasTakenToday = false;
          for (final student in c.students) {
            if (student.details.attendance.recentRecords
                .any((r) => r.date.startsWith(todayStr))) {
              hasTakenToday = true;
              break;
            }
          }

          return TakeAttendanceCard(
            imagePath: 'assets/images/lesson1.png',
            statusText: hasTakenToday ? 'ATTENDANCE TAKEN' : 'WITHOUT MARK',
            statusColor:
                hasTakenToday ? AppColors.secondaryColor : AppColors.grey,
            grade: c.level,
            subject: c.name,
            studentsCount: c.studentsCount,
            onViewReports: () {
              Navigator.of(
                context,
                rootNavigator: true,
              ).pushNamed(AttendanceReportView.routeName, arguments: c);
            },
            onTakeAttendance: () {
              Navigator.of(
                context,
                rootNavigator: true,
              ).pushNamed(AttendanceMethodView.routeName, arguments: c).then(
                (value) {
                  if (!context.mounted) return;
                  if (value == true) {
                    context.read<TeacherClassesCubit>().fetchClasses();
                  }
                },
              );
            },
          );
        }),
        const SizedBox(height: 24),
      ],
    );
  }
}
