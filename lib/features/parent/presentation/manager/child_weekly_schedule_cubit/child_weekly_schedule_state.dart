import 'package:school_system/core/api/api_errors.dart';
import 'package:school_system/features/parent/data/models/parent_weekly_schedule_model.dart';

abstract class ChildWeeklyScheduleState {}

class ChildWeeklyScheduleInitial extends ChildWeeklyScheduleState {}

class ChildWeeklyScheduleLoading extends ChildWeeklyScheduleState {}

class ChildWeeklyScheduleSuccess extends ChildWeeklyScheduleState {
  final ParentWeeklyScheduleModel schedule;
  ChildWeeklyScheduleSuccess(this.schedule);
}

class ChildWeeklyScheduleFailure extends ChildWeeklyScheduleState {
  final ApiErrors error;
  ChildWeeklyScheduleFailure(this.error);
}
