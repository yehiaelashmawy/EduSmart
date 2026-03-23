import 'package:flutter/material.dart';
import 'package:school_system/core/utils/app_text_style.dart';
import 'package:school_system/features/teacher/presentation/views/widgets/add_new_lesson_view_body.dart';

class AddNewLessonView extends StatelessWidget {
  const AddNewLessonView({super.key});
  static const String routeName = '/add_new_lesson';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF8FAFC),
      appBar: AppBar(
        backgroundColor: const Color(0xffF8FAFC),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xff0F52BD)),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Add New Lesson',
          style: AppTextStyle.bold16.copyWith(
            color: const Color(0xff0F2042),
            fontSize: 18, // slightly larger
          ),
        ),
      ),
      body: const AddNewLessonViewBody(),
    );
  }
}
