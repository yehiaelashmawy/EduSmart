import 'package:flutter/material.dart';
import 'package:school_system/core/utils/app_colors.dart';
import 'package:school_system/features/student/presentation/views/widgets/student_exam_item_card.dart';
import 'package:school_system/features/student/presentation/views/student_exam_details_view.dart';

class StudentExamsTab extends StatelessWidget {
  const StudentExamsTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        StudentExamItemCard(
          iconData: Icons.check_circle_outline,
          iconColor: AppColors.secondaryColor,
          iconBackgroundColor: AppColors.primaryColor.withValues(alpha: 0.15),
          badgeText: 'COMPLETED',
          badgeTextColor: AppColors.secondaryColor,
          badgeBackgroundColor: AppColors.primaryColor.withValues(alpha: 0.15),
          title: 'Calculus Midterm',
          subtitle: 'Differential equations and integral approximations.',
          bottomLabel: 'FINAL GRADE',
          bottomValue: '95/100',
          bottomValueColor: AppColors.secondaryColor,
          isPrimaryButton: false,
          onViewDetails: () {
            Navigator.pushNamed(
              context,
              StudentExamDetailsView.routeName,
              arguments: StudentExamDetailsArgs(
                status: 'COMPLETED',
                title: 'Calculus Midterm',
                date: 'Sep 12, 2023',
                time: '09:00 AM',
                duration: '120 Mins',
                room: 'Hall B',
                instructions: const [
                  'Calculators are permitted for this midterm.',
                  'Ensure your student ID is placed clearly on your desk.',
                ],
              ),
            );
          },
        ),
        StudentExamItemCard(
          iconData: Icons.calendar_today_outlined,
          iconColor: const Color(0xffB42318), // Dark red/orange
          iconBackgroundColor: const Color(0xffB42318).withValues(alpha: 0.1),
          badgeText: 'OCT 24',
          badgeTextColor: Colors.white,
          badgeBackgroundColor: AppColors.secondaryColor,
          title: 'Linear Algebra Quiz',
          subtitle: 'Vector spaces, matrices, and linear transformations.',
          bottomLabel: 'STATUS',
          bottomValue: 'Scheduled',
          bottomValueColor: AppColors.darkBlue,
          isPrimaryButton: true,
          onViewDetails: () {
            Navigator.pushNamed(
              context,
              StudentExamDetailsView.routeName,
              arguments: StudentExamDetailsArgs(
                status: 'Upcoming Assessment',
                title: 'Linear Algebra Quiz',
                date: 'Oct 24, 2023',
                time: '09:00 AM',
                duration: '90 Mins',
                room: 'Lab 402',
                instructions: const [
                  'Bring your own scientific calculator (graphic calculators are prohibited).',
                  'No mobile phones or smartwatches allowed in the examination hall.',
                  'Arrive 15 minutes before the start time for identity verification.',
                ],
              ),
            );
          },
        ),
        StudentExamItemCard(
          iconData: Icons.history,
          iconColor: const Color(0xffB42318), // Dark red
          iconBackgroundColor: const Color(0xffB42318).withValues(alpha: 0.15),
          badgeText: 'FEEDBACK',
          badgeTextColor: Colors.white,
          badgeBackgroundColor: const Color(0xff7A271A), // Deep brown/red
          title: 'Discrete Structures',
          subtitle: 'Graph theory fundamentals and boolean algebra.',
          bottomLabel: 'FINAL GRADE',
          bottomValue: '88/100',
          bottomValueColor: const Color(0xff7A271A),
          isPrimaryButton: false,
          onViewDetails: () {
            Navigator.pushNamed(
              context,
              StudentExamDetailsView.routeName,
              arguments: StudentExamDetailsArgs(
                status: 'Evaluated',
                title: 'Discrete Structures',
                date: 'Oct 10, 2023',
                time: '11:00 AM',
                duration: '60 Mins',
                room: 'Lab 405',
                instructions: const [
                  'Graph traversal algorithms are heavily emphasized.',
                  'You may bring one page of handwritten notes.',
                ],
              ),
            );
          },
        ),
      ],
    );
  }
}
