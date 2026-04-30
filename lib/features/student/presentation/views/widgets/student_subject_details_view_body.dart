import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:school_system/core/api/api_service.dart';
import 'package:school_system/core/utils/app_text_style.dart';
import 'package:school_system/features/student/data/models/student_my_subjects_model.dart';
import 'package:school_system/features/student/data/models/student_subject_model.dart';
import 'package:school_system/features/student/data/repos/student_my_subjects_repo.dart';
import 'package:school_system/features/student/data/repos/student_homework_repo.dart';
import 'package:school_system/features/student/presentation/manager/student_subject_detail_cubit/student_subject_detail_cubit.dart';
import 'package:school_system/features/student/presentation/manager/student_subject_detail_cubit/student_subject_detail_state.dart';
import 'package:school_system/features/student/presentation/manager/student_homework_cubit/student_homework_cubit.dart';
import 'package:school_system/features/student/presentation/views/widgets/subject_details_hero_card.dart';
import 'package:school_system/features/student/presentation/views/widgets/subject_details_tabs.dart';
import 'package:school_system/features/student/presentation/views/widgets/subject_lessons_tab.dart';
import 'package:school_system/features/student/presentation/views/widgets/subject_homeworks_tab.dart';
import 'package:school_system/features/student/presentation/views/widgets/subject_exams_tab.dart';

class StudentSubjectDetailsViewBody extends StatefulWidget {
  final StudentSubjectModel subject;

  const StudentSubjectDetailsViewBody({super.key, required this.subject});

  @override
  State<StudentSubjectDetailsViewBody> createState() =>
      _StudentSubjectDetailsViewBodyState();
}

class _StudentSubjectDetailsViewBodyState
    extends State<StudentSubjectDetailsViewBody> {
  int _selectedTab = 0;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => StudentSubjectDetailCubit(
        StudentMySubjectsRepo(ApiService()),
      )..fetchSubjectDetail(widget.subject.oid),
      child: BlocBuilder<StudentSubjectDetailCubit, StudentSubjectDetailState>(
        builder: (context, state) {
          final isLoading = state is StudentSubjectDetailLoading ||
              state is StudentSubjectDetailInitial;

          StudentMySubjectDetail? detail;
          if (state is StudentSubjectDetailSuccess) {
            detail = state.data;
          }

          return ListView(
            padding: const EdgeInsets.all(24.0),
            children: [
              SubjectDetailsHeroCard(subject: widget.subject),
              const SizedBox(height: 32),
              SubjectDetailsTabs(
                selectedIndex: _selectedTab,
                onTabSelected: (index) =>
                    setState(() => _selectedTab = index),
              ),
              const SizedBox(height: 32),

              // ── Error banner ───────────────────────────────────────────
              if (state is StudentSubjectDetailFailure)
                Padding(
                  padding: const EdgeInsets.only(bottom: 16),
                  child: Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.red.withValues(alpha: 0.08),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.error_outline,
                            color: Colors.red, size: 18),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            state.error.errorMessage,
                            style: AppTextStyle.medium12
                                .copyWith(color: Colors.red),
                          ),
                        ),
                        TextButton(
                          onPressed: () => context
                              .read<StudentSubjectDetailCubit>()
                              .fetchSubjectDetail(widget.subject.oid),
                          child: const Text('Retry'),
                        ),
                      ],
                    ),
                  ),
                ),

              // ── Tab content ────────────────────────────────────────────
              if (_selectedTab == 0)
                SubjectLessonsTab(
                  lessons: detail?.lessons ?? [],
                  isLoading: isLoading,
                )
              else if (_selectedTab == 1)
                BlocProvider(
                  create: (context) => StudentHomeworkCubit(
                    StudentHomeworkRepo(ApiService()),
                  )..fetchHomeworks(),
                  child: SubjectHomeworksTab(
                    subjectName: widget.subject.subjectName,
                  ),
                )
              else if (_selectedTab == 2)
                SubjectExamsTab(
                  exams: detail?.exams ?? [],
                  isLoading: isLoading,
                ),

              const SizedBox(height: 24),
            ],
          );
        },
      ),
    );
  }
}
