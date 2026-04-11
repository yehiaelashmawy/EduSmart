import 'package:flutter/material.dart';
import 'package:school_system/features/student/presentation/views/widgets/student_assignment_item_card.dart';

class StudentAssignmentsTab extends StatelessWidget {
  const StudentAssignmentsTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        StudentAssignmentItemCard(
          status: AssignmentStatus.graded,
          title: 'Differential Equations: First Order Basics',
          submittedDate: 'Submitted Sep 12, 2023',
          grade: '95',
          totalGrade: '100',
          feedback: 'Excellent clarity on methods.',
          onViewDetails: () {},
          onSecondaryAction: () {},
        ),
        StudentAssignmentItemCard(
          status: AssignmentStatus.notSubmitted,
          title: 'Linear Transformations & Vector Spaces',
          submittedDate: 'Due in 2 days (Oct 24)',
          isDueSoon: true,
          description:
              'Analyze the properties of linear transformations in R3 and provide three real...',
          onViewDetails: () {},
          onSecondaryAction: () {},
          onSubmitWork: () {},
        ),
        StudentAssignmentItemCard(
          status: AssignmentStatus.pendingReview,
          title: 'Midterm Review: Integration Techniques',
          submittedDate: 'Submitted Oct 18, 2023',
          filename: 'integration_review_final.pdf',
          onViewDetails: () {},
          onSecondaryAction: () {},
        ),
      ],
    );
  }
}
