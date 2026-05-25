import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:school_system/core/utils/app_colors.dart';
import 'package:school_system/core/utils/app_text_style.dart';
import 'package:school_system/core/helper/shared_prefs_helper.dart';
import 'package:school_system/features/teacher/presentation/views/add_homework_view.dart';
import 'package:school_system/core/widgets/smart_tutor/smart_tutor_view.dart';
import 'package:school_system/features/teacher/presentation/views/take_attendance_view.dart';
import 'package:school_system/features/teacher/presentation/manager/teacher_exams_cubit/teacher_exams_cubit.dart';
import 'package:school_system/features/teacher/presentation/manager/teacher_timetable_cubit/teacher_timetable_cubit.dart';
import 'package:school_system/features/teacher/presentation/manager/teacher_classes_cubit/teacher_classes_cubit.dart';
import 'package:school_system/core/utils/theme_manager.dart';

import 'package:school_system/core/helper/localization_helper.dart';

class TeacherActionButtons extends StatelessWidget {
  const TeacherActionButtons({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: _buildActionButton(
                title: 'take_attendance'.tr(),
                icon: Icons.how_to_reg,
                backgroundColor: AppColors.primaryColor,
                textColor: AppColors.white,
                iconColor: AppColors.white,
                onTap: () {
                  Navigator.pushNamed(context, TakeAttendanceView.routeName);
                },
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: _buildActionButton(
                title: 'add_new_lesson'.tr(),
                icon: Icons.library_books,
                backgroundColor: AppColors.white,
                textColor: AppColors.black,
                iconColor: AppColors.primaryColor,
                onTap: () async {
                  final created = await Navigator.pushNamed(
                    context,
                    '/add_new_lesson',
                  );
                  if (created == true && context.mounted) {
                    context.read<TeacherExamsCubit>().fetchExams();
                    context.read<TeacherClassesCubit>().fetchClasses();
                    final teacherIdentifier =
                        (SharedPrefsHelper.teacherOid?.trim().isNotEmpty ??
                            false)
                        ? SharedPrefsHelper.teacherOid!.trim()
                        : (SharedPrefsHelper.userId ?? '');
                    context.read<TeacherTimetableCubit>().fetchTodayClasses(
                      teacherIdentifier,
                    );
                  }
                },
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: _buildActionButton(
                title: 'add_homework'.tr(),
                icon: Icons.assignment_add,
                backgroundColor: AppColors.white,
                textColor: AppColors.black,
                iconColor: AppColors.primaryColor,
                isDashed: true,
                onTap: () async {
                  final created = await Navigator.pushNamed(
                    context,
                    AddHomeworkView.routeName,
                  );
                  if (created == true && context.mounted) {
                    context.read<TeacherExamsCubit>().fetchExams();
                    context.read<TeacherClassesCubit>().fetchClasses();
                  }
                },
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: _buildActionButton(
                title: 'smart_tutor_title'.tr(),
                icon: Icons.psychology,
                backgroundColor: ThemeManager.isDarkMode
                    ? AppColors.primaryColor
                    : AppColors.darkBlue,
                textColor: AppColors.white,
                iconColor: AppColors.white,
                onTap: () {
                  Navigator.of(
                    context,
                    rootNavigator: true,
                  ).pushNamed(SmartTutorView.routeName);
                },
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildActionButton({
    required String title,
    required IconData icon,
    required Color backgroundColor,
    required Color textColor,
    required Color iconColor,
    bool isDashed = false,
    VoidCallback? onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 8),
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(16),
          border: isDashed
              ? Border.all(
                  color: AppColors.primaryColor.withValues(alpha: 0.5),
                  style: BorderStyle.solid,
                )
              : null,
          boxShadow: isDashed
              ? []
              : [
                  BoxShadow(
                    color: AppColors.black.withValues(alpha: 0.04),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: iconColor, size: 28),
            const SizedBox(height: 12),
            FittedBox(
              fit: BoxFit.scaleDown,
              child: Text(
                title,
                style: AppTextStyle.semiBold14.copyWith(color: textColor),
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
