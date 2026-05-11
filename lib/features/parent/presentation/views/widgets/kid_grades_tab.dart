import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:school_system/core/api/api_service.dart';
import 'package:school_system/features/parent/data/repos/parent_dashboard_repo.dart';
import 'package:school_system/features/parent/presentation/manager/child_grades_cubit/child_grades_cubit.dart';
import 'package:school_system/features/parent/presentation/manager/child_grades_cubit/child_grades_state.dart';
import 'package:school_system/features/parent/data/models/parent_grades_model.dart';
import 'package:school_system/features/parent/presentation/views/widgets/kid_subject_grade_card.dart';

class KidGradesTab extends StatelessWidget {
  final String? childId;
  const KidGradesTab({super.key, this.childId});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ChildGradesCubit(
        ParentDashboardRepo(ApiService()),
        childId: childId ?? '',
      )..fetchGrades(),
      child: const _KidGradesTabContent(),
    );
  }
}

class _KidGradesTabContent extends StatelessWidget {
  const _KidGradesTabContent();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ChildGradesCubit, ChildGradesState>(
      builder: (context, state) {
        if (state is ChildGradesLoading) {
          return _buildLoadingState();
        } else if (state is ChildGradesFailure) {
          return Center(child: Text(state.error.errorMessage));
        } else if (state is ChildGradesSuccess) {
          return _buildContent(state.data);
        }
        return const SizedBox.shrink();
      },
    );
  }

  Widget _buildLoadingState() {
    return Skeletonizer(
      enabled: true,
      child: _buildContent(
        ParentGradesModel(
          studentOid: '',
          studentName: 'Student Name',
          summary: GradeSummaryModel(
            gpa: 0,
            overallGrade: 0,
            letterGrade: 'A',
            classRank: 0,
            totalStudentsInClass: 0,
          ),
          gradeTrend: [],
          subjectPerformance: List.generate(
            2,
            (index) => SubjectPerformanceModel(
              subjectName: 'Subject Name',
              subjectAverage: 90,
              letterGrade: 'A',
              exams: [
                ExamGradeModel(examName: 'Exam Name', score: 90, maxScore: 100),
              ],
              assignments: [
                AssignmentGradeModel(
                  assignmentName: 'Assignment Name',
                  score: 95,
                  maxScore: 100,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildContent(ParentGradesModel data) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        children: [
          ...data.subjectPerformance.map(
            (subject) => Padding(
              padding: const EdgeInsets.only(bottom: 20),
              child: KidSubjectGradeCard(
                subject: subject.subjectName,
                percent: '${subject.subjectAverage.toInt()}%',
                letterGrade: subject.letterGrade,
                quizzes: subject.exams
                    .map(
                      (e) => {
                        'title': e.examName,
                        'date': 'Final Exam',
                        'percent': e.score.toInt(),
                      },
                    )
                    .toList(),
                assignments: subject.assignments
                    .map(
                      (a) => {
                        'title': a.assignmentName,
                        'date': 'Assignment',
                        'percent': a.score.toInt(),
                      },
                    )
                    .toList(),
              ),
            ),
          ),
          const SizedBox(height: 32),
        ],
      ),
    );
  }
}
