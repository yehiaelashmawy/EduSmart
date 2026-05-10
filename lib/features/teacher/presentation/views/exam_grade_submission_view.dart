import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:school_system/core/utils/app_colors.dart';
import 'package:school_system/core/utils/app_text_style.dart';
import 'package:school_system/core/widgets/custom_snack_bar.dart';
import 'package:school_system/features/teacher/data/models/exam_submission_model.dart';
import 'package:school_system/features/teacher/data/models/teacher_exam_model.dart';
import 'package:school_system/features/teacher/presentation/manager/exam_grading_cubit/exam_grading_cubit.dart';
import 'package:school_system/features/teacher/presentation/views/widgets/lesson_file_card.dart';
import 'package:school_system/core/helper/file_helper.dart';
import 'package:school_system/core/helper/url_helper.dart';

class ExamGradeSubmissionView extends StatefulWidget {
  static const String routeName = '/exam-grade-submission';
  final ExamSubmissionModel submission;
  final TeacherExamModel exam;

  const ExamGradeSubmissionView({
    super.key,
    required this.submission,
    required this.exam,
  });

  @override
  State<ExamGradeSubmissionView> createState() => _ExamGradeSubmissionViewState();
}

class _ExamGradeSubmissionViewState extends State<ExamGradeSubmissionView> {
  late TextEditingController _scoreController;
  late TextEditingController _remarksController;
  late int _score;

  @override
  void initState() {
    super.initState();
    _score = widget.submission.score;
    _scoreController = TextEditingController(text: _score.toStringAsFixed(0));
    _remarksController = TextEditingController(text: widget.submission.feedback ?? '');
  }

  @override
  void dispose() {
    _scoreController.dispose();
    _remarksController.dispose();
    super.dispose();
  }

  void _updateScore(int value) {
    setState(() {
      _score = value.clamp(0, widget.exam.maxScore);
      _scoreController.text = _score.toString();
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<ExamGradingCubit, ExamGradingState>(
      listener: (context, state) {
        if (state is ExamGradingSubmitSuccess) {
          CustomSnackBar.showSuccess(context, 'Grade submitted for ${state.studentName}');
          Navigator.pop(context, true);
        } else if (state is ExamGradingSubmitError) {
          CustomSnackBar.showError(context, state.message);
        }
      },
      child: Scaffold(
        backgroundColor: AppColors.backgroundColor,
        appBar: AppBar(
          title: Text(
            widget.submission.studentName,
            style: AppTextStyle.bold18.copyWith(color: AppColors.black),
          ),
          backgroundColor: AppColors.backgroundColor,
          elevation: 0,
          leading: IconButton(
            icon: Icon(Icons.arrow_back, color: AppColors.primaryColor),
            onPressed: () => Navigator.pop(context),
          ),
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Student Answer
              Text('Student Answer', style: AppTextStyle.bold16),
              const SizedBox(height: 12),
              if ((widget.submission.answerText == null || widget.submission.answerText!.isEmpty) &&
                  widget.submission.attachmentUrl == null)
                Center(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 20),
                    child: Text('No answer submitted',
                        style: AppTextStyle.regular14.copyWith(color: AppColors.grey)),
                  ),
                ),

              if (widget.submission.answerText != null && widget.submission.answerText!.isNotEmpty) ...[
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: AppColors.white,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: AppColors.lightGrey.withValues(alpha: 0.3)),
                  ),
                  child: Text(
                    widget.submission.answerText!,
                    style: AppTextStyle.regular14.copyWith(color: AppColors.darkBlue),
                  ),
                ),
                if (widget.submission.attachmentUrl != null) const SizedBox(height: 16),
              ],

              if (widget.submission.attachmentUrl != null)
                LessonFileCard(
                  fileName: widget.submission.fileName ?? 'Attachment',
                  fileInfo: 'Exam Submission',
                  iconColor: const Color(0xFFEFF6FF),
                  iconData: Icons.description_outlined,
                  iconWidgetColor: const Color(0xFF3B82F6),
                  onTap: () async {
                    try {
                      final url = UrlHelper.getFullImageUrl(widget.submission.attachmentUrl!);
                      await FileHelper.downloadAndOpenFile(
                        url: url,
                        fileName: widget.submission.fileName ?? 'exam_file',
                      );
                    } catch (e) {
                      if (context.mounted) {
                        CustomSnackBar.showError(context, 'Error opening file');
                      }
                    }
                  },
                ),

              const SizedBox(height: 32),

              // Score Input
              Text('Score (max: ${widget.exam.maxScore})', style: AppTextStyle.bold16),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _ScoreButton(
                    icon: Icons.remove,
                    onTap: () => _updateScore(_score - 1),
                  ),
                  const SizedBox(width: 24),
                  SizedBox(
                    width: 80,
                    child: TextField(
                      controller: _scoreController,
                      textAlign: TextAlign.center,
                      keyboardType: TextInputType.number,
                      style: AppTextStyle.bold24.copyWith(color: AppColors.primaryColor),
                      decoration: const InputDecoration(border: InputBorder.none),
                      onChanged: (v) {
                        final val = int.tryParse(v);
                        if (val != null) setState(() => _score = val.clamp(0, widget.exam.maxScore));
                      },
                    ),
                  ),
                  const SizedBox(width: 24),
                  _ScoreButton(
                    icon: Icons.add,
                    onTap: () => _updateScore(_score + 1),
                  ),
                ],
              ),
              Slider(
                value: _score.clamp(0, widget.exam.maxScore).toDouble(),
                min: 0,
                max: widget.exam.maxScore.toDouble(),
                divisions: widget.exam.maxScore > 0 ? widget.exam.maxScore : 1,
                activeColor: AppColors.primaryColor,
                onChanged: (v) => _updateScore(v.toInt()),
              ),

              const SizedBox(height: 32),

              // Remarks
              Text('Remarks (Optional)', style: AppTextStyle.bold16),
              const SizedBox(height: 12),
              TextField(
                controller: _remarksController,
                maxLines: 4,
                decoration: InputDecoration(
                  hintText: 'Add feedback for the student...',
                  filled: true,
                  fillColor: AppColors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: AppColors.lightGrey.withValues(alpha: 0.3)),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: AppColors.lightGrey.withValues(alpha: 0.3)),
                  ),
                ),
              ),

              const SizedBox(height: 40),

              // Submit Button
              BlocBuilder<ExamGradingCubit, ExamGradingState>(
                builder: (context, state) {
                  final isSubmitting = state is ExamGradingSubmitting;
                  return SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: isSubmitting
                          ? null
                          : () {
                              context.read<ExamGradingCubit>().gradeStudent(
                                    studentId: widget.submission.studentId,
                                    studentName: widget.submission.studentName,
                                    score: _score,
                                    remarks: _remarksController.text.trim(),
                                  );
                            },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.secondaryColor,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                      ),
                      child: isSubmitting
                          ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                          : Text('Submit Grade', style: AppTextStyle.bold16.copyWith(color: Colors.white)),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ScoreButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;

  const _ScoreButton({required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: AppColors.primaryColor.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Icon(icon, color: AppColors.primaryColor),
      ),
    );
  }
}
