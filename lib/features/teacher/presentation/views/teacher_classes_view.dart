import 'package:flutter/material.dart';
import 'package:school_system/core/utils/app_colors.dart';
import 'package:school_system/features/teacher/presentation/views/widgets/classes_view_body.dart';

class TeacherClassesView extends StatelessWidget {
  const TeacherClassesView({super.key});
  static const String routeName = '/teacher_classes_view';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      body: const ClassesViewBody(),
    );
  }
}
