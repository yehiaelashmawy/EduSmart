import 'package:school_system/core/api/api_errors.dart';
import 'package:school_system/features/parent/data/models/parent_grades_model.dart';

abstract class ChildGradesState {}

class ChildGradesInitial extends ChildGradesState {}

class ChildGradesLoading extends ChildGradesState {}

class ChildGradesSuccess extends ChildGradesState {
  final ParentGradesModel data;
  ChildGradesSuccess(this.data);
}

class ChildGradesFailure extends ChildGradesState {
  final ApiErrors error;
  ChildGradesFailure(this.error);
}
