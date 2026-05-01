import 'package:school_system/core/api/api_errors.dart';

abstract class StudentSubmitHomeworkState {}

class StudentSubmitHomeworkInitial extends StudentSubmitHomeworkState {}

class StudentSubmitHomeworkLoading extends StudentSubmitHomeworkState {}

class StudentSubmitHomeworkSuccess extends StudentSubmitHomeworkState {}

class StudentSubmitHomeworkFailure extends StudentSubmitHomeworkState {
  final ApiErrors error;
  StudentSubmitHomeworkFailure(this.error);
}
