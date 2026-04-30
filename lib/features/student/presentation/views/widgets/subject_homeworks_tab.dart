import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:school_system/core/utils/app_text_style.dart';
import 'package:school_system/features/student/data/models/student_homework_model.dart';
import 'package:school_system/features/student/presentation/manager/student_homework_cubit/student_homework_cubit.dart';
import 'package:school_system/features/student/presentation/manager/student_homework_cubit/student_homework_state.dart';
import 'package:school_system/features/student/presentation/views/student_assignment_details_view.dart';
import 'package:school_system/features/student/presentation/views/widgets/student_assignment_item_card.dart';
import 'package:school_system/features/student/presentation/views/widgets/subject_empty_state.dart';

class SubjectHomeworksTab extends StatelessWidget {
  final String subjectName;

  const SubjectHomeworksTab({super.key, required this.subjectName});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<StudentHomeworkCubit, StudentHomeworkState>(
      builder: (context, state) {
        if (state is StudentHomeworkLoading) {
          return Skeletonizer(
            enabled: true,
            child: Column(
              children: List.generate(
                2,
                (_) => StudentAssignmentItemCard(
                  status: AssignmentStatus.notSubmitted,
                  title: 'Loading Assignment Title',
                  submittedDate: 'Loading Date',
                  isDueSoon: false,
                  onViewDetails: () {},
                ),
              ),
            ),
          );
        }

        if (state is StudentHomeworkFailure) {
          return Center(
            child: Text(
              state.error.errorMessage,
              style: AppTextStyle.medium16.copyWith(color: Colors.red),
            ),
          );
        }

        if (state is StudentHomeworkSuccess) {
          final homeworks = (state.data.homeworks ?? [])
              .where(
                (hw) =>
                    hw.subjectName?.toLowerCase() == subjectName.toLowerCase(),
              )
              .toList();

          if (homeworks.isEmpty) {
            return const SubjectEmptyState(
              icon: Icons.assignment_outlined,
              message: 'No assignments for this subject yet.',
            );
          }

          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: homeworks.map((hw) => _buildCard(context, hw)).toList(),
          );
        }

        return const SizedBox();
      },
    );
  }

  Widget _buildCard(BuildContext context, StudentHomeworkItemModel hw) {
    AssignmentStatus status = AssignmentStatus.notSubmitted;
    if (hw.grade != null || hw.status?.toLowerCase() == 'graded') {
      status = AssignmentStatus.graded;
    } else if (hw.status?.toLowerCase() == 'submitted') {
      status = AssignmentStatus.pendingReview;
    }

    DateTime? dueDate;
    String dateStr = '';
    if (hw.dueDate != null) {
      try {
        dueDate = DateTime.parse(hw.dueDate!);
        dateStr = DateFormat('MMM dd, yyyy').format(dueDate);
      } catch (e) {
        // Ignore parsing error
      }
    }

    void navigateToDetails() {
      Navigator.pushNamed(
        context,
        StudentAssignmentDetailsView.routeName,
        arguments: StudentAssignmentDetailsArgs(
          homework: hw,
          homeworkCubit: context.read<StudentHomeworkCubit>(),
        ),
      );
    }

    return StudentAssignmentItemCard(
      status: status,
      title: hw.title ?? 'No Title',
      submittedDate: (hw.isOverdue == true)
          ? 'Late (Due $dateStr)'
          : (dateStr.isNotEmpty ? 'Due $dateStr' : 'No due date'),
      isDueSoon: hw.isOverdue == true,
      grade: hw.grade?.toString(),
      totalGrade: hw.totalMarks?.toString(),
      description: hw.description,
      filename: hw.attachmentUrl?.split('/').last,
      onViewDetails: navigateToDetails,
      onSubmitWork: navigateToDetails,
    );
  }
}
