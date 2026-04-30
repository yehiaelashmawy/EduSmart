import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:intl/intl.dart';
import 'package:school_system/core/utils/app_colors.dart';
import 'package:school_system/core/utils/app_text_style.dart';
import 'package:school_system/features/student/presentation/manager/student_homework_cubit/student_homework_cubit.dart';
import 'package:school_system/features/student/presentation/manager/student_homework_cubit/student_homework_state.dart';
import 'package:school_system/features/student/presentation/views/widgets/student_assignment_item_card.dart';
import 'package:school_system/features/student/presentation/views/student_assignment_details_view.dart';

class StudentAssignmentsTab extends StatelessWidget {
  const StudentAssignmentsTab({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<StudentHomeworkCubit, StudentHomeworkState>(
      builder: (context, state) {
        if (state is StudentHomeworkLoading) {
          return Skeletonizer(
            enabled: true,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: List.generate(
                3,
                (index) => StudentAssignmentItemCard(
                  status: AssignmentStatus.notSubmitted,
                  title: 'Loading Assignment Title',
                  submittedDate: 'Loading Date',
                  isDueSoon: false,
                  description: 'Loading description...',
                  onViewDetails: () {},
                ),
              ),
            ),
          );
        } else if (state is StudentHomeworkFailure) {
          return Center(
            child: Text(
              state.error.errorMessage,
              style: AppTextStyle.medium16.copyWith(color: Colors.red),
            ),
          );
        } else if (state is StudentHomeworkSuccess) {
          final homeworks = state.data.homeworks ?? [];

          if (homeworks.isEmpty) {
            return Center(
              child: Text(
                'No homeworks found.',
                style: AppTextStyle.medium16.copyWith(color: AppColors.grey),
              ),
            );
          }

          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: homeworks.map((hw) {
              AssignmentStatus status = AssignmentStatus.notSubmitted;

              if (hw.grade != null || hw.status?.toLowerCase() == 'graded') {
                status = AssignmentStatus.graded;
              } else if (hw.status?.toLowerCase() == 'submitted') {
                status = AssignmentStatus.pendingReview;
              }

              DateTime? dueDate;
              String formattedDate = '';

              if (hw.dueDate != null) {
                try {
                  dueDate = DateTime.parse(hw.dueDate!);
                  formattedDate = DateFormat('MMM dd, yyyy').format(dueDate);
                } catch (e) {
                  // Ignore parsing error
                }
              }

              void navigateToDetails() {
                Navigator.pushNamed(
                  context,
                  StudentAssignmentDetailsView.routeName,
                  arguments: StudentAssignmentDetailsArgs(homework: hw),
                );
              }

              return StudentAssignmentItemCard(
                status: status,
                title: hw.title ?? 'No Title',
                submittedDate: (hw.isOverdue == true)
                    ? 'Late (Due $formattedDate)'
                    : (formattedDate.isNotEmpty
                        ? 'Due $formattedDate'
                        : 'No due date'),
                isDueSoon: hw.isOverdue == true,
                grade: hw.grade?.toString(),
                totalGrade: hw.totalMarks?.toString(),
                description: hw.description,
                filename: hw.attachmentUrl?.split('/').last,
                onViewDetails: navigateToDetails,
                onSubmitWork: navigateToDetails,
              );
            }).toList(),
          );
        }

        return const SizedBox();
      },
    );
  }
}
