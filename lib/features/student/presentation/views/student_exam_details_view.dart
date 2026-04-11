import 'package:flutter/material.dart';
import 'package:school_system/core/utils/app_colors.dart';
import 'package:school_system/core/utils/app_text_style.dart';
import 'package:school_system/features/student/presentation/views/widgets/student_exam_details_view_body.dart';

class StudentExamDetailsArgs {
  final String status;
  final String title;
  final String date;
  final String time;
  final String duration;
  final String room;
  final List<String> instructions;

  StudentExamDetailsArgs({
    required this.status,
    required this.title,
    required this.date,
    required this.time,
    required this.duration,
    required this.room,
    required this.instructions,
  });
}

class StudentExamDetailsView extends StatelessWidget {
  static const String routeName = 'student_exam_details_view';

  final String status;
  final String title;
  final String date;
  final String time;
  final String duration;
  final String room;
  final List<String> instructions;

  const StudentExamDetailsView({
    super.key,
    required this.status,
    required this.title,
    required this.date,
    required this.time,
    required this.duration,
    required this.room,
    required this.instructions,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      appBar: AppBar(
        backgroundColor: AppColors.backgroundColor,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: false,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: AppColors.secondaryColor),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Exam Details',
          style: AppTextStyle.bold16.copyWith(
            color: AppColors.black,
            fontSize: 18,
          ),
        ),
      ),
      body: StudentExamDetailsViewBody(
        status: status,
        title: title,
        date: date,
        time: time,
        duration: duration,
        room: room,
        instructions: instructions,
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: ElevatedButton.icon(
            onPressed: () {},
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.secondaryColor, // or dark blue
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              elevation: 0,
            ),
            icon: const Text(''), // Place empty to use full control, or use Row
            label: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Submit Exam',
                  style: AppTextStyle.bold16.copyWith(color: Colors.white),
                ),
                const SizedBox(width: 8),
                const Icon(Icons.send_rounded, color: Colors.white, size: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
