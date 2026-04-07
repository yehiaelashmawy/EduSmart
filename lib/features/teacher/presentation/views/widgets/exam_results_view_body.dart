import 'package:flutter/material.dart';
import 'package:school_system/core/utils/app_colors.dart';
import 'package:school_system/features/teacher/presentation/views/widgets/submission_item_card.dart';
import 'package:school_system/features/teacher/presentation/views/widgets/submissions_header_cards.dart';

class ExamResultsViewBody extends StatelessWidget {
  const ExamResultsViewBody({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.backgroundColor,
      child: Column(
        children: [
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 24),
            child: SubmissionsHeaderCards(),
          ),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              children: const [
                SubmissionItemCard(
                  initials: 'AJ',
                  studentName: 'Alex Johnson',
                  status: SubmissionStatus.graded,
                  dateString: 'Oct 24, 10:30 AM',
                  score: 92,
                  isOnline: true,
                ),
                SizedBox(height: 16),
                SubmissionItemCard(
                  initials: 'MS',
                  studentName: 'Maria Santos',
                  status: SubmissionStatus.graded,
                  dateString: 'Oct 24, 09:15 AM',
                  score: 88,
                ),
                SizedBox(height: 16),
                SubmissionItemCard(
                  initials: 'RK',
                  studentName: 'Ryan Kim',
                  status: SubmissionStatus.graded,
                  dateString: 'Oct 24, 02:45 PM',
                  score: 85,
                ),
                SizedBox(height: 16),
                SubmissionItemCard(
                  initials: 'LW',
                  studentName: 'Liam Wilson',
                  status: SubmissionStatus.notTurnedIn,
                ),
                SizedBox(height: 16),
                SubmissionItemCard(
                  initials: 'CP',
                  studentName: 'Chloe Park',
                  status: SubmissionStatus.submitted,
                  dateString: 'Oct 24, 11:20 AM',
                ),
                SizedBox(height: 16),
                SubmissionItemCard(
                  initials: 'DB',
                  studentName: 'David Brown',
                  status: SubmissionStatus.graded,
                  dateString: 'Oct 24, 04:00 PM',
                  score: 78,
                ),
                SizedBox(height: 32),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
