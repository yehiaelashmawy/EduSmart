import 'package:school_system/core/api/api_errors.dart';
import 'package:school_system/features/student/data/models/student_exam_model.dart';

abstract class StudentExamsState {}

class StudentExamsInitial extends StudentExamsState {}

class StudentExamsLoading extends StudentExamsState {}

class StudentExamsSuccess extends StudentExamsState {
  final List<StudentExamModel> exams;
  StudentExamsSuccess(this.exams);
}

class StudentExamsFailure extends StudentExamsState {
  final ApiErrors error;
  StudentExamsFailure(this.error);
}
