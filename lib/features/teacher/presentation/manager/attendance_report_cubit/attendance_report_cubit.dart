import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:school_system/features/teacher/data/repos/attendance_repo.dart';
import 'package:school_system/features/teacher/presentation/manager/attendance_report_cubit/attendance_report_state.dart';

class AttendanceReportCubit extends Cubit<AttendanceReportState> {
  final AttendanceRepo _attendanceRepo;

  AttendanceReportCubit(this._attendanceRepo) : super(AttendanceReportInitial());

  Future<void> fetchClassStats(String classOid) async {
    emit(AttendanceReportLoading());
    final result = await _attendanceRepo.getClassStats(classOid);
    result.fold(
      (error) => emit(AttendanceReportFailure(error)),
      (stats) => emit(AttendanceReportSuccess(stats)),
    );
  }
}
