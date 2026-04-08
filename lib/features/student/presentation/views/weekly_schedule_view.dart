import 'package:flutter/material.dart';
import 'package:school_system/core/utils/app_colors.dart';
import 'package:school_system/core/utils/app_text_style.dart';
import 'package:school_system/features/student/presentation/views/widgets/weekly_schedule_view_body.dart';

class WeeklyScheduleView extends StatelessWidget {
  const WeeklyScheduleView({super.key});
  static const String routeName = 'weekly_schedule_view';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      appBar: AppBar(
        backgroundColor: AppColors.backgroundColor,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xff0F52BD)),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Weekly Schedule',
          style: AppTextStyle.bold16.copyWith(
            color: const Color(0xff0F2042),
            fontSize: 18,
          ),
        ),
      ),
      body: const WeeklyScheduleViewBody(),
    );
  }
}
