import 'package:school_system/core/api/api_errors.dart';

abstract class StudentSubmitExamState {}

class StudentSubmitExamInitial extends StudentSubmitExamState {}

class StudentSubmitExamLoading extends StudentSubmitExamState {}

class StudentSubmitExamSuccess extends StudentSubmitExamState {}

class StudentSubmitExamFailure extends StudentSubmitExamState {
  final ApiErrors error;
  StudentSubmitExamFailure(this.error);
}
