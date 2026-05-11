import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:school_system/features/parent/data/repos/parent_dashboard_repo.dart';
import 'child_weekly_schedule_state.dart';

class ChildWeeklyScheduleCubit extends Cubit<ChildWeeklyScheduleState> {
  final ParentDashboardRepo _repo;

  ChildWeeklyScheduleCubit(this._repo) : super(ChildWeeklyScheduleInitial());

  Future<void> fetchChildWeeklySchedule(String childId) async {
    emit(ChildWeeklyScheduleLoading());
    final result = await _repo.getChildWeeklySchedule(childId);
    result.fold(
      (error) => emit(ChildWeeklyScheduleFailure(error)),
      (data) => emit(ChildWeeklyScheduleSuccess(data)),
    );
  }
}
