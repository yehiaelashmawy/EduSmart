import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:school_system/core/api/api_service.dart';
import 'package:school_system/core/utils/app_colors.dart';
import 'package:school_system/core/utils/app_text_style.dart';
import 'package:school_system/features/student/data/repos/student_attendance_repo.dart';
import 'package:school_system/features/student/presentation/manager/student_attendance_cubit/student_attendance_cubit.dart';
import 'package:school_system/features/student/presentation/views/widgets/student_scan_qr_view_body.dart';

class StudentScanQrView extends StatelessWidget {
  static const String routeName = 'student_scan_qr_view';

  final String subject;

  const StudentScanQrView({super.key, required this.subject});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => StudentAttendanceCubit(StudentAttendanceRepo(ApiService())),
      child: Scaffold(
        backgroundColor: AppColors.backgroundColor,
        appBar: AppBar(
          title: Text(
            'Scan QR Code',
            style: AppTextStyle.bold16.copyWith(
              color: AppColors.black,
              fontSize: 16,
            ),
          ),
          backgroundColor: AppColors.backgroundColor,
          elevation: 0,
          centerTitle: false,
          leading: IconButton(
            icon: Icon(Icons.arrow_back, color: AppColors.secondaryColor),
            onPressed: () => Navigator.pop(context),
          ),
        ),
        body: StudentScanQrViewBody(subject: subject),
      ),
    );
  }
}
