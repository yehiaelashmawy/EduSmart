import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:school_system/core/utils/app_colors.dart';
import 'package:school_system/core/utils/app_text_style.dart';
import 'package:school_system/features/teacher/data/models/teacher_class_model.dart';
import 'package:school_system/features/teacher/data/models/teacher_exam_model.dart';
import 'package:school_system/features/teacher/presentation/manager/exam_grading_cubit/exam_grading_cubit.dart';
import 'package:school_system/features/teacher/presentation/views/exam_grade_submission_view.dart';
import 'package:school_system/features/teacher/presentation/views/widgets/exam_submission_card.dart';
import 'package:school_system/features/teacher/data/models/exam_submission_model.dart';
import 'package:school_system/features/teacher/data/repos/teacher_exams_repo.dart';
import 'package:school_system/core/api/api_service.dart';
import 'package:school_system/core/widgets/custom_snack_bar.dart';
import 'package:open_filex/open_filex.dart';
import 'package:school_system/core/utils/pdf_generator.dart';

class ExamReviewSubmissionsView extends StatefulWidget {
  static const String routeName = '/exam-review-submissions';
  final TeacherExamModel exam;
  final List<TeacherStudentModel> classStudents;

  const ExamReviewSubmissionsView({
    super.key,
    required this.exam,
    this.classStudents = const [],
  });

  @override
  State<ExamReviewSubmissionsView> createState() =>
      _ExamReviewSubmissionsViewState();
}

