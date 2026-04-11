import 'package:flutter/material.dart';
import 'package:school_system/core/utils/app_colors.dart';
import 'package:school_system/core/utils/app_text_style.dart';
import 'package:school_system/features/student/presentation/views/widgets/student_grade_assessment_card.dart';
import 'package:school_system/features/student/presentation/views/widgets/student_quarterly_projection_card.dart';

class StudentGradesView extends StatelessWidget {
  static const String routeName = 'student_grades_view';

  const StudentGradesView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      appBar: AppBar(
        title: Text(
          'My Grades',
          style: AppTextStyle.bold16.copyWith(
            color: AppColors.black,
            fontSize: 18,
          ),
        ),
        backgroundColor: AppColors.backgroundColor,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: false,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: AppColors.secondaryColor),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'Academic Performance',
                style: AppTextStyle.bold24.copyWith(
                  color: AppColors.black,
                  fontSize: 26,
                ),
              ),
              const SizedBox(height: 12),
              RichText(
                text: TextSpan(
                  style: AppTextStyle.medium14.copyWith(
                    color: AppColors.grey,
                    height: 1.5,
                  ),
                  children: [
                    const TextSpan(
                      text:
                          'Detailed breakdown of your mathematical progress this term. Current Weighted Average: ',
                    ),
                    TextSpan(
                      text: '92.4%',
                      style: AppTextStyle.bold14.copyWith(
                        color: AppColors.secondaryColor, // Matching blue percentage
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 32),
              Text(
                'Graded Assessments',
                style: AppTextStyle.bold16.copyWith(
                  color: AppColors.black,
                ),
              ),
              const SizedBox(height: 16),
              
              // Assessments List
              StudentGradeAssessmentCard(
                badgeText: 'QUARTER 1',
                badgeColor: AppColors.darkBlue,
                badgeBackgroundColor: AppColors.lightGrey.withValues(alpha: 0.2),
                dateString: 'Completed Oct 15, 2023',
                title: 'Midterm Algebra Exam',
                grade: '95',
                totalGrade: '100',
                gradeColor: AppColors.secondaryColor,
                statusText: 'Excellent',
                statusColor: AppColors.secondaryColor,
                statusBackgroundColor: AppColors.primaryColor.withValues(alpha: 0.15),
              ),
              StudentGradeAssessmentCard(
                badgeText: 'TOPIC QUIZ',
                badgeColor: AppColors.darkBlue,
                badgeBackgroundColor: AppColors.lightGrey.withValues(alpha: 0.2),
                dateString: 'Completed Sep 28, 2023',
                title: 'Advanced Trigonometry Quiz',
                grade: '88',
                totalGrade: '100',
                gradeColor: AppColors.secondaryColor,
              ),
              StudentGradeAssessmentCard(
                badgeText: 'HOMEWORK UNIT 2',
                badgeColor: AppColors.peach, // Or bright red/orange handling dark mode
                badgeBackgroundColor: AppColors.peach.withValues(alpha: 0.2),
                dateString: 'Completed Sep 12, 2023',
                title: 'Complex Numbers Problem Set',
                grade: '74',
                totalGrade: '100',
                gradeColor: AppColors.peach,
                statusText: 'good',
                statusColor: AppColors.peach,
                statusBackgroundColor: AppColors.peach.withValues(alpha: 0.2),
              ),
              
              const SizedBox(height: 16),
              
              // Bottom Projection Card
              const StudentQuarterlyProjectionCard(
                statusMessage: 'You\'re on track for an A+',
                examsCount: 4,
                tasksCount: 12,
                averagePercentage: 92,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
