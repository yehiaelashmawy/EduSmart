import 'package:flutter/material.dart';
import 'package:school_system/core/utils/app_colors.dart';
import 'package:school_system/core/utils/app_text_style.dart';
import 'package:school_system/features/teacher/presentation/views/widgets/attendance_method_view_body.dart';

class AttendanceMethodView extends StatelessWidget {
  static const String routeName = '/attendance_method_view';

  const AttendanceMethodView({super.key});

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
          'Select Attendance Method',
          style: AppTextStyle.bold16.copyWith(
            color: const Color(0xff0F2042),
            fontSize: 18,
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 24.0),
            child: CircleAvatar(
              radius: 16,
              backgroundColor: AppColors.primaryColor.withValues(alpha: 0.2),
              backgroundImage: const AssetImage(
                'assets/images/profile_photo.png',
              ),
            ),
          ),
        ],
      ),
      body: const AttendanceMethodViewBody(),
    );
  }
}