class _ExamReviewSubmissionsViewState extends State<ExamReviewSubmissionsView>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  late TeacherExamModel _currentExam;

  @override
  void initState() {
    super.initState();
    _currentExam = widget.exam;
    _tabController = TabController(length: 3, vsync: this);
    _refreshExamDetails();
  }

  Future<void> _refreshExamDetails() async {
    final repo = TeacherExamsRepo(ApiService());
    final result = await repo.getExamDetails(widget.exam.oid);
    result.fold((failure) => null, (exam) {
      if (mounted) {
        setState(() => _currentExam = exam);
      }
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              _currentExam.name,
              style: AppTextStyle.bold16.copyWith(color: AppColors.black),
            ),
            const SizedBox(height: 4),
            Text(
              '${_currentExam.subjectName} • ${_currentExam.className}',
              style: AppTextStyle.regular12.copyWith(color: AppColors.grey),
            ),
          ],
        ),
        backgroundColor: AppColors.backgroundColor,
        elevation: 0,
        centerTitle: false,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: AppColors.primaryColor),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          BlocBuilder<ExamGradingCubit, ExamGradingState>(
            builder: (context, state) {
              List<ExamSubmissionModel> currentSubmissions = [];
              if (state is ExamGradingLoaded) {
                currentSubmissions = state.response.submissions;
              } else if (state is ExamGradingSubmitting) {
                currentSubmissions = state.response.submissions;
              } else if (state is ExamGradingSubmitSuccess) {
                currentSubmissions = state.response.submissions;
              }

              if (currentSubmissions.isEmpty) {
                return const SizedBox.shrink();
              }

              return IconButton(
                icon: Icon(
                  Icons.download_outlined,
                  color: AppColors.primaryColor,
                ),
                onPressed: () async {
                  try {
                    final path = await PdfGenerator.generateExamSubmissionsPdf(
                      title: _currentExam.name,
                      subtitle:
                          '${_currentExam.subjectName} • ${_currentExam.className}',
                      submissions: currentSubmissions,
                    );
                    await OpenFilex.open(path);
                  } catch (e) {
                    if (context.mounted) {
                      CustomSnackBar.showError(
                        context,
                        'Error generating PDF: $e',
                      );
                    }
                  }
                },
              );
            },
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: BlocBuilder<ExamGradingCubit, ExamGradingState>(
        builder: (context, state) {
          if (state is ExamGradingLoading) {
            return Skeletonizer(
              enabled: true,
              child: Column(
                children: [
                  // Mock Summary Bar
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: Row(
                      children: List.generate(
                        3,
                        (i) => Expanded(
                          child: Container(
                            height: 60,
                            margin: EdgeInsets.only(right: i == 2 ? 0 : 12),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  // Mock List
                  Expanded(
                    child: ListView.separated(
                      padding: const EdgeInsets.all(16),
                      itemCount: 6,
                      separatorBuilder: (_, _) => const SizedBox(height: 16),
                      itemBuilder: (context, index) => ExamSubmissionCard(
                        submission: ExamSubmissionModel(
                          submissionId: 'skeleton_$index',
                          studentId: 'skeleton_$index',
                          studentName: 'Student Name Placeholder',
                          submittedAt: '2026-01-01',
                          score: 0,
                          status: 'Pending',
                          isGraded: false,
                        ),
                        onTap: () {},
                      ),
                    ),
                  ),
                ],
              ),
            );
          }

          if (state is ExamGradingError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    state.message,
                    style: const TextStyle(color: Colors.red),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () => context
                        .read<ExamGradingCubit>()
                        .fetchSubmissions(classStudents: widget.classStudents),
                    child: const Text('Retry'),
                  ),
                ],
              ),
            );
          }

          if (state is ExamGradingLoaded ||
              state is ExamGradingSubmitting ||
              state is ExamGradingSubmitSuccess) {
            final ExamSubmissionsResponse response =
                (state is ExamGradingLoaded)
                ? state.response
                : (state is ExamGradingSubmitting)
                ? state.response
                : (state as ExamGradingSubmitSuccess).response;

            return Column(
              children: [
                // Summary Bar
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    children: [
                      _SummaryItem(
                        label: 'Total',
                        count: response.total,
                        color: AppColors.primaryColor,
                      ),
                      const SizedBox(width: 12),
                      _SummaryItem(
                        label: 'Graded',
                        count: response.graded,
                        color: const Color(0xFF10B981),
                      ),
                      const SizedBox(width: 12),
                      _SummaryItem(
                        label: 'Pending',
                        count: response.pending,
                        color: const Color(0xFFF59E0B),
                      ),
                    ],
                  ),
                ),

                // Filter Tabs
                TabBar(
                  controller: _tabController,
                  labelColor: AppColors.primaryColor,
                  unselectedLabelColor: AppColors.grey,
                  indicatorColor: AppColors.primaryColor,
                  tabs: const [
                    Tab(text: 'All'),
                    Tab(text: 'Pending'),
                    Tab(text: 'Graded'),
                  ],
                ),

                Expanded(
                  child: TabBarView(
                    controller: _tabController,
                    children: [
                      _buildList(response.submissions),
                      _buildList(
                        response.submissions
                            .where((ExamSubmissionModel s) => !s.isGraded)
                            .toList(),
                      ),
                      _buildList(
                        response.submissions
                            .where((ExamSubmissionModel s) => s.isGraded)
                            .toList(),
                      ),
                    ],
                  ),
                ),
              ],
            );
          }

          return const SizedBox.shrink();
        },
      ),
    );
  }

  Widget _buildList(List submissions) {
    if (submissions.isEmpty) {
      return const Center(child: Text('No submissions found'));
    }
    return ListView.separated(
      padding: const EdgeInsets.all(16),
      itemCount: submissions.length,
      separatorBuilder: (_, _) => const SizedBox(height: 16),
      itemBuilder: (context, index) {
        final submission = submissions[index];
        return ExamSubmissionCard(
          submission: submission,
          onTap: () async {
            if (submission.submittedAt.isEmpty ||
                submission.submissionId.startsWith('missing_')) {
              CustomSnackBar.showInfo(
                context,
                'This student has not submitted the exam yet.',
              );
              return;
            }
            final refresh = await Navigator.pushNamed(
              context,
              ExamGradeSubmissionView.routeName,
              arguments: {
                'submission': submission,
                'exam': _currentExam,
                'cubit': context.read<ExamGradingCubit>(),
              },
            );
            if (refresh == true && mounted) {
              // ignore: use_build_context_synchronously
              context.read<ExamGradingCubit>().fetchSubmissions(
                classStudents: widget.classStudents,
              );
            }
          },
        );
      },
    );
  }
}

class _SummaryItem extends StatelessWidget {
  final String label;
  final int count;
  final Color color;

  const _SummaryItem({
    required this.label,
    required this.count,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColors.lightGrey.withValues(alpha: 0.3)),
        ),
        child: Column(
          children: [
            Text(
              count.toString(),
              style: AppTextStyle.bold18.copyWith(color: color),
            ),
            Text(
              label,
              style: AppTextStyle.medium12.copyWith(color: AppColors.grey),
            ),
          ],
        ),
      ),
    );
  }
}
