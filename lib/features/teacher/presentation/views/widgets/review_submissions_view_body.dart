import 'package:flutter/material.dart';
import 'package:school_system/core/utils/app_colors.dart';
import 'package:school_system/features/teacher/presentation/views/widgets/submission_item_card.dart';
import 'package:school_system/features/teacher/presentation/views/widgets/submissions_header_cards.dart';

class ReviewSubmissionsViewBody extends StatelessWidget {
  const ReviewSubmissionsViewBody({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Container(
        color: AppColors.backgroundColor,
        child: Column(
          children: [
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 24),
              child: SubmissionsHeaderCards(),
            ),
            TabBar(
              labelColor: AppColors.secondaryColor,
              unselectedLabelColor: AppColors.grey,
              indicatorColor: AppColors.secondaryColor,
              labelStyle: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
              ),
              unselectedLabelStyle: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
              indicatorWeight: 2,
              dividerColor: AppColors.lightGrey.withValues(alpha: 0.3),
              tabs: const [
                Tab(text: 'All Students (24)'),
                Tab(text: 'Submitted (19)'),
              ],
            ),
            Expanded(
              child: TabBarView(
                children: [_buildAllStudentsList(), _buildSubmittedList()],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAllStudentsList() {
    return ListView(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
      children: const [
        SubmissionItemCard(
          initials: 'AJ',
          studentName: 'Alex Johnson',
          status: SubmissionStatus.graded,
          dateString: 'Oct 12, 10:30 AM',
          score: 92,
          isOnline: true,
        ),
        SizedBox(height: 16),
        SubmissionItemCard(
          initials: 'MS',
          studentName: 'Maria Santos',
          status: SubmissionStatus.submitted,
          dateString: 'Oct 13, 09:15 AM',
        ),
        SizedBox(height: 16),
        SubmissionItemCard(
          initials: 'RK',
          studentName: 'Ryan Kim',
          status: SubmissionStatus.graded,
          dateString: 'Oct 12, 02:45 PM',
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
          dateString: 'Oct 13, 11:20 AM',
        ),
        SizedBox(height: 16),
        SubmissionItemCard(
          initials: 'DB',
          studentName: 'David Brown',
          status: SubmissionStatus.graded,
          dateString: 'Oct 11, 04:00 PM',
          score: 78,
        ),
        SizedBox(height: 32),
      ],
    );
  }

  Widget _buildSubmittedList() {
    return Center(
      child: Text('Submitted List', style: TextStyle(color: AppColors.grey)),
    );
  }
}
