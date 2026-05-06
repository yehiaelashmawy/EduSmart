import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:school_system/core/api/api_service.dart';
import 'package:school_system/core/utils/app_colors.dart';
import 'package:school_system/core/utils/app_text_style.dart';
import 'package:school_system/core/widgets/custom_snack_bar.dart';
import 'package:school_system/features/teacher/data/models/attendance_session_model.dart';
import 'package:school_system/features/teacher/data/repos/attendance_repo.dart';
import 'package:school_system/features/teacher/presentation/manager/submit_attendance_cubit/submit_attendance_cubit.dart';
import 'package:school_system/features/teacher/presentation/views/widgets/generate_qr_code_view_body.dart';

class GenerateQrCodeView extends StatelessWidget {
  static const String routeName = '/generate_qr_code_view';
  final AttendanceSessionModel session;

  const GenerateQrCodeView({super.key, required this.session});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => SubmitAttendanceCubit(AttendanceRepo(ApiService())),
      child: BlocConsumer<SubmitAttendanceCubit, SubmitAttendanceState>(
        listener: (context, state) {
          if (state is SubmitAttendanceSuccess) {
            CustomSnackBar.showSuccess(context, state.message);
            Navigator.pop(context, true);
          } else if (state is SubmitAttendanceFailure) {
            CustomSnackBar.showError(context, state.failure.errorMessage);
          }
        },
        builder: (context, submitState) {
          return Scaffold(
            backgroundColor: AppColors.backgroundColor,
            appBar: AppBar(
              backgroundColor: AppColors.backgroundColor,
              elevation: 0,
              leading: IconButton(
                icon: Icon(Icons.arrow_back, color: AppColors.secondaryColor),
                onPressed: () => Navigator.pop(context),
              ),
              title: Text(
                'Generate QR Code',
                style: AppTextStyle.bold16.copyWith(
                  color: AppColors.darkBlue,
                  fontSize: 18,
                ),
              ),
            ),
            body: GenerateQrCodeViewBody(
              session: session,
              isSubmitting: submitState is SubmitAttendanceLoading,
              onSubmit: () {
                context.read<SubmitAttendanceCubit>().submitSession(
                  sessionId: session.sessionId,
                  selectedNumber: 0,
                  attendances: [],
                );
              },
            ),
          );
        },
      ),
    );
  }
}
