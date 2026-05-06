import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:school_system/core/api/api_service.dart';
import 'package:school_system/core/utils/app_colors.dart';
import 'package:school_system/core/utils/app_text_style.dart';
import 'package:school_system/core/widgets/custom_snack_bar.dart';
import 'package:school_system/features/teacher/data/models/attendance_session_model.dart';
import 'package:school_system/features/teacher/data/models/teacher_class_model.dart';
import 'package:school_system/features/teacher/data/repos/attendance_repo.dart';
import 'package:school_system/features/teacher/presentation/manager/submit_attendance_cubit/submit_attendance_cubit.dart';
import 'package:school_system/features/teacher/presentation/views/widgets/manual_attendance_view_body.dart';
import 'package:school_system/features/teacher/presentation/views/widgets/student_attendance_card.dart';

class ManualAttendanceViewArgs {
  final TeacherClassModel teacherClass;
  final AttendanceSessionModel? session;

  ManualAttendanceViewArgs({required this.teacherClass, this.session});
}

class ManualAttendanceView extends StatefulWidget {
  static const String routeName = '/manual_attendance_view';

  final TeacherClassModel teacherClass;
  final AttendanceSessionModel? session;

  const ManualAttendanceView({
    super.key,
    required this.teacherClass,
    this.session,
  });

  @override
  State<ManualAttendanceView> createState() => _ManualAttendanceViewState();
}

class _ManualAttendanceViewState extends State<ManualAttendanceView> {
  final GlobalKey<ManualAttendanceViewBodyState> _bodyKey =
      GlobalKey<ManualAttendanceViewBodyState>();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => SubmitAttendanceCubit(AttendanceRepo(ApiService())),
      child: BlocConsumer<SubmitAttendanceCubit, SubmitAttendanceState>(
        listener: (context, state) {
          if (state is SubmitAttendanceSuccess) {
            CustomSnackBar.showSuccess(context, state.message);
            Navigator.pop(context, true);
          } else if (state is SubmitAttendanceFailure) {
            CustomSnackBar.showError(context, state.failure.errorMessage);
          }
        },
        builder: (context, state) {
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
                'Manual Attendance',
                style: AppTextStyle.bold16.copyWith(
                  color: AppColors.darkBlue,
                  fontSize: 18,
                ),
              ),
            ),
            body: ManualAttendanceViewBody(
              key: _bodyKey,
              teacherClass: widget.teacherClass,
              session: widget.session,
              isLoading: state is SubmitAttendanceLoading,
            ),
            bottomNavigationBar: SafeArea(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(24, 8, 24, 16),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: state is SubmitAttendanceLoading
                            ? null
                            : () {
                                final studentDataList =
                                    _bodyKey.currentState?.students ?? [];
                                final attendances = studentDataList.map((s) {
                                  String statusStr = '';
                                  if (s.status == AttendanceStatus.present) {
                                    statusStr = 'Present';
                                  } else if (s.status == AttendanceStatus.absent) {
                                    statusStr = 'Absent';
                                  } else if (s.status == AttendanceStatus.late) {
                                    statusStr = 'Late';
                                  }
                                  return {
                                    'studentOid': s.studentOid,
                                    'status': statusStr,
                                    'checkInTime': '',
                                  };
                                }).toList();

                                context
                                    .read<SubmitAttendanceCubit>()
                                    .submitSession(
                                      sessionId: widget.session?.sessionId ?? '',
                                      selectedNumber: 0,
                                      attendances: attendances,
                                    );
                              },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.secondaryColor,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          elevation: 0,
                        ),
                        child: state is SubmitAttendanceLoading
                            ? const SizedBox(
                                height: 20,
                                width: 20,
                                child: CircularProgressIndicator(
                                  color: Colors.white,
                                  strokeWidth: 2,
                                ),
                              )
                            : Text(
                                'Finalise Attendance',
                                style: AppTextStyle.semiBold16.copyWith(
                                  color: Colors.white,
                                ),
                              ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'AUTOMATED SYNC WITH SCHOOL INFORMATION\nSYSTEM',
                      style: AppTextStyle.bold12.copyWith(
                        color: AppColors.grey,
                        letterSpacing: 1.2,
                        fontSize: 10,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
