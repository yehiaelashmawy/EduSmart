import 'package:flutter/material.dart';
import 'package:school_system/core/utils/app_colors.dart';
import 'package:school_system/core/utils/app_text_style.dart';
import 'package:school_system/features/teacher/presentation/views/widgets/custom_text_field.dart';
import 'package:school_system/features/teacher/presentation/views/widgets/lesson_file_card.dart';

class GradeSubmissionViewBody extends StatefulWidget {
  const GradeSubmissionViewBody({super.key});

  @override
  State<GradeSubmissionViewBody> createState() =>
      _GradeSubmissionViewBodyState();
}

class _GradeSubmissionViewBodyState extends State<GradeSubmissionViewBody> {
  bool notifyStudent = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.backgroundColor,
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: ListView(
              children: [
                Text(
                  'Submission Details',
                  style: AppTextStyle.bold18.copyWith(color: AppColors.black),
                ),
                const SizedBox(height: 16),
                const LessonFileCard(
                  fileName: 'Homework_Essay_v1.pdf',
                  fileInfo: 'Submitted Oct 24, 10:20 AM',
                  iconColor: Color(0xFFEFF6FF),
                  iconData: Icons.description_outlined,
                  iconWidgetColor: Color(0xFF3B82F6),
                ),
                const SizedBox(height: 24),
                Text(
                  'Grade/Score',
                  style: AppTextStyle.bold14.copyWith(color: AppColors.black),
                ),
                const SizedBox(height: 12),
                CustomTextField(
                  hintText: 'e.g. 95/100',
                  suffixIcon: Icon(
                    Icons.star_border,
                    color: AppColors.grey.withValues(alpha: 0.7),
                  ),
                ),
                const SizedBox(height: 24),
                Text(
                  'Teacher Feedback',
                  style: AppTextStyle.bold14.copyWith(color: AppColors.black),
                ),
                const SizedBox(height: 12),
                const CustomTextField(
                  hintText:
                      'Write your constructive feedback here to help Alex improve...',
                  maxLines: 6,
                  minLines: 6,
                ),
                const SizedBox(height: 24),
                Row(
                  children: [
                    SizedBox(
                      width: 20,
                      height: 20,
                      child: Checkbox(
                        value: notifyStudent,
                        onChanged: (value) {
                          setState(() {
                            notifyStudent = value ?? false;
                          });
                        },
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
          const SizedBox(height: 16),
          SafeArea(
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () {},
                icon: const Icon(
                  Icons.send_outlined,
                  color: Colors.white,
                  size: 20,
                ),
                label: const Text(
                  'Submit Grade',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.secondaryColor,
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
