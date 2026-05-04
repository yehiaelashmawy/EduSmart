import 'package:flutter/material.dart';
import 'package:school_system/core/api/api_service.dart';
import 'package:school_system/core/utils/app_colors.dart';
import 'package:school_system/core/utils/app_text_style.dart';
import 'package:school_system/core/widgets/custom_snack_bar.dart';
import 'package:school_system/features/teacher/data/models/submission_model.dart';
import 'package:school_system/features/teacher/data/repos/submissions_repo.dart';
import 'package:school_system/features/teacher/presentation/manager/submissions_cubit/submissions_cubit.dart';
import 'package:school_system/features/teacher/presentation/views/widgets/custom_text_field.dart';
import 'package:school_system/features/teacher/presentation/views/widgets/lesson_file_card.dart';

class GradeSubmissionViewBody extends StatefulWidget {
  final SubmissionModel submission;
  final String homeworkId;

  const GradeSubmissionViewBody({
    super.key,
    required this.submission,
    required this.homeworkId,
  });

  @override
  State<GradeSubmissionViewBody> createState() =>
      _GradeSubmissionViewBodyState();
}

class _GradeSubmissionViewBodyState extends State<GradeSubmissionViewBody> {
  late final TextEditingController _gradeController;
  late final TextEditingController _feedbackController;
  bool _notifyStudent = false;
  bool _isSubmitting = false;

  @override
  void initState() {
    super.initState();
    _gradeController = TextEditingController(
      text: widget.submission.grade?.toStringAsFixed(0) ?? '',
    );
    _feedbackController = TextEditingController(
      text: widget.submission.feedback ?? '',
    );
  }

  @override
  void dispose() {
    _gradeController.dispose();
    _feedbackController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    final gradeText = _gradeController.text.trim();
    final gradeValue = double.tryParse(gradeText);

    if (gradeValue == null || gradeValue < 0 || gradeValue > 100) {
      CustomSnackBar.showError(
        context,
        'Please enter a valid grade between 0 and 100.',
      );
      return;
    }

    setState(() => _isSubmitting = true);

    final repo = SubmissionsRepo(ApiService());
    final cubit = SubmissionsCubit(repo: repo, homeworkId: widget.homeworkId);

    await cubit.gradeSubmission(
      submissionId: widget.submission.id,
      grade: gradeValue,
      feedback: _feedbackController.text.trim().isEmpty
          ? null
          : _feedbackController.text.trim(),
    );

    if (!mounted) return;
    setState(() => _isSubmitting = false);

    final state = cubit.state;
    if (state is GradeSuccess) {
      CustomSnackBar.showSuccess(context, state.message);
      Navigator.pop(context, true); // signal caller to refresh
    } else if (state is GradeFailure) {
      CustomSnackBar.showError(context, state.errorMessage);
    }
  }

  @override
  Widget build(BuildContext context) {
    final hasAttachment = widget.submission.attachmentUrl != null;
    final fileName = hasAttachment
        ? widget.submission.attachmentUrl!.split('/').last
        : null;

    return Container(
      color: AppColors.backgroundColor,
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: ListView(
              children: [
                // ── Student content ──────────────────────────────────────
                Text(
                  'Submission Details',
                  style: AppTextStyle.bold18.copyWith(color: AppColors.black),
                ),
                const SizedBox(height: 16),

                if (widget.submission.content.isNotEmpty) ...[
                  Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: AppColors.white,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: AppColors.lightGrey.withValues(alpha: 0.4),
                      ),
                    ),
                    child: Text(
                      widget.submission.content,
                      style: AppTextStyle.regular14.copyWith(
                        color: AppColors.darkBlue,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                ],

                if (hasAttachment) ...[
                  LessonFileCard(
                    fileName: fileName!,
                    fileInfo: 'Submitted attachment',
                    iconColor: const Color(0xFFEFF6FF),
                    iconData: Icons.description_outlined,
                    iconWidgetColor: const Color(0xFF3B82F6),
                  ),
                  const SizedBox(height: 24),
                ] else if (widget.submission.content.isEmpty) ...[
                  Center(
                    child: Text(
                      'No content or attachment submitted.',
                      style: AppTextStyle.regular14.copyWith(
                        color: AppColors.grey,
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                ],

                // ── Grade field ──────────────────────────────────────────
                Text(
                  'Grade / Score (out of 100)',
                  style: AppTextStyle.bold14.copyWith(color: AppColors.black),
                ),
                const SizedBox(height: 12),
                CustomTextField(
                  hintText: 'e.g. 95',
                  controller: _gradeController,
                  keyboardType: TextInputType.number,
                  suffixIcon: Icon(
                    Icons.star_border,
                    color: AppColors.grey.withValues(alpha: 0.7),
                  ),
                ),
                const SizedBox(height: 24),

                // ── Feedback field ───────────────────────────────────────
                Text(
                  'Teacher Feedback',
                  style: AppTextStyle.bold14.copyWith(color: AppColors.black),
                ),
                const SizedBox(height: 12),
                CustomTextField(
                  hintText:
                      'Write constructive feedback for ${widget.submission.studentName}...',
                  controller: _feedbackController,
                  maxLines: 6,
                  minLines: 6,
                ),
                const SizedBox(height: 24),

                // ── Notify toggle ────────────────────────────────────────
                Row(
                  children: [
                    SizedBox(
                      width: 20,
                      height: 20,
                      child: Checkbox(
                        value: _notifyStudent,
                        onChanged: (v) =>
                            setState(() => _notifyStudent = v ?? false),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(4),
                        ),
                        activeColor: AppColors.primaryColor,
                        side: BorderSide(
                          color: AppColors.grey.withValues(alpha: 0.5),
                          width: 1.5,
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Text(
                      'Notify student immediately',
                      style: AppTextStyle.regular14.copyWith(
                        color: AppColors.grey.withValues(alpha: 0.8),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // ── Submit button ────────────────────────────────────────────────
          const SizedBox(height: 16),
          SafeArea(
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: _isSubmitting ? null : _submit,
                icon: _isSubmitting
                    ? const SizedBox(
                        width: 18,
                        height: 18,
                        child: CircularProgressIndicator(
                          color: Colors.white,
                          strokeWidth: 2,
                        ),
                      )
                    : const Icon(
                        Icons.send_outlined,
                        color: Colors.white,
                        size: 20,
                      ),
                label: Text(
                  _isSubmitting ? 'Submitting...' : 'Submit Grade',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.secondaryColor,
                  disabledBackgroundColor: AppColors.secondaryColor.withValues(
                    alpha: 0.6,
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  elevation: 0,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
