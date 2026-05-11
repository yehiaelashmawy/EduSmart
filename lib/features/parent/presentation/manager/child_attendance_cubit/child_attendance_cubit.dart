import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:school_system/core/api/api_errors.dart';
import 'package:school_system/features/parent/data/repos/parent_dashboard_repo.dart';
import 'child_attendance_state.dart';

class ChildAttendanceCubit extends Cubit<ChildAttendanceState> {
  final ParentDashboardRepo _repo;
  final String childId;

  ChildAttendanceCubit(this._repo, {required this.childId})
    : super(ChildAttendanceInitial());

  Future<void> fetchAttendance() async {
    emit(ChildAttendanceLoading());
    final result = await _repo.getChildrenAttendance();
    result.fold((error) => emit(ChildAttendanceFailure(error)), (data) {
      // Find the specific child by ID
      try {
        final child = data.children.firstWhere((c) => c.studentOid == childId);
        emit(ChildAttendanceSuccess(child));
      } catch (_) {
        // Child not found in response
        if (data.children.isNotEmpty) {
          emit(ChildAttendanceSuccess(data.children.first));
        } else {
          emit(
            ChildAttendanceFailure(
              ApiErrors(errorMessage: 'No attendance data found'),
            ),
          );
        }
      }
    });
  }
}
