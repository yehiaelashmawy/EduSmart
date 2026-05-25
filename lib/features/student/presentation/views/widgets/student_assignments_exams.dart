import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:school_system/core/utils/app_colors.dart';
import 'package:school_system/features/student/presentation/manager/student_exams_cubit/student_exams_cubit.dart';
import 'package:school_system/features/student/presentation/manager/student_exams_cubit/student_exams_state.dart';
import 'package:school_system/features/student/presentation/manager/student_homework_cubit/student_homework_cubit.dart';
import 'package:school_system/features/student/presentation/manager/student_homework_cubit/student_homework_state.dart';
import 'package:school_system/core/helper/localization_helper.dart';

class StudentAssignmentsExams extends StatelessWidget {
  const StudentAssignmentsExams({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<StudentHomeworkCubit, StudentHomeworkState>(
      builder: (context, homeworkState) {
        return BlocBuilder<StudentExamsCubit, StudentExamsState>(
          builder: (context, examState) {
            final isLoading =
                homeworkState is StudentHomeworkLoading ||
                examState is StudentExamsLoading;

            return Skeletonizer(
              enabled: isLoading,
              child: Row(
                children: [
                  Expanded(child: _buildAssignmentCard(homeworkState)),
                  const SizedBox(width: 16),
                  Expanded(child: _buildExamCard(examState)),
                ],
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildAssignmentCard(StudentHomeworkState state) {
    String task = LocalizationHelper.isArabic ? 'لا توجد واجبات' : 'No assignments';
    String date = LocalizationHelper.isArabic ? 'مكتمل الكل' : 'ALL CLEAR';
    Color color = AppColors.grey;

    if (state is StudentHomeworkSuccess) {
      final pendingHomeworks =
          state.data.homeworks
              ?.where((h) => h.status?.toLowerCase() == 'pending')
              .toList() ??
          [];

      if (pendingHomeworks.isNotEmpty) {
        // Sort by due date
        pendingHomeworks.sort((a, b) {
          final dateA = DateTime.tryParse(a.dueDate ?? '') ?? DateTime(2099);
          final dateB = DateTime.tryParse(b.dueDate ?? '') ?? DateTime(2099);
          return dateA.compareTo(dateB);
        });

        final next = pendingHomeworks.first;
        task = next.title ?? (LocalizationHelper.isArabic ? 'واجب منزلي' : 'Assignment');
        date = _formatDate(next.dueDate);
        color = Colors.red;
      }
    } else if (state is StudentHomeworkLoading) {
      task = LocalizationHelper.isArabic ? 'جاري تحميل الواجب...' : 'Loading task...';
      date = LocalizationHelper.isArabic ? 'التاريخ' : 'DATE';
    }

    return _TaskCard(
      title: LocalizationHelper.isArabic ? 'الواجبات' : 'ASSIGNMENTS',
      date: date.toUpperCase(),
      task: task,
      dotColor: color,
    );
  }

  Widget _buildExamCard(StudentExamsState state) {
    String task = LocalizationHelper.isArabic ? 'لا توجد اختبارات' : 'No exams';
    String date = LocalizationHelper.isArabic ? 'مكتمل الكل' : 'ALL CLEAR';
    Color color = AppColors.grey;

    if (state is StudentExamsSuccess) {
      final upcomingExams = state.exams
          .where((e) => e.mySubmission == null)
          .toList();

      if (upcomingExams.isNotEmpty) {
        // Sort by date
        upcomingExams.sort((a, b) {
          final dateA = DateTime.tryParse(a.date ?? '') ?? DateTime(2099);
          final dateB = DateTime.tryParse(b.date ?? '') ?? DateTime(2099);
          return dateA.compareTo(dateB);
        });

        final next = upcomingExams.first;
        task = next.name ?? (LocalizationHelper.isArabic ? 'اختبار' : 'Exam');
        date = _formatDate(next.date);
        color = AppColors.primaryColor;
      }
    } else if (state is StudentExamsLoading) {
      task = LocalizationHelper.isArabic ? 'جاري تحميل الاختبار...' : 'Loading exam...';
      date = LocalizationHelper.isArabic ? 'التاريخ' : 'DATE';
    }

    return _TaskCard(
      title: LocalizationHelper.isArabic ? 'الاختبارات' : 'EXAMS',
      date: date.toUpperCase(),
      task: task,
      dotColor: color,
    );
  }

  String _formatDate(String? dateStr) {
    if (dateStr == null) return 'N/A';
    try {
      final date = DateTime.parse(dateStr);
      final now = DateTime.now();
      final today = DateTime(now.year, now.month, now.day);
      final diff = date.difference(today).inDays;

      if (diff == 0) return LocalizationHelper.isArabic ? 'اليوم' : 'TODAY';
      if (diff == 1) return LocalizationHelper.isArabic ? 'غداً' : 'TOMORROW';
      if (diff > 1 && diff < 7) {
        final dayName = DateFormat('EEEE').format(date);
        if (LocalizationHelper.isArabic) {
          switch (dayName.toLowerCase()) {
            case 'monday': return 'الإثنين';
            case 'tuesday': return 'الثلاثاء';
            case 'wednesday': return 'الأربعاء';
            case 'thursday': return 'الخميس';
            case 'friday': return 'الجمعة';
            case 'saturday': return 'السبت';
            case 'sunday': return 'الأحد';
          }
        }
        return dayName;
      }
      return DateFormat('MMM dd').format(date);
    } catch (e) {
      return dateStr;
    }
  }
}

class _TaskCard extends StatelessWidget {
  final String title;
  final String date;
  final String task;
  final Color dotColor;

  const _TaskCard({
    required this.title,
    required this.date,
    required this.task,
    required this.dotColor,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: 10,
            fontWeight: FontWeight.bold,
            color: AppColors.grey,
            letterSpacing: 1,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          height: 100, // Fixed height for alignment
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: AppColors.lightGrey.withValues(alpha: 0.3),
            ),
            boxShadow: [
              BoxShadow(
                color: AppColors.black.withValues(alpha: 0.02),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    width: 8,
                    height: 8,
                    decoration: BoxDecoration(
                      color: dotColor,
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      date,
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                        color: dotColor,
                        letterSpacing: 0.5,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Expanded(
                child: Text(
                  task,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: AppColors.darkBlue,
                    height: 1.2,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
