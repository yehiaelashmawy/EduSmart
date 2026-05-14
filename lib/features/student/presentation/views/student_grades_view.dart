import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:intl/intl.dart';
import 'package:school_system/core/api/api_service.dart';
import 'package:school_system/core/utils/app_colors.dart';
import 'package:school_system/core/utils/app_text_style.dart';
import 'package:school_system/features/student/data/repos/student_grades_repo.dart';
import 'package:school_system/features/student/presentation/manager/student_grades_cubit/student_grades_cubit.dart';
import 'package:school_system/features/student/presentation/manager/student_grades_cubit/student_grades_state.dart';
import 'package:school_system/features/student/presentation/views/widgets/student_grade_assessment_card.dart';
import 'package:school_system/features/student/presentation/views/widgets/student_quarterly_projection_card.dart';

class StudentGradesView extends StatelessWidget {
  static const String routeName = 'student_grades_view';

  const StudentGradesView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          StudentGradesCubit(StudentGradesRepo(ApiService()))
            ..fetchGradesDashboard(),
      child: Scaffold(
        backgroundColor: AppColors.backgroundColor,
        appBar: AppBar(
          title: Text(
            'My Grades',
            style: AppTextStyle.bold16.copyWith(
              color: AppColors.black,
              fontSize: 18,
            ),
          ),
          backgroundColor: AppColors.backgroundColor,
          elevation: 0,
          scrolledUnderElevation: 0,
          centerTitle: false,
          leading: IconButton(
            icon: Icon(Icons.arrow_back, color: AppColors.secondaryColor),
            onPressed: () => Navigator.pop(context),
          ),
        ),
        body: SafeArea(
          child: BlocBuilder<StudentGradesCubit, StudentGradesState>(
            builder: (context, state) {
              if (state is StudentGradesLoading) {
                return Skeletonizer(
                  enabled: true,
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(24.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Text(
                          'Academic Performance',
                          style: AppTextStyle.bold24.copyWith(
                            color: AppColors.black,
                            fontSize: 26,
                          ),
                        ),
                        const SizedBox(height: 12),
                        Text(
                          'Loading detailed breakdown of your progress this term. Current Weighted Average: 90%',
                          style: AppTextStyle.medium14.copyWith(
                            color: AppColors.grey,
                          ),
                        ),
                        const SizedBox(height: 32),
                        Text(
                          'Graded Assessments',
                          style: AppTextStyle.bold16.copyWith(
                            color: AppColors.black,
                          ),
                        ),
                        const SizedBox(height: 16),
                        ...List.generate(
                          3,
                          (index) => StudentGradeAssessmentCard(
                            badgeText: 'LOADING',
                            badgeColor: AppColors.darkBlue,
                            badgeBackgroundColor: AppColors.lightGrey
                                .withValues(alpha: 0.2),
                            dateString: 'Completed Jan 01',
                            title: 'Loading Assignment Title',
                            grade: '90',
                            totalGrade: '100',
                            gradeColor: AppColors.secondaryColor,
                          ),
                        ),
                        const SizedBox(height: 16),
                        StudentQuarterlyProjectionCard(
                          statusMessage: 'Loading status',
                          examsCount: 0,
                          tasksCount: 3,
                          averagePercentage: 90,
                        ),
                      ],
                    ),
                  ),
                );
              }

              if (state is StudentGradesFailure) {
                return Center(
                  child: Padding(
                    padding: const EdgeInsets.all(24.0),
                    child: Text(
                      state.error.errorMessage,
                      textAlign: TextAlign.center,
                      style: AppTextStyle.medium16.copyWith(color: Colors.red),
                    ),
                  ),
                );
              }

              if (state is StudentGradesSuccess) {
                final data = state.data;
                final overallGpa = data.overallGPA?.gpa ?? 0.0;
                final overallGrade = data.overallGPA?.overallGrade ?? 0;

                // Collect all assessments across subjects
                final allAssessments = <Widget>[];
                for (var subject in data.subjectDetailedGrades) {
                  for (var assignment in subject.assignments) {
                    DateTime? dueDate;
                    String formattedDate = '';
                    if (assignment.dueDate.isNotEmpty) {
                      try {
                        dueDate = DateTime.parse(assignment.dueDate);
                        formattedDate = DateFormat(
                          'MMM dd, yyyy',
                        ).format(dueDate);
                      } catch (e) {
                        // ignore
                      }
                    }

                    allAssessments.add(
                      StudentGradeAssessmentCard(
                        badgeText: subject.subjectName.toUpperCase(),
                        badgeColor: AppColors.darkBlue,
                        badgeBackgroundColor: AppColors.lightGrey.withValues(
                          alpha: 0.2,
                        ),
                        dateString: dueDate != null ? 'Due $formattedDate' : '',
                        title: assignment.title,
                        grade: assignment.grade.toString(),
                        totalGrade: assignment.totalMarks.toString(),
                        gradeColor: AppColors.secondaryColor,
                      ),
                    );
                  }

                  for (var exam in subject.exams) {
                    DateTime? dueDate;
                    String formattedDate = '';
                    if (exam.dueDate.isNotEmpty) {
                      try {
                        dueDate = DateTime.parse(exam.dueDate);
                        formattedDate = DateFormat(
                          'MMM dd, yyyy',
                        ).format(dueDate);
                      } catch (e) {
                        // ignore
                      }
                    }

                    allAssessments.add(
                      StudentGradeAssessmentCard(
                        badgeText: '${subject.subjectName.toUpperCase()} EXAM',
                        badgeColor: Colors.orange,
                        badgeBackgroundColor: AppColors.white.withValues(
                          alpha: 0.2,
                        ),
                        dateString: dueDate != null
                            ? 'Completed $formattedDate'
                            : '',
                        title: exam.title,
                        grade: exam.grade.toString(),
                        totalGrade: exam.totalMarks.toString(),
                        gradeColor: Colors.orange,
                      ),
                    );
                  }
                }

                return SingleChildScrollView(
                  padding: const EdgeInsets.all(24.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text(
                        'Academic Performance',
                        style: AppTextStyle.bold24.copyWith(
                          color: AppColors.black,
                          fontSize: 26,
                        ),
                      ),
                      const SizedBox(height: 12),
                      RichText(
                        text: TextSpan(
                          style: AppTextStyle.medium14.copyWith(
                            color: AppColors.grey,
                            height: 1.5,
                          ),
                          children: [
                            const TextSpan(
                              text:
                                  'Detailed breakdown of your progress this term. Current Weighted Average: ',
                            ),
                            TextSpan(
                              text: '$overallGrade%',
                              style: AppTextStyle.bold14.copyWith(
                                color: AppColors.secondaryColor,
                              ),
                            ),
                            const TextSpan(text: ' (GPA: '),
                            TextSpan(
                              text: '$overallGpa',
                              style: AppTextStyle.bold14.copyWith(
                                color: AppColors.secondaryColor,
                              ),
                            ),
                            const TextSpan(text: ')'),
                          ],
                        ),
                      ),
                      const SizedBox(height: 32),
                      if (allAssessments.isNotEmpty) ...[
                        Text(
                          'Graded Assessments',
                          style: AppTextStyle.bold16.copyWith(
                            color: AppColors.black,
                          ),
                        ),
                        const SizedBox(height: 16),
                        ...allAssessments,
                        const SizedBox(height: 16),
                      ],
                      if (data.classRank != null)
                        StudentQuarterlyProjectionCard(
                          statusMessage: data.classRank!.text,
                          examsCount: 0, // Mock, or calculate
                          tasksCount: allAssessments.length,
                          averagePercentage: overallGrade,
                        ),
                    ],
                  ),
                );
              }

              return const SizedBox.shrink();
            },
          ),
        ),
      ),
    );
  }
}
