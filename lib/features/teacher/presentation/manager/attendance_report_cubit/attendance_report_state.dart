import 'package:school_system/core/api/api_errors.dart';
import 'package:school_system/features/teacher/data/models/class_attendance_stats_model.dart';

abstract class AttendanceReportState {}

class AttendanceReportInitial extends AttendanceReportState {}

class AttendanceReportLoading extends AttendanceReportState {}

class AttendanceReportSuccess extends AttendanceReportState {
  final ClassAttendanceStatsModel stats;
  AttendanceReportSuccess(this.stats);
}

class AttendanceReportFailure extends AttendanceReportState {
  final ApiErrors error;
  AttendanceReportFailure(this.error);
}
