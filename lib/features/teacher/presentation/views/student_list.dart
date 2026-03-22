import 'package:flutter/material.dart';
import 'package:school_system/core/utils/app_colors.dart';
import 'package:school_system/features/teacher/presentation/views/widgets/lessons_list_body.dart';
import 'package:school_system/features/teacher/presentation/views/widgets/students_list_body.dart';

class StudentList extends StatelessWidget {
  const StudentList({super.key});
  static const String routeName = '/student_list';

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 5,
      child: Scaffold(
        backgroundColor: Color(0xffF8FAFC),
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.black),
            onPressed: () => Navigator.pop(context),
          ),
          title: const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Grade 10-A - Mathematics',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 4),
              Text(
                'Academic Year 2023/24',
                style: TextStyle(color: AppColors.grey, fontSize: 12),
              ),
            ],
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.search, color: Colors.black),
              onPressed: () {},
            ),
            IconButton(
              icon: const Icon(Icons.more_vert, color: Colors.black),
              onPressed: () {},
            ),
          ],
          bottom: const TabBar(
            labelColor: AppColors.primaryColor,
            unselectedLabelColor: AppColors.grey,
            indicatorColor: AppColors.primaryColor,
            labelStyle: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
            unselectedLabelStyle: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
            indicatorWeight: 3,
            isScrollable: true,
            tabAlignment: TabAlignment.start,
            tabs: [
              Tab(text: 'Students'),
              Tab(text: 'Lessons'),
              Tab(text: 'Homework'),
              Tab(text: 'Exams'),
              Tab(text: 'Attendance'),
            ],
          ),
        ),
        body: const TabBarView(
          children: [
            StudentsListBody(),
            LessonsListBody(),
            Center(child: Text('Homework')),
            Center(child: Text('Exams')),
            Center(child: Text('Attendance')),
          ],
        ),
      ),
    );
  }
}
