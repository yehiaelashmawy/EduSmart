import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:school_system/core/api/api_service.dart';
import 'package:school_system/features/parent/data/models/parent_homework_model.dart';
import 'package:school_system/features/parent/data/repos/parent_dashboard_repo.dart';
import 'package:school_system/features/parent/presentation/manager/child_homework_cubit/child_homework_cubit.dart';
import 'package:school_system/features/parent/presentation/manager/child_homework_cubit/child_homework_state.dart';
import 'package:school_system/features/parent/presentation/views/widgets/kid_homework_card.dart';
import 'package:school_system/features/parent/presentation/views/widgets/kid_section_header.dart';

class KidHomeworkTab extends StatelessWidget {
  final String? childId;
  const KidHomeworkTab({super.key, this.childId});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ChildHomeworkCubit(
        ParentDashboardRepo(ApiService()),
        childId: childId ?? '',
      )..fetchHomework(),
      child: const _KidHomeworkTabContent(),
    );
  }
}

class _KidHomeworkTabContent extends StatelessWidget {
  const _KidHomeworkTabContent();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ChildHomeworkCubit, ChildHomeworkState>(
      builder: (context, state) {
        if (state is ChildHomeworkLoading) {
          return _buildLoadingState();
        } else if (state is ChildHomeworkFailure) {
          return Center(child: Text(state.error.errorMessage));
        } else if (state is ChildHomeworkSuccess) {
          return _buildContent(state.homework);
        }
        return const SizedBox.shrink();
      },
    );
  }

  Widget _buildLoadingState() {
    return Skeletonizer(
      enabled: true,
      child: _buildContent(
        List.generate(
          3,
          (index) => ParentHomeworkModel(
            studentOid: '',
            studentName: 'Student Name',
            subjectName: 'Subject Name',
            title: 'Homework Title',
            dueDate: DateTime.now(),
            status: 'Pending',
            totalMarks: 100,
          ),
        ),
      ),
    );
  }

  Widget _buildContent(List<ParentHomeworkModel> homework) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const KidSectionHeader(
            icon: Icons.assignment_outlined,
            title: 'Homework Assignments',
          ),
          const SizedBox(height: 24),
          if (homework.isEmpty)
            const Center(child: Text('No homework assigned')),
          ...homework.map(
            (h) => KidHomeworkCard(
              title: h.title,
              subject: h.subjectName,
              info: h.status == 'Graded' || h.status == 'Submitted'
                  ? 'Due: ${DateFormat('MMM d, yyyy').format(h.dueDate)}'
                  : 'Due: ${DateFormat('MMM d, yyyy').format(h.dueDate)}',
              status: h.status.toUpperCase(),
              grade: h.grade != null ? '${h.grade!.toInt()}/${h.totalMarks.toInt()}' : null,
            ),
          ),
          const SizedBox(height: 32),
        ],
      ),
    );
  }
}

