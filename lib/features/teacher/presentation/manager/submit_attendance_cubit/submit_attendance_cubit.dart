import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:school_system/core/api/api_errors.dart';
import 'package:school_system/features/teacher/data/repos/attendance_repo.dart';

abstract class SubmitAttendanceState {}

class SubmitAttendanceInitial extends SubmitAttendanceState {}

class SubmitAttendanceLoading extends SubmitAttendanceState {}

class SubmitAttendanceSuccess extends SubmitAttendanceState {
  final String message;
  SubmitAttendanceSuccess(this.message);
}

class SubmitAttendanceFailure extends SubmitAttendanceState {
  final ApiErrors failure;
  SubmitAttendanceFailure(this.failure);
}

class SubmitAttendanceCubit extends Cubit<SubmitAttendanceState> {
  final AttendanceRepo _attendanceRepo;

  SubmitAttendanceCubit(this._attendanceRepo)
    : super(SubmitAttendanceInitial());

  Future<void> submitSession({
    required String sessionId,
    required int selectedNumber,
    required List<Map<String, dynamic>> attendances,
  }) async {
    emit(SubmitAttendanceLoading());
    final result = await _attendanceRepo.submitSession(
      sessionId: sessionId,
      selectedNumber: selectedNumber,
      attendances: attendances,
    );
    result.fold(
      (failure) => emit(SubmitAttendanceFailure(failure)),
      (_) => emit(SubmitAttendanceSuccess('Attendance submitted successfully')),
    );
  }
}
