import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:school_system/core/utils/app_colors.dart';
import 'package:school_system/core/utils/app_text_style.dart';
import 'package:school_system/features/teacher/presentation/manager/teacher_exams_cubit/teacher_exams_cubit.dart';
import 'package:school_system/features/teacher/presentation/manager/teacher_exams_cubit/teacher_exams_state.dart';

import 'package:school_system/features/teacher/data/models/teacher_class_model.dart';
import 'package:school_system/features/teacher/presentation/manager/teacher_classes_cubit/teacher_classes_cubit.dart';
import 'package:school_system/features/teacher/presentation/manager/teacher_classes_cubit/teacher_classes_state.dart';
import '../exam_results_view.dart';

class UpcomingExamsSection extends StatelessWidget {
  const UpcomingExamsSection({super.key});

  String _computeStatusText(String dateStr) {
    try {
      final examDate = DateTime.parse(dateStr);
      final now = DateTime.now();
      final diff = examDate
          .difference(DateTime(now.year, now.month, now.day))
          .inDays;
      if (diff < 0) return 'Past';
      if (diff == 0) return 'Today';
      if (diff == 1) return 'Tomorrow';
      return 'In $diff Days';
    } catch (_) {
      return '';
    }
  }

  Color _computeStatusColor(String dateStr) {
    try {
      final examDate = DateTime.parse(dateStr);
      final now = DateTime.now();
      final diff = examDate
          .difference(DateTime(now.year, now.month, now.day))
          .inDays;
      if (diff <= 2) return const Color(0xFFF97316); // Orange — urgent
      if (diff <= 5) return AppColors.primaryColor;
      return AppColors.grey;
    } catch (_) {
      return AppColors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Upcoming Exams', style: AppTextStyle.bold20),
        const SizedBox(height: 16),
        BlocBuilder<TeacherExamsCubit, TeacherExamsState>(
          builder: (context, state) {
            if (state is TeacherExamsLoading) {
              return Skeletonizer(
                enabled: true,
                child: Column(
                  children: List.generate(
                    3,
                    (i) => Padding(
                      padding: EdgeInsets.only(bottom: i == 2 ? 0 : 16),
                      child: _buildExamCard(
                        month: 'APR',
                        day: '20',
                        title: 'Midterm Examination',
                        subtitle: 'Grade 10 • 30 Students',
                        statusText: 'In 3 Days',
                        statusColor: AppColors.primaryColor,
                      ),
                    ),
                  ),
                ),
              );
            } else if (state is TeacherExamsFailure) {
              return Text(
                state.error.errorMessage,
                style: const TextStyle(color: Colors.red, fontSize: 13),
              );
            } else if (state is TeacherExamsSuccess) {
              if (state.exams.isEmpty) {
                return Text(
                  'No upcoming exams.',
                  style: AppTextStyle.regular14.copyWith(color: AppColors.grey),
                );
              }
              return Column(
                children: state.exams.asMap().entries.map((entry) {
                  final i = entry.key;
                  final exam = entry.value;

                  String month = '';
                  String day = '';
                  try {
                    final date = DateTime.parse(exam.date);
                    const months = [
                      'JAN',
                      'FEB',
                      'MAR',
                      'APR',
                      'MAY',
                      'JUN',
                      'JUL',
                      'AUG',
                      'SEP',
                      'OCT',
                      'NOV',
                      'DEC',
                    ];
                    month = months[date.month - 1];
                    day = date.day.toString();
                  } catch (_) {}

                  final classesState = context.watch<TeacherClassesCubit>().state;
                  List<TeacherStudentModel> classStudents = [];
                  if (classesState is TeacherClassesSuccess) {
                    // Try exact match first
                    var matchedClass = classesState.classes.where((c) => c.name == exam.className).toList();
                    
                    // Fallback: contains or startsWith
                    if (matchedClass.isEmpty) {
                      matchedClass = classesState.classes.where((c) => 
                        c.name.toLowerCase().contains(exam.className.toLowerCase()) || 
                        exam.className.toLowerCase().contains(c.name.toLowerCase())
                      ).toList();
                    }

                    if (matchedClass.isNotEmpty) {
                      classStudents = matchedClass.first.students;
                    }
                  }

                  return Column(
                    children: [
                      if (i > 0) const SizedBox(height: 16),
                      InkWell(
                        onTap: () async {
                          Navigator.of(
                            context,
                            rootNavigator: true,
                          ).pushNamed(
                            ExamResultsView.routeName,
                            arguments: {
                              'examId': exam.oid,
                              'examTitle': exam.name,
                              'classStudents': classStudents,
                              'isExam': true,
                            },
                          );
                        },
                        borderRadius: BorderRadius.circular(20),
                        child: _buildExamCard(
                          month: month,
                          day: day,
                          title: exam.name,
                          subtitle:
                              '${exam.className} • ${exam.studentsCount} Students',
                          statusText: _computeStatusText(exam.date),
                          statusColor: _computeStatusColor(exam.date),
                        ),
                      ),
                    ],
                  );
                }).toList(),
              );
            }
            return const SizedBox.shrink();
          },
        ),
      ],
    );
  }

  Widget _buildExamCard({
    required String month,
    required String day,
    required String title,
    required String subtitle,
    required String statusText,
    required Color statusColor,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.lightGrey.withValues(alpha: 0.4)),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: AppColors.primaryColor.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              children: [
                Text(
                  month,
                  style: AppTextStyle.semiBold14.copyWith(
                    color: AppColors.primaryColor,
                    fontSize: 12,
                  ),
                ),
                Text(
                  day,
                  style: AppTextStyle.bold20.copyWith(
                    color: AppColors.primaryColor,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: AppTextStyle.bold16),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: AppTextStyle.regular14.copyWith(
                    color: AppColors.grey,
                    fontSize: 13,
                  ),
                ),
              ],
            ),
          ),
          Text(
            statusText,
            style: AppTextStyle.bold14.copyWith(color: statusColor),
          ),
        ],
      ),
    );
  }
}
