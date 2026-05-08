import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:school_system/core/api/api_service.dart';
import 'package:school_system/core/utils/app_colors.dart';
import 'package:school_system/core/utils/app_text_style.dart';
import 'package:school_system/features/student/data/repos/student_attendance_repo.dart';
import 'package:school_system/features/student/presentation/manager/student_attendance_cubit/student_attendance_cubit.dart';
import 'package:school_system/features/student/presentation/manager/student_attendance_cubit/student_attendance_state.dart';

class StudentSelectCodeView extends StatefulWidget {
  static const String routeName = 'student_select_code_view';

  const StudentSelectCodeView({super.key});

  @override
  State<StudentSelectCodeView> createState() => _StudentSelectCodeViewState();
}

class _StudentSelectCodeViewState extends State<StudentSelectCodeView> {
  int? _selectedCode;
  bool _isSubmitted = false;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          StudentAttendanceCubit(StudentAttendanceRepo(ApiService()))
            ..getActiveSession(),
      child: Scaffold(
        backgroundColor: AppColors.backgroundColor,
        appBar: AppBar(
          title: Text(
            'Select Correct Code',
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
        body: BlocConsumer<StudentAttendanceCubit, StudentAttendanceState>(
          listener: (context, state) {
            if (state is StudentAttendanceSuccess) {
              setState(() => _isSubmitted = true);
              Navigator.pushReplacementNamed(
                context,
                'student_attendance_success_view',
                arguments: state.result,
              );
            } else if (state is StudentAttendanceAbsent) {
              setState(() => _isSubmitted = true);
              Navigator.pushReplacementNamed(
                context,
                'student_attendance_absent_view',
                arguments: state.result,
              );
            } else if (state is StudentAttendanceError) {
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(SnackBar(content: Text(state.message)));
            }
          },
          builder: (context, state) {
            final isLoading =
                state is StudentAttendanceLoading ||
                state is StudentAttendanceInitial;
            List<int> availableCodes = [];
            String sessionId = '';

            if (state is ActiveSessionLoaded) {
              availableCodes = state.session.randomNumbers ?? [];
              sessionId = state.session.sessionId;
            }

            return SafeArea(
              child: Skeletonizer(
                enabled: isLoading,
                child: Column(
                  children: [
                    Expanded(
                      child: SingleChildScrollView(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 24.0,
                          vertical: 24.0,
                        ),
                        child: Column(
                          children: [
                            // Top Graphic Card
                            Container(
                              width: double.infinity,
                              padding: const EdgeInsets.symmetric(vertical: 40),
                              decoration: BoxDecoration(
                                color: AppColors.primaryColor.withValues(
                                  alpha: 0.05,
                                ),
                                borderRadius: BorderRadius.circular(16),
                              ),
                              child: Column(
                                children: [
                                  Container(
                                    padding: const EdgeInsets.all(12),
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(16),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.black.withValues(
                                            alpha: 0.05,
                                          ),
                                          blurRadius: 10,
                                          offset: const Offset(0, 4),
                                        ),
                                      ],
                                    ),
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 16,
                                        vertical: 8,
                                      ),
                                      decoration: BoxDecoration(
                                        color: AppColors.secondaryColor,
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: Text(
                                        '123',
                                        style: AppTextStyle.bold24.copyWith(
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 24),
                                  Text(
                                    'VERIFICATION',
                                    style: AppTextStyle.bold12.copyWith(
                                      color: AppColors.grey,
                                      letterSpacing: 2.0,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 48),

                            // Title and Description
                            Text(
                              'Choose the code shown on\nyour screen',
                              style: AppTextStyle.bold24.copyWith(
                                color: AppColors.black,
                                height: 1.2,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 16),
                            Text(
                              'Select the matching number to verify your\nsession and continue your lesson.',
                              style: AppTextStyle.medium14.copyWith(
                                color: AppColors.grey,
                                height: 1.5,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 40),

                            // Options List
                            if (!isLoading && availableCodes.isEmpty)
                              Padding(
                                padding: const EdgeInsets.only(top: 20),
                                child: Text(
                                  'No codes available.',
                                  style: AppTextStyle.medium14.copyWith(
                                    color: AppColors.grey,
                                  ),
                                ),
                              )
                            else
                              ...(availableCodes.isEmpty
                                      ? [0, 0, 0] // Skeleton dummies
                                      : availableCodes)
                                  .map((code) => _buildCodeOption(code)),
                          ],
                        ),
                      ),
                    ),

                    // Bottom Action Button
                    Padding(
                      padding: const EdgeInsets.all(24.0),
                      child: SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed:
                              _selectedCode == null ||
                                  isLoading ||
                                  availableCodes.isEmpty ||
                                  _isSubmitted
                              ? null
                              : () {
                                  setState(() => _isSubmitted = true);
                                  context
                                      .read<StudentAttendanceCubit>()
                                      .submitSelectedCode(
                                        sessionId,
                                        _selectedCode!,
                                      );
                                },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.secondaryColor,
                            disabledBackgroundColor: AppColors.secondaryColor
                                .withValues(alpha: 0.5),
                            padding: const EdgeInsets.symmetric(vertical: 20),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            elevation: 0,
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'Confirm Selection',
                                style: AppTextStyle.bold16.copyWith(
                                  color: Colors.white,
                                ),
                              ),
                              const SizedBox(width: 8),
                              const Icon(
                                Icons.arrow_forward,
                                color: Colors.white,
                                size: 20,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildCodeOption(int code) {
    final bool isSelected = _selectedCode == code;
    return GestureDetector(
      onTap: _isSubmitted
          ? null
          : () {
              setState(() {
                _selectedCode = code;
              });
            },
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected
                ? AppColors.secondaryColor
                : AppColors.lightGrey.withValues(alpha: 0.3),
            width: isSelected ? 2 : 1,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.02),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              code.toString(),
              style: AppTextStyle.bold16.copyWith(color: AppColors.black),
            ),
            Container(
              width: 24,
              height: 24,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: isSelected
                      ? AppColors.secondaryColor
                      : AppColors.lightGrey,
                  width: 2,
                ),
              ),
              child: isSelected
                  ? Center(
                      child: Container(
                        width: 12,
                        height: 12,
                        decoration: BoxDecoration(
                          color: AppColors.secondaryColor,
                          shape: BoxShape.circle,
                        ),
                      ),
                    )
                  : const SizedBox.shrink(),
            ),
          ],
        ),
      ),
    );
  }
}
