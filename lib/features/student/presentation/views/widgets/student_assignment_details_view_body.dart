import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:school_system/core/api/api_service.dart';
import 'package:school_system/core/helper/file_helper.dart';
import 'package:school_system/core/utils/app_colors.dart';
import 'package:school_system/core/utils/app_text_style.dart';
import 'package:school_system/features/student/data/models/student_homework_model.dart';
import 'package:school_system/features/student/data/repos/student_submit_homework_repo.dart';
import 'package:school_system/features/student/presentation/manager/student_submit_homework_cubit/student_submit_homework_cubit.dart';
import 'package:school_system/features/student/presentation/views/widgets/student_assignment_attached_materials.dart';
import 'package:school_system/features/student/presentation/views/widgets/student_assignment_details_description.dart';
import 'package:school_system/features/student/presentation/views/widgets/student_assignment_details_header.dart';
import 'package:school_system/features/student/presentation/views/widgets/student_assignment_graded_content.dart';
import 'package:school_system/features/student/presentation/views/widgets/student_assignment_pending_content.dart';
import 'package:school_system/features/student/presentation/views/widgets/student_assignment_submission_box.dart';
import 'package:school_system/features/student/presentation/views/widgets/student_assignment_teacher_instructions.dart';

class StudentAssignmentDetailsViewBody extends StatelessWidget {
  final StudentHomeworkItemModel homework;

  const StudentAssignmentDetailsViewBody({
    super.key,
    required this.homework,
  });

  @override
  Widget build(BuildContext context) {
    // Parse the due date
    DateTime? dueDateTime;
    if (homework.dueDate != null) {
      try {
        dueDateTime = DateTime.parse(homework.dueDate!);
      } catch (e) {
        // Fallback or handle error
      }
    }

    final String dueTime = dueDateTime != null ? DateFormat('hh:mm a').format(dueDateTime) : '--:--';
    final String dateDay = dueDateTime != null ? DateFormat('dd').format(dueDateTime) : '--';
    final String dateMonth = dueDateTime != null ? DateFormat('MMM').format(dueDateTime) : '---';

    final bool isGraded = homework.grade != null;
    final bool isSubmitted = homework.attachmentUrl != null && homework.attachmentUrl!.isNotEmpty;

    return BlocProvider(
      create: (context) => StudentSubmitHomeworkCubit(
        StudentSubmitHomeworkRepo(ApiService()),
      ),
      child: ListView(
        padding: const EdgeInsets.all(24.0),
        children: [
          StudentAssignmentDetailsHeader(
            subjectName: homework.subjectName ?? '',
            title: homework.title ?? '',
            dueTime: dueTime,
            points: homework.totalMarks?.toString() ?? '0',
            dateDay: dateDay,
            dateMonth: dateMonth,
          ),
          const SizedBox(height: 32),
          StudentAssignmentDetailsDescription(
            description: homework.description ?? 'No description provided.',
          ),
          const SizedBox(height: 24),
          StudentAssignmentTeacherInstructions(
            teacherName: homework.teacherName ?? 'Teacher',
            teacherInstructions: homework.description ?? 'Please follow the instructions provided in the description.',
          ),
          const SizedBox(height: 32),
          StudentAssignmentAttachedMaterials(
            materials: homework.materials ?? [],
          ),
          const SizedBox(height: 16),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 16),
            child: Divider(color: AppColors.lightGrey.withValues(alpha: 0.3)),
          ),
          // Submission Section
          Text(
            'Your Submission',
            style: AppTextStyle.bold16.copyWith(color: AppColors.darkBlue),
          ),
          const SizedBox(height: 16),
          if (isGraded) ...[
            StudentAssignmentGradedContent(
              grade: homework.grade?.toString(),
              totalGrade: homework.totalMarks?.toString(),
              feedback: 'Great work!', // Could be added to model if available
              statusColor: const Color(0xff12B76A),
            ),
            const SizedBox(height: 16),
            StudentAssignmentPendingContent(
              filename: homework.attachmentUrl?.split('/').last,
              onTap: () {
                FileHelper.downloadAndOpenFile(
                  url: homework.attachmentUrl!,
                  fileName: homework.attachmentUrl?.split('/').last ?? 'submission',
                );
              },
            ),
          ] else if (isSubmitted) ...[
            StudentAssignmentPendingContent(
              filename: homework.attachmentUrl?.split('/').last,
              onTap: () {
                FileHelper.downloadAndOpenFile(
                  url: homework.attachmentUrl!,
                  fileName: homework.attachmentUrl?.split('/').last ?? 'submission',
                );
              },
            ),
            const SizedBox(height: 16),
            // Optionally show submission box to allow updates if not overdue
            if (homework.isOverdue != true)
              StudentAssignmentSubmissionBox(
                homeworkId: homework.homeworkId ?? '',
              ),
          ] else ...[
            StudentAssignmentSubmissionBox(
              homeworkId: homework.homeworkId ?? '',
            ),
          ],
          
          const SizedBox(height: 32),
        ],
      ),
    );
  }
}
