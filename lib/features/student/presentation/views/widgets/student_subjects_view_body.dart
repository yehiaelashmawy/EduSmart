import 'package:flutter/material.dart';
import 'package:school_system/core/utils/app_colors.dart';
import 'package:school_system/features/student/data/models/student_subject_model.dart';
import 'package:school_system/features/student/presentation/views/widgets/student_subjects_app_bar.dart';
import 'package:school_system/features/student/presentation/views/widgets/subject_item_card.dart';

class StudentSubjectsViewBody extends StatefulWidget {
  const StudentSubjectsViewBody({super.key});

  @override
  State<StudentSubjectsViewBody> createState() => _StudentSubjectsViewBodyState();
}

class _StudentSubjectsViewBodyState extends State<StudentSubjectsViewBody> {
  String _selectedFilter = 'All';

  final List<StudentSubjectModel> _allSubjects = [
    StudentSubjectModel(
      trackName: 'STEM TRACK',
      subjectName: 'Advanced Mathematics',
      professorName: 'Prof. Sarah Jenkins',
      progressPercentage: 78,
      attendancePercentage: 94,
      assignmentsPercentage: 88,
    ),
    StudentSubjectModel(
      trackName: 'HUMANITIES',
      subjectName: 'Modern Literature',
      professorName: 'Dr. Michael Chen',
      progressPercentage: 45,
      attendancePercentage: 100,
      assignmentsPercentage: 62,
    ),
    StudentSubjectModel(
      trackName: 'STEM TRACK',
      subjectName: 'Quantum Physics',
      professorName: 'Prof. Alistair Thorne',
      progressPercentage: 92,
      attendancePercentage: 82,
      assignmentsPercentage: 95,
    ),
  ];

  void _showFilterBottomSheet() {
    showModalBottomSheet(
      context: context,
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
              const Text(
                'Filter Subjects',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  // Fallback to black if darkBlue is unavailable, but AppColors is imported
                  color: Color(0xff0F2042),
                ),
              ),
              const SizedBox(height: 16),
              _buildFilterOption('All'),
              _buildFilterOption('STEM TRACK'),
              _buildFilterOption('HUMANITIES'),
              const SizedBox(height: 16),
            ],
          ),
        );
      },
    );
  }

  Widget _buildFilterOption(String filter) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      title: Text(
        filter,
        style: TextStyle(
          color: _selectedFilter == filter ? AppColors.primaryColor : const Color(0xff0F2042),
          fontWeight: _selectedFilter == filter ? FontWeight.bold : FontWeight.w500,
        ),
      ),
      trailing: _selectedFilter == filter
          ? Icon(Icons.check, color: AppColors.primaryColor)
          : null,
      onTap: () {
        setState(() {
          _selectedFilter = filter;
        });
        Navigator.pop(context);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final filteredSubjects = _selectedFilter == 'All' 
        ? _allSubjects 
        : _allSubjects.where((s) => s.trackName == _selectedFilter).toList();

    return Container(
      color: Colors.white,
      child: SafeArea(
        bottom: false,
        child: Container(
          color: AppColors.backgroundColor,
          child: Column(
            children: [
              StudentSubjectsAppBar(
                onFilterTap: _showFilterBottomSheet,
              ),
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.all(24.0),
                  itemCount: filteredSubjects.length,
                  itemBuilder: (context, index) {
                    return SubjectItemCard(subject: filteredSubjects[index]);
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

