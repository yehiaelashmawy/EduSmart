import 'package:flutter/material.dart';
import 'package:school_system/core/api/api_service.dart';
import 'package:school_system/core/utils/app_colors.dart';
import 'package:school_system/features/student/data/models/student_subject_model.dart';
import 'package:school_system/features/student/data/repos/student_subjects_repo.dart';
import 'package:school_system/features/student/presentation/views/widgets/student_subjects_app_bar.dart';
import 'package:school_system/features/student/presentation/views/widgets/subject_item_card.dart';

class StudentSubjectsViewBody extends StatefulWidget {
  const StudentSubjectsViewBody({super.key});

  @override
  State<StudentSubjectsViewBody> createState() =>
      _StudentSubjectsViewBodyState();
}

class _StudentSubjectsViewBodyState extends State<StudentSubjectsViewBody> {
  String _selectedFilter = 'All';
  late Future<List<StudentSubjectModel>> _subjectsFuture;
  final StudentSubjectsRepo _repo = StudentSubjectsRepo(ApiService());

  @override
  void initState() {
    super.initState();
    _subjectsFuture = _loadSubjects();
  }

  Future<List<StudentSubjectModel>> _loadSubjects() async {
    final result = await _repo.getStudentSubjects();
    return result.fold(
      (error) => throw error.errorMessage,
      (subjects) => subjects,
    );
  }

  void _reloadSubjects() {
    setState(() {
      _subjectsFuture = _loadSubjects();
    });
  }

  void _showFilterBottomSheet(List<String> filters) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(24.0),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Filter Subjects',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: AppColors.darkBlue,
                  ),
                ),
                const SizedBox(height: 16),
                ...filters.map(_buildFilterOption),
                const SizedBox(height: 16),
              ],
            ),
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
          color: _selectedFilter == filter
              ? AppColors.primaryColor
              : AppColors.darkBlue,
          fontWeight: _selectedFilter == filter
              ? FontWeight.bold
              : FontWeight.w500,
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
    return Container(
      color: AppColors.white,
      child: SafeArea(
        bottom: false,
        child: Container(
          color: AppColors.backgroundColor,
          child: FutureBuilder<List<StudentSubjectModel>>(
            future: _subjectsFuture,
            builder: (context, snapshot) {
              final subjects = snapshot.data ?? const <StudentSubjectModel>[];
              final filters = <String>{
                'All',
                ...subjects
                    .map((e) => e.trackName)
                    .where((e) => e.trim().isNotEmpty),
              }.toList();

              if (_selectedFilter != 'All' &&
                  !filters.contains(_selectedFilter)) {
                _selectedFilter = 'All';
              }

              final filteredSubjects = _selectedFilter == 'All'
                  ? subjects
                  : subjects
                        .where((s) => s.trackName == _selectedFilter)
                        .toList();

              return Column(
                children: [
                  StudentSubjectsAppBar(
                    onFilterTap: () => _showFilterBottomSheet(filters),
                  ),
                  Expanded(
                    child: Builder(
                      builder: (context) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        }
                        if (snapshot.hasError) {
                          return Center(
                            child: Padding(
                              padding: const EdgeInsets.all(24.0),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    snapshot.error.toString(),
                                    textAlign: TextAlign.center,
                                    style: TextStyle(color: AppColors.grey),
                                  ),
                                  const SizedBox(height: 12),
                                  ElevatedButton(
                                    onPressed: _reloadSubjects,
                                    child: const Text('Retry'),
                                  ),
                                ],
                              ),
                            ),
                          );
                        }
                        if (filteredSubjects.isEmpty) {
                          return Center(
                            child: Text(
                              'No subjects found.',
                              style: TextStyle(color: AppColors.grey),
                            ),
                          );
                        }

                        return ListView.builder(
                          padding: const EdgeInsets.all(24.0),
                          itemCount: filteredSubjects.length,
                          itemBuilder: (context, index) {
                            return SubjectItemCard(
                              subject: filteredSubjects[index],
                            );
                          },
                        );
                      },
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
