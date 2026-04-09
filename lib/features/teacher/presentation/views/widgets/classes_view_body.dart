import 'package:flutter/material.dart';
import 'package:school_system/core/utils/app_colors.dart';
import 'package:school_system/core/utils/app_text_style.dart';
import 'package:school_system/features/teacher/presentation/views/student_list.dart';
import 'package:school_system/features/teacher/presentation/views/widgets/teacher_class_card.dart';
import 'package:school_system/features/teacher/presentation/views/widgets/teacher_classes_app_bar.dart';

class ClassModel {
  final String title;
  final String subtitle;
  final String schedule;
  final String numStudents;
  final int extraStudentsCount;
  final String badgeText;

  ClassModel({
    required this.title,
    required this.subtitle,
    required this.schedule,
    required this.numStudents,
    required this.extraStudentsCount,
    required this.badgeText,
  });
}

class ClassesViewBody extends StatefulWidget {
  const ClassesViewBody({super.key});

  @override
  State<ClassesViewBody> createState() => _ClassesViewBodyState();
}

class _ClassesViewBodyState extends State<ClassesViewBody> {
  String? _selectedFilter;

  final List<ClassModel> _allClasses = [
    ClassModel(
      title: 'Grade 10-A - Mathematics',
      subtitle: 'Advanced Algebra & Trigonometry',
      schedule: 'Mon, Wed, Fri',
      numStudents: '32',
      extraStudentsCount: 29,
      badgeText: 'Mathematics',
    ),
    ClassModel(
      title: 'Grade 11-B - Mathematics',
      subtitle: 'Advanced Algebra',
      schedule: 'Tue, Thu',
      numStudents: '28',
      extraStudentsCount: 25,
      badgeText: 'Mathematics',
    ),
    ClassModel(
      title: 'Grade 12-C - Mathematics',
      subtitle: 'Trigonometry & Calculus',
      schedule: 'Monday to Friday',
      numStudents: '24',
      extraStudentsCount: 21,
      badgeText: 'Mathematics',
    ),
  ];

  void _showFilterSheet() {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Filter Classes', style: AppTextStyle.bold18),
              const SizedBox(height: 16),
              ListTile(
                title: const Text('All Classes'),
                trailing: _selectedFilter == null
                    ? Icon(Icons.check, color: AppColors.primaryColor)
                    : null,
                onTap: () {
                  setState(() => _selectedFilter = null);
                  Navigator.pop(context);
                },
              ),
              ListTile(
                title: const Text('Grade 10 Only'),
                trailing: _selectedFilter == 'Grade 10'
                    ? Icon(Icons.check, color: AppColors.primaryColor)
                    : null,
                onTap: () {
                  setState(() => _selectedFilter = 'Grade 10');
                  Navigator.pop(context);
                },
              ),
              ListTile(
                title: const Text('Grade 11 Only'),
                trailing: _selectedFilter == 'Grade 11'
                    ? Icon(Icons.check, color: AppColors.primaryColor)
                    : null,
                onTap: () {
                  setState(() => _selectedFilter = 'Grade 11');
                  Navigator.pop(context);
                },
              ),
              ListTile(
                title: const Text('Grade 12 Only'),
                trailing: _selectedFilter == 'Grade 12'
                    ? Icon(Icons.check, color: AppColors.primaryColor)
                    : null,
                onTap: () {
                  setState(() => _selectedFilter = 'Grade 12');
                  Navigator.pop(context);
                },
              ),
              const SizedBox(height: 24),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final filtered = _allClasses.where((cls) {
      if (_selectedFilter == null) return true;
      return cls.title.contains(_selectedFilter!);
    }).toList();

    return DefaultTabController(
      length: 3,
      child: Column(
        children: [
          Container(
            color: AppColors.white,
            child: SafeArea(
              bottom: false,
              child: TeacherClassesAppBar(onFilterTap: _showFilterSheet),
            ),
          ),
          Container(
            decoration: BoxDecoration(color: AppColors.white),
            child: TabBar(
              labelColor: AppColors.primaryColor,
              unselectedLabelColor: AppColors.grey,
              indicatorColor: AppColors.primaryColor,
              labelStyle: AppTextStyle.bold14,
              unselectedLabelStyle: AppTextStyle.medium18,
              indicatorWeight: 3,
              indicatorSize: TabBarIndicatorSize.tab,
              tabs: const [
                Tab(text: 'Active'),
                Tab(text: 'Archived'),
                Tab(text: 'Upcoming'),
              ],
            ),
          ),
          Expanded(
            child: Container(
              color: AppColors.backgroundColor,
              child: TabBarView(
                children: [
                  _ActiveClassesTab(classes: filtered),
                  const Center(child: Text('Archived Classes Component')),
                  const Center(child: Text('Upcoming Classes Component')),
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
  final List<ClassModel> classes;
  const _ActiveClassesTab({required this.classes});

  @override
  Widget build(BuildContext context) {
    if (classes.isEmpty) {
      return Center(
        child: Text(
          'No classes found.',
          style: AppTextStyle.medium18.copyWith(color: AppColors.grey),
        ),
      );
    }

    return ListView.separated(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
      itemCount: classes.length,
      separatorBuilder: (_, _) => const SizedBox(height: 16),
      itemBuilder: (context, index) {
        final c = classes[index];
        return TeacherClassCard(
          image: 'assets/images/class_image.png',
          badgeText: c.badgeText,
          title: c.title,
          subtitle: c.subtitle,
          numStudents: c.numStudents,
          schedule: c.schedule,
          extraStudentsCount: c.extraStudentsCount,
          onViewClass: () {
            Navigator.pushNamed(context, StudentList.routeName);
          },
        );
      },
    );
  }
}
