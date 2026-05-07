import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:school_system/features/teacher/data/repos/attendance_repo.dart';
import 'start_attendance_state.dart';

class StartAttendanceCubit extends Cubit<StartAttendanceState> {
  final AttendanceRepo _attendanceRepo;

  StartAttendanceCubit(this._attendanceRepo) : super(StartAttendanceInitial());

  Future<void> startSession({
    required String classOid,
    required int method,
    String? lessonOid,
    int correctNumber = 0,
  }) async {
    emit(StartAttendanceLoading());
    final result = await _attendanceRepo.startSession(
      classOid: classOid,
      method: method,
      lessonOid: lessonOid,
      correctNumber: correctNumber,
    );

    result.fold(
      (failure) => emit(StartAttendanceFailure(failure)),
      (session) => emit(StartAttendanceSuccess(session)),
    );
  }
}
