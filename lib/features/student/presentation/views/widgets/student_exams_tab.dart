import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:school_system/core/utils/app_colors.dart';
import 'package:school_system/core/utils/app_text_style.dart';
import 'package:school_system/features/student/data/models/student_exam_model.dart';
import 'package:school_system/features/student/presentation/manager/student_exams_cubit/student_exams_cubit.dart';
import 'package:school_system/features/student/presentation/manager/student_exams_cubit/student_exams_state.dart';
import 'package:school_system/features/student/presentation/views/widgets/student_exam_item_card.dart';
import 'package:school_system/features/student/presentation/views/student_exam_details_view.dart';
import 'package:school_system/features/student/presentation/views/widgets/subject_empty_state.dart';

class StudentExamsTab extends StatelessWidget {
  const StudentExamsTab({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<StudentExamsCubit, StudentExamsState>(
      builder: (context, state) {
        if (state is StudentExamsLoading || state is StudentExamsInitial) {
          return Skeletonizer(
            enabled: true,
            child: Column(
              children: List.generate(
                3,
                (_) => StudentExamItemCard(
                  iconData: Icons.calendar_today_outlined,
                  iconColor: AppColors.primaryColor,
                  iconBackgroundColor: AppColors.primaryColor.withValues(
                    alpha: 0.1,
                  ),
                  badgeText: 'UPCOMING',
                  badgeTextColor: AppColors.primaryColor,
                  badgeBackgroundColor: AppColors.primaryColor.withValues(
                    alpha: 0.1,
                  ),
                  title: 'Loading Exam Title',
                  subtitle: 'Loading exam details...',
                  bottomLabel: 'STATUS',
                  bottomValue: 'Upcoming',
                  bottomValueColor: AppColors.darkBlue,
                  isPrimaryButton: true,
                  onViewDetails: () {},
                ),
              ),
            ),
          );
        }

        if (state is StudentExamsFailure) {
          return Center(
            child: Text(
              state.error.errorMessage,
              style: AppTextStyle.medium16.copyWith(color: Colors.red),
            ),
          );
        }

        if (state is StudentExamsSuccess) {
          final exams = state.exams;

          if (exams.isEmpty) {
            return const SubjectEmptyState(
              icon: Icons.quiz_outlined,
              message: 'No exams scheduled yet.',
            );
          }

          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: exams.map((exam) => _buildCard(context, exam)).toList(),
          );
        }

        return const SizedBox();
      },
    );
  }

  Widget _buildCard(BuildContext context, StudentExamModel exam) {
    final isGraded = exam.mySubmission?.isGraded ?? false;
    final isSubmitted = exam.mySubmission?.status?.toLowerCase() == 'submitted';

    final IconData iconData;
    final Color iconColor;
    final Color iconBg;
    final String badgeText;
    final Color badgeTextColor;
    final Color badgeBg;
    final String bottomLabel;
    final String bottomValue;
    final Color bottomValueColor;
    final bool isPrimary;

    String formattedDate = '';
    if (exam.date != null) {
      try {
        final date = DateTime.parse(exam.date!);
        formattedDate = DateFormat('MMM dd, yyyy').format(date);
      } catch (e) {
        formattedDate = exam.date!;
      }
    }

    if (isGraded) {
      iconData = Icons.check_circle_outline;
      iconColor = AppColors.secondaryColor;
      iconBg = AppColors.primaryColor.withValues(alpha: 0.12);
      badgeText = 'GRADED';
      badgeTextColor = AppColors.secondaryColor;
      badgeBg = AppColors.primaryColor.withValues(alpha: 0.12);
      bottomLabel = 'FINAL GRADE';
      bottomValue =
          '${exam.mySubmission?.score?.toStringAsFixed(0)}/${exam.maxScore}';
      bottomValueColor = AppColors.secondaryColor;
      isPrimary = false;
    } else if (isSubmitted) {
      iconData = Icons.history;
      iconColor = const Color(0xffB42318);
      iconBg = const Color(0xffB42318).withValues(alpha: 0.1);
      badgeText = 'SUBMITTED';
      badgeTextColor = Colors.white;
      badgeBg = const Color(0xff7A271A);
      bottomLabel = 'STATUS';
      bottomValue = 'Awaiting Grade';
      bottomValueColor = AppColors.darkBlue;
      isPrimary = false;
    } else {
      iconData = Icons.calendar_today_outlined;
      iconColor = AppColors.primaryColor;
      iconBg = AppColors.primaryColor.withValues(alpha: 0.1);
      badgeText = formattedDate.isNotEmpty ? formattedDate : 'UPCOMING';
      badgeTextColor = Colors.white;
      badgeBg = AppColors.secondaryColor;
      bottomLabel = 'STATUS';
      bottomValue = exam.status ?? 'Active';
      bottomValueColor = AppColors.darkBlue;
      isPrimary = true;
    }

    return StudentExamItemCard(
      iconData: iconData,
      iconColor: iconColor,
      iconBackgroundColor: iconBg,
      badgeText: badgeText,
      badgeTextColor: badgeTextColor,
      badgeBackgroundColor: badgeBg,
      title: exam.name ?? 'Untitled Exam',
      subtitle:
          formattedDate.isNotEmpty ? 'Scheduled: $formattedDate' : 'Upcoming',
      bottomLabel: bottomLabel,
      bottomValue: bottomValue,
      bottomValueColor: bottomValueColor,
      isPrimaryButton: isPrimary,
      onViewDetails: () {
        Navigator.pushNamed(
          context,
          StudentExamDetailsView.routeName,
          arguments: StudentExamDetailsArgs(
            exam: exam,
            examsCubit: context.read<StudentExamsCubit>(),
          ),
        );
      },
    );
  }
}
