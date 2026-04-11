import 'package:flutter/material.dart';
import 'package:school_system/core/utils/app_colors.dart';
import 'package:school_system/core/utils/app_text_style.dart';
import 'package:school_system/features/student/data/models/student_subject_model.dart';
import 'package:school_system/features/student/presentation/views/widgets/subject_details_hero_card.dart';
import 'package:school_system/features/student/presentation/views/student_lesson_details_view.dart';
import 'package:school_system/features/student/presentation/views/widgets/student_assignments_tab.dart';
import 'package:school_system/features/student/presentation/views/widgets/subject_details_tabs.dart';
import 'package:school_system/features/student/presentation/views/widgets/course_material_item_card.dart';

class StudentSubjectDetailsViewBody extends StatefulWidget {
  final StudentSubjectModel subject;

  const StudentSubjectDetailsViewBody({super.key, required this.subject});

  @override
  State<StudentSubjectDetailsViewBody> createState() =>
      _StudentSubjectDetailsViewBodyState();
}

class _StudentSubjectDetailsViewBodyState
    extends State<StudentSubjectDetailsViewBody> {
  int _selectedTab = 0;

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(24.0),
      children: [
        SubjectDetailsHeroCard(subject: widget.subject),
        const SizedBox(height: 32),
        SubjectDetailsTabs(
          selectedIndex: _selectedTab,
          onTabSelected: (index) {
            setState(() {
              _selectedTab = index;
            });
          },
        ),
        const SizedBox(height: 32),
        if (_selectedTab == 0) ...[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Course Materials',
                style: AppTextStyle.bold16.copyWith(
                  color: AppColors.darkBlue,
                  fontSize: 18,
                ),
              ),
              Text(
                '4 Modules Available',
                style: AppTextStyle.medium12.copyWith(color: AppColors.grey),
              ),
            ],
          ),
          const SizedBox(height: 24),
          CourseMaterialItemCard(
            title: 'Complex Numbers & Vectors',
            subtitle: 'Uploaded 2 days ago • 4.2 MB',
            onViewPressed: () {
              Navigator.of(context, rootNavigator: true).pushNamed(
                StudentLessonDetailsView.routeName,
                arguments: 'Complex Numbers & Vectors',
              );
            },
            onDownloadPressed: () {},
          ),
          CourseMaterialItemCard(
            title: 'Introduction to Calculus: Limits',
            subtitle: 'Uploaded Oct 12, 2023 • 2.8 MB',
            onViewPressed: () {},
            onDownloadPressed: () {},
          ),
          CourseMaterialItemCard(
            title: 'Coordinate Geometry Workbook',
            subtitle: 'Uploaded Oct 05, 2023 • 5.1 MB',
            onViewPressed: () {},
            onDownloadPressed: () {},
          ),
        ] else if (_selectedTab == 1) ...[
          const StudentAssignmentsTab(),
        ] else ...[
          Center(
            child: Padding(
              padding: const EdgeInsets.all(40.0),
              child: Text(
                'No content currently available.',
                style: AppTextStyle.medium14.copyWith(color: AppColors.grey),
              ),
            ),
          ),
        ],
      ],
    );
  }
}
