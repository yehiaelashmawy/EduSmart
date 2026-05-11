import 'package:school_system/core/api/api_errors.dart';
import 'package:school_system/features/parent/data/models/parent_homework_model.dart';

abstract class ChildHomeworkState {}

class ChildHomeworkInitial extends ChildHomeworkState {}

class ChildHomeworkLoading extends ChildHomeworkState {}

class ChildHomeworkSuccess extends ChildHomeworkState {
  final List<ParentHomeworkModel> homework;
  ChildHomeworkSuccess(this.homework);
}

class ChildHomeworkFailure extends ChildHomeworkState {
  final ApiErrors error;
  ChildHomeworkFailure(this.error);
}
