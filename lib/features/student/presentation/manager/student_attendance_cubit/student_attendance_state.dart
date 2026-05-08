import 'package:school_system/features/student/data/models/active_session_model.dart';

import 'package:school_system/features/student/data/models/student_attendance_submit_model.dart';

abstract class StudentAttendanceState {}

class StudentAttendanceInitial extends StudentAttendanceState {}

class StudentAttendanceLoading extends StudentAttendanceState {}

class ActiveSessionLoaded extends StudentAttendanceState {
  final ActiveSessionModel session;

  ActiveSessionLoaded(this.session);
}

class StudentAttendanceSuccess extends StudentAttendanceState {
  final StudentAttendanceSubmitModel result;
  StudentAttendanceSuccess(this.result);
}

class StudentAttendanceAbsent extends StudentAttendanceState {
  final StudentAttendanceSubmitModel result;
  StudentAttendanceAbsent(this.result);
}

class StudentAttendanceError extends StudentAttendanceState {
  final String message;

  StudentAttendanceError(this.message);
}
