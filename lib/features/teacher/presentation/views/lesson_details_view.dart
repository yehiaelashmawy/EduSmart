import 'package:flutter/material.dart';
import 'package:school_system/features/teacher/presentation/views/widgets/lesson_details_view_body.dart';

class LessonDetailsView extends StatelessWidget {
  const LessonDetailsView({super.key});
  static const String routeName = '/lesson_details';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF8FAFC),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Lesson Details',
          style: TextStyle(
            color: Colors.black,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.more_vert, color: Colors.black),
            onPressed: () {},
          ),
        ],
      ),
      body: const LessonDetailsViewBody(),
    );
  }
}
