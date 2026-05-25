import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:school_system/core/utils/app_colors.dart';
import 'package:school_system/core/utils/app_text_style.dart';
import 'package:school_system/features/teacher/data/models/teacher_class_model.dart';
import 'package:school_system/features/teacher/presentation/manager/teacher_classes_cubit/teacher_classes_cubit.dart';
import 'package:school_system/features/teacher/presentation/manager/teacher_classes_cubit/teacher_classes_state.dart';
import 'package:school_system/features/teacher/presentation/views/student_list.dart';
import 'package:school_system/features/teacher/presentation/views/widgets/teacher_class_card.dart';
import 'package:school_system/features/teacher/presentation/views/widgets/teacher_classes_app_bar.dart';
import 'package:school_system/core/helper/localization_helper.dart';

class ClassesViewBody extends StatefulWidget {
  const ClassesViewBody({super.key});

  @override
  State<ClassesViewBody> createState() => _ClassesViewBodyState();
}

class _ClassesViewBodyState extends State<ClassesViewBody> {
  String? _selectedFilter;

  void _showFilterSheet(List<TeacherClassModel> allClasses) {
    final levels =
        allClasses
            .map((c) => c.level)
            .where((l) => l.isNotEmpty)
            .toSet()
            .toList()
          ..sort();

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
              Text(
                LocalizationHelper.isArabic ? 'تصفية الفصول' : 'Filter Classes',
                style: AppTextStyle.bold18,
              ),
              const SizedBox(height: 16),
              ListTile(
                title: Text(LocalizationHelper.isArabic ? 'جميع الفصول' : 'All Classes'),
                trailing: _selectedFilter == null
                    ? Icon(Icons.check, color: AppColors.primaryColor)
                    : null,
                onTap: () {
                  setState(() => _selectedFilter = null);
                  Navigator.pop(context);
                },
              ),
              ...levels.map(
                (level) => ListTile(
                  title: Text(
                    LocalizationHelper.isArabic ? 'الصف $level فقط' : 'Grade $level Only',
                  ),
                  trailing: _selectedFilter == level
                      ? Icon(Icons.check, color: AppColors.primaryColor)
                      : null,
                  onTap: () {
                    setState(() => _selectedFilter = level);
                    Navigator.pop(context);
                  },
                ),
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
    return BlocBuilder<TeacherClassesCubit, TeacherClassesState>(
      builder: (context, state) {
        if (state is TeacherClassesLoading) {
          final skeletonClasses = List.generate(
            5,
            (index) => TeacherClassModel(
              oid: 'skeleton-$index',
              name: 'Mathematics - Grade 10',
              level: '10',
              createdAt: '',
              studentsCount: 25,
              sectionsCount: 2,
            ),
          );
          return Skeletonizer(
            enabled: true,
            child: _ActiveClassesTab(classes: skeletonClasses),
          );
        } else if (state is TeacherClassesFailure) {
          return Center(child: Text(state.error.errorMessage));
        } else if (state is TeacherClassesSuccess) {
          final allClasses = state.classes;
          final filtered = allClasses.where((cls) {
            if (_selectedFilter == null) return true;
            return cls.level == _selectedFilter;
          }).toList();

          return DefaultTabController(
            length: 3,
            child: Column(
              children: [
                Container(
                  color: AppColors.white,
                  child: SafeArea(
                    bottom: false,
                    child: TeacherClassesAppBar(
                      onFilterTap: () => _showFilterSheet(allClasses),
                    ),
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
                    tabs: [
                      Tab(text: LocalizationHelper.isArabic ? 'نشط' : 'Active'),
                      Tab(text: LocalizationHelper.isArabic ? 'مؤرشف' : 'Archived'),
                      Tab(text: LocalizationHelper.isArabic ? 'قادم' : 'Upcoming'),
                    ],
                  ),
                ),
                Expanded(
                  child: Container(
                    color: AppColors.backgroundColor,
                    child: TabBarView(
                      children: [
                        _ActiveClassesTab(classes: filtered),
                        Center(child: Text(LocalizationHelper.isArabic ? 'الفصول المؤرشفة' : 'Archived Classes')),
                        Center(child: Text(LocalizationHelper.isArabic ? 'الفصول القادمة' : 'Upcoming Classes')),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        }
        return const SizedBox.shrink();
      },
    );
  }
}

class _ActiveClassesTab extends StatelessWidget {
  final List<TeacherClassModel> classes;
  const _ActiveClassesTab({required this.classes});

  @override
  Widget build(BuildContext context) {
    if (classes.isEmpty) {
      return Center(
        child: Text(
          LocalizationHelper.isArabic ? 'لم يتم العثور على فصول.' : 'No classes found.',
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
        final studentAvatars = c.students.map((s) => s.avatar).take(3).toList();
        final extraCount = c.studentsCount > 3
            ? c.studentsCount - studentAvatars.length
            : 0;

        return TeacherClassCard(
          image: 'assets/images/class_image.png',
          badgeText: LocalizationHelper.isArabic ? 'الصف ${c.level}' : 'Level ${c.level}',
          title: c.name,
          subtitle: LocalizationHelper.isArabic ? 'الصف ${c.level}' : 'Level ${c.level}',
          numStudents: c.studentsCount.toString(),
          schedule: LocalizationHelper.isArabic ? 'الأقسام: ${c.sectionsCount}' : 'Sections: ${c.sectionsCount}',
          extraStudentsCount: extraCount,
          studentAvatars: studentAvatars,
          onViewClass: () async {
            final changed = await Navigator.pushNamed(
              context,
              StudentList.routeName,
              arguments: c,
            );
            if (changed == true && context.mounted) {
              context.read<TeacherClassesCubit>().fetchClasses();
            }
          },
        );
      },
    );
  }
}
