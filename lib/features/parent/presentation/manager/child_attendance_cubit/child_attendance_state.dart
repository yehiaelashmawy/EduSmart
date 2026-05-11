import 'package:school_system/core/api/api_errors.dart';
import 'package:school_system/features/parent/data/models/parent_attendance_model.dart';

abstract class ChildAttendanceState {}

class ChildAttendanceInitial extends ChildAttendanceState {}

class ChildAttendanceLoading extends ChildAttendanceState {}

class ChildAttendanceSuccess extends ChildAttendanceState {
  final ChildAttendanceModel data;
  ChildAttendanceSuccess(this.data);
}

class ChildAttendanceFailure extends ChildAttendanceState {
  final ApiErrors error;
  ChildAttendanceFailure(this.error);
}
