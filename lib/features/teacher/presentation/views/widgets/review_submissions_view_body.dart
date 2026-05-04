import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:school_system/core/utils/app_colors.dart';
import 'package:school_system/core/utils/app_text_style.dart';
import 'package:school_system/features/teacher/data/models/submission_model.dart';
import 'package:school_system/features/teacher/presentation/manager/submissions_cubit/submissions_cubit.dart';
import 'package:school_system/features/teacher/presentation/views/grade_submission_view.dart';
import 'package:school_system/features/teacher/presentation/views/widgets/submission_item_card.dart';
import 'package:school_system/features/teacher/data/models/teacher_class_model.dart';

class ReviewSubmissionsViewBody extends StatelessWidget {
  final List<TeacherStudentModel> classStudents;

  const ReviewSubmissionsViewBody({super.key, this.classStudents = const []});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SubmissionsCubit, SubmissionsState>(
      builder: (context, state) {
        // ── Loading ────────────────────────────────────────────────────────
        if (state is SubmissionsLoading) {
          return Center(
            child: CircularProgressIndicator(color: AppColors.primaryColor),
          );
        }

        // ── Error ──────────────────────────────────────────────────────────
        if (state is SubmissionsFailure) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.error_outline,
                      size: 48, color: AppColors.grey.withValues(alpha: 0.5)),
                  const SizedBox(height: 16),
                  Text(
                    state.errorMessage,
                    textAlign: TextAlign.center,
                    style:
                        AppTextStyle.regular14.copyWith(color: AppColors.grey),
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton.icon(
                    onPressed: () =>
                        context.read<SubmissionsCubit>().fetchSubmissions(),
                    icon: const Icon(Icons.refresh, color: Colors.white),
                    label: const Text('Retry',
                        style: TextStyle(color: Colors.white)),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primaryColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        }

        // ── Data (Success / GradeSuccess / GradeFailure / GradeSubmitting) ─
        List<SubmissionModel> apiSubmissions = [];
        if (state is SubmissionsSuccess) apiSubmissions = state.submissions;
        if (state is GradeSuccess) apiSubmissions = state.submissions;
        if (state is GradeFailure) apiSubmissions = state.submissions;
        if (state is GradeSubmitting) {
          // keep last known list — we'll show a loading overlay handled by
          // GradeSubmissionView itself; here just fall through with empty.
          apiSubmissions = [];
        }

        // Merge API submissions with class students
        final mergedSubmissions = <SubmissionModel>[];
        for (final student in classStudents) {
          final existing = apiSubmissions.where(
              (s) => s.studentEmail.toLowerCase() == student.email.toLowerCase() || s.studentName.toLowerCase() == student.fullName.toLowerCase());
          
          if (existing.isNotEmpty) {
            mergedSubmissions.add(existing.first);
          } else {
            mergedSubmissions.add(
              SubmissionModel(
                id: student.oid,
                studentName: student.fullName,
                studentEmail: student.email,
                content: '',
                attachmentUrl: null,
                submittedAt: '',
                grade: null,
                feedback: null,
                status: 'NotSubmitted',
                isLate: false,
              ),
            );
          }
        }
        
        // If there are submissions from students not in classStudents, add them too
        for (final s in apiSubmissions) {
          if (!mergedSubmissions.any((ms) => ms.id == s.id || ms.studentEmail == s.studentEmail)) {
            mergedSubmissions.add(s);
          }
        }

        final submissions = mergedSubmissions.isEmpty && apiSubmissions.isNotEmpty ? apiSubmissions : mergedSubmissions;

        final submitted =
            submissions.where((s) => s.status != 'NotSubmitted').toList();
        final toGrade = submitted.where((s) => !s.isGraded).length;
        final gradedList = submitted.where((s) => s.isGraded).toList();
        final avgGrade = gradedList.isEmpty
            ? null
            : gradedList.map((s) => s.grade!).reduce((a, b) => a + b) /
                gradedList.length;

        return DefaultTabController(
          length: 2,
          child: Container(
            color: AppColors.backgroundColor,
            child: Column(
              children: [
                // ── Summary cards ──────────────────────────────────────────
                Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 16, vertical: 20),
                  child: Row(
                    children: [
                      _SummaryCard(
                        icon: Icons.bar_chart,
                        label: 'AVG SCORE',
                        value: avgGrade != null
                            ? avgGrade.toStringAsFixed(0)
                            : '--',
                        suffix: avgGrade != null ? '/100' : '',
                        color: AppColors.primaryColor,
                      ),
                      const SizedBox(width: 16),
                      _SummaryCard(
                        icon: Icons.inventory_2_outlined,
                        label: 'TO GRADE',
                        value: '$toGrade',
                        suffix: ' students',
                        color: const Color(0xFFF97316),
                      ),
                    ],
                  ),
                ),

                // ── Tabs ───────────────────────────────────────────────────
                TabBar(
                  labelColor: AppColors.secondaryColor,
                  unselectedLabelColor: AppColors.grey,
                  indicatorColor: AppColors.secondaryColor,
                  labelStyle: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                  unselectedLabelStyle: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                  indicatorWeight: 2,
                  dividerColor:
                      AppColors.lightGrey.withValues(alpha: 0.3),
                  tabs: [
                    Tab(text: 'All (${submissions.length})'),
                    Tab(text: 'Submitted (${submitted.length})'),
                  ],
                ),

                // ── Tab Views ──────────────────────────────────────────────
                Expanded(
                  child: TabBarView(
                    children: [
                      _SubmissionList(
                        submissions: submissions,
                        homeworkId:
                            context.read<SubmissionsCubit>().homeworkId,
                      ),
                      _SubmissionList(
                        submissions: submitted,
                        homeworkId:
                            context.read<SubmissionsCubit>().homeworkId,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

// ─── Summary card ──────────────────────────────────────────────────────────────

class _SummaryCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final String suffix;
  final Color color;

  const _SummaryCard({
    required this.icon,
    required this.label,
    required this.value,
    required this.suffix,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
              color: AppColors.lightGrey.withValues(alpha: 0.3)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, size: 16, color: color),
                const SizedBox(width: 6),
                Text(
                  label,
                  style: TextStyle(
                    color: color,
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 0.5,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  value,
                  style: AppTextStyle.bold24
                      .copyWith(color: AppColors.black),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 4, left: 3),
                  child: Text(
                    suffix,
                    style: AppTextStyle.regular14
                        .copyWith(color: AppColors.grey),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

// ─── Submission list ────────────────────────────────────────────────────────────

class _SubmissionList extends StatelessWidget {
  final List<SubmissionModel> submissions;
  final String homeworkId;

  const _SubmissionList({
    required this.submissions,
    required this.homeworkId,
  });

  @override
  Widget build(BuildContext context) {
    if (submissions.isEmpty) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.inbox_outlined,
                size: 56, color: AppColors.grey.withValues(alpha: 0.4)),
            const SizedBox(height: 12),
            Text(
              'No submissions yet',
              style: AppTextStyle.semiBold16.copyWith(color: AppColors.grey),
            ),
          ],
        ),
      );
    }

    return ListView.separated(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
      itemCount: submissions.length,
      separatorBuilder: (_, __) => const SizedBox(height: 14),
      itemBuilder: (context, index) {
        final s = submissions[index];
        return SubmissionItemCard(
          submission: s,
          onGradeTap: () async {
            final cubit = context.read<SubmissionsCubit>();
            final refreshed = await Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => GradeSubmissionView(
                  submission: s,
                  homeworkId: homeworkId,
                  isExam: cubit.isExam,
                ),
              ),
            );
            if (refreshed == true && context.mounted) {
              context.read<SubmissionsCubit>().fetchSubmissions();
            }
          },
        );
      },
    );
  }
}
