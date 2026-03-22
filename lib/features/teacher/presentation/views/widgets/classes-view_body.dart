import 'package:flutter/material.dart';
import 'package:school_system/core/utils/app_colors.dart';
import 'package:school_system/core/utils/app_text_style.dart';
import 'package:school_system/features/teacher/presentation/views/student_list.dart';
import 'package:school_system/features/teacher/presentation/views/widgets/teacher_class_card.dart';
import 'package:school_system/features/teacher/presentation/views/widgets/teacher_classes_app_bar.dart';

class ClassesViewBody extends StatelessWidget {
  const ClassesViewBody({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Column(
        children: [
          Container(
            color: Colors.white,
            child: const SafeArea(bottom: false, child: TeacherClassesAppBar()),
          ),
          Container(
            decoration: BoxDecoration(color: Colors.white),
            child: const TabBar(
              labelColor: AppColors.primaryColor,
              unselectedLabelColor: AppColors.grey,
              indicatorColor: AppColors.primaryColor,
              labelStyle: AppTextStyle.bold14,
              unselectedLabelStyle: AppTextStyle.medium18,
              indicatorWeight: 3,
              indicatorSize: TabBarIndicatorSize.tab,
              tabs: [
                Tab(text: 'Active'),
                Tab(text: 'Archived'),
                Tab(text: 'Upcoming'),
              ],
            ),
          ),
          Expanded(
            child: Container(
              color: AppColors.backgroundColor,
              child: const TabBarView(
                children: [
                  _ActiveClassesTab(),
                  Center(child: Text('Archived Classes Component')),
                  Center(child: Text('Upcoming Classes Component')),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ActiveClassesTab extends StatelessWidget {
  const _ActiveClassesTab();

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
      children: [
        TeacherClassCard(
          image: 'assets/images/class_image.png',
          badgeText: 'Mathematics',
          title: 'Grade 10-A - Mathematics',
          subtitle: 'Advanced Algebra & Trigonometry',
          numStudents: '32',
          schedule: 'Mon, Wed, Fri',
          extraStudentsCount: 29,
          onViewClass: () {
            Navigator.pushNamed(context, StudentList.routeName);
          },
        ),
        TeacherClassCard(
          image: 'assets/images/class_image.png',
          badgeText: 'Mathematics',
          title: 'Grade 11-B - Mathematics',
          subtitle: 'Advanced Algebra',
          numStudents: '28',
          schedule: 'Tue, Thu',
          extraStudentsCount: 25,
          onViewClass: () {
            Navigator.pushNamed(context, StudentList.routeName);
          },
        ),
        TeacherClassCard(
          image: 'assets/images/class_image.png',
          badgeText: 'Mathematics',
          title: 'Grade 12-C - Mathematics',
          subtitle: 'Trigonometry & Calculus',
          numStudents: '24',
          schedule: 'Monday to Friday',
          extraStudentsCount: 21,
          onViewClass: () {
            Navigator.pushNamed(context, StudentList.routeName);
          },
        ),
      ],
    );
  }
}
