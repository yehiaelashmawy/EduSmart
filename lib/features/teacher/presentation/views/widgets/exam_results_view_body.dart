import 'package:flutter/material.dart';
import 'package:school_system/core/utils/app_colors.dart';
import 'package:school_system/features/teacher/presentation/views/widgets/submission_item_card.dart';
import 'package:school_system/features/teacher/presentation/views/widgets/submissions_header_cards.dart';
import 'package:school_system/features/teacher/data/models/submission_model.dart';

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
              children: [
                SubmissionItemCard(
                  submission: SubmissionModel(
                    id: '1',
                    studentName: 'Alex Johnson',
                    studentEmail: 'alex.j@school.com',
                    content: '',
                    submittedAt: '2026-10-24T10:30:00',
                    grade: 92,
                    status: 'Graded',
                    isLate: false,
                  ),
                  onGradeTap: () {},
                ),
                SizedBox(height: 16),
                SubmissionItemCard(
                  submission: SubmissionModel(
                    id: '2',
                    studentName: 'Maria Santos',
                    studentEmail: 'maria.s@school.com',
                    content: '',
                    submittedAt: '2026-10-24T09:15:00',
                    grade: 88,
                    status: 'Graded',
                    isLate: false,
                  ),
                  onGradeTap: () {},
                ),
                SizedBox(height: 16),
                SubmissionItemCard(
                  submission: SubmissionModel(
                    id: '3',
                    studentName: 'Ryan Kim',
                    studentEmail: 'ryan.k@school.com',
                    content: '',
                    submittedAt: '2026-10-24T14:45:00',
                    grade: 85,
                    status: 'Graded',
                    isLate: false,
                  ),
                  onGradeTap: () {},
                ),
                SizedBox(height: 16),
                SubmissionItemCard(
                  submission: SubmissionModel(
                    id: '4',
                    studentName: 'Liam Wilson',
                    studentEmail: 'liam.w@school.com',
                    content: '',
                    submittedAt: '',
                    status: 'NotSubmitted',
                    isLate: false,
                  ),
                  onGradeTap: () {},
                ),
                SizedBox(height: 16),
                SubmissionItemCard(
                  submission: SubmissionModel(
                    id: '5',
                    studentName: 'Chloe Park',
                    studentEmail: 'chloe.p@school.com',
                    content: '',
                    submittedAt: '2026-10-24T11:20:00',
                    status: 'Submitted',
                    isLate: false,
                  ),
                  onGradeTap: () {},
                ),
                SizedBox(height: 16),
                SubmissionItemCard(
                  submission: SubmissionModel(
                    id: '6',
                    studentName: 'David Brown',
                    studentEmail: 'david.b@school.com',
                    content: '',
                    submittedAt: '2026-10-24T16:00:00',
                    grade: 78,
                    status: 'Graded',
                    isLate: false,
                  ),
                  onGradeTap: () {},
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
