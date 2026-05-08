import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:school_system/features/student/data/repos/student_attendance_repo.dart';
import 'student_attendance_state.dart';

class StudentAttendanceCubit extends Cubit<StudentAttendanceState> {
  final StudentAttendanceRepo _repo;

  StudentAttendanceCubit(this._repo) : super(StudentAttendanceInitial());

  Future<void> getActiveSession() async {
    emit(StudentAttendanceLoading());

    final result = await _repo.getActiveSession();

    result.fold(
      (failure) => emit(StudentAttendanceError(failure.errorMessage)),
      (session) => emit(ActiveSessionLoaded(session)),
    );
  }

  Future<void> submitQrCode(String sessionId, String qrRawValue) async {
    emit(StudentAttendanceLoading());

    final result = await _repo.submitAttendance(
      sessionId: sessionId,
      selectedNumber: 0,
      remarks: qrRawValue,
    );

    result.fold(
      (failure) => emit(StudentAttendanceError(failure.errorMessage)),
      (submitResult) {
        if (submitResult.status == 'Present' || submitResult.status == 'Late') {
          emit(StudentAttendanceSuccess(submitResult));
        } else {
          emit(StudentAttendanceAbsent(submitResult));
        }
      },
    );
  }

  Future<void> submitSelectedCode(String sessionId, int selectedNumber) async {
    emit(StudentAttendanceLoading());

    final result = await _repo.submitAttendance(
      sessionId: sessionId,
      selectedNumber: selectedNumber,
      remarks: "",
    );

    result.fold(
      (failure) => emit(StudentAttendanceError(failure.errorMessage)),
      (submitResult) {
        if (submitResult.status == 'Present' || submitResult.status == 'Late') {
          emit(StudentAttendanceSuccess(submitResult));
        } else {
          emit(StudentAttendanceAbsent(submitResult));
        }
      },
    );
  }
}
