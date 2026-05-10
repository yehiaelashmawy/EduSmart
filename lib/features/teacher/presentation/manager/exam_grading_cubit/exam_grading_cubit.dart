import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:school_system/features/teacher/data/models/exam_submission_model.dart';
import 'package:school_system/features/teacher/data/models/teacher_class_model.dart';
import 'package:school_system/features/teacher/data/repos/exam_grading_repo.dart';

// States
abstract class ExamGradingState {}

class ExamGradingInitial extends ExamGradingState {}

class ExamGradingLoading extends ExamGradingState {}

class ExamGradingLoaded extends ExamGradingState {
  final ExamSubmissionsResponse response;
  ExamGradingLoaded(this.response);
}

class ExamGradingError extends ExamGradingState {
  final String message;
  ExamGradingError(this.message);
}

class ExamGradingSubmitting extends ExamGradingState {
  final ExamSubmissionsResponse response;
  ExamGradingSubmitting(this.response);
}

class ExamGradingSubmitSuccess extends ExamGradingState {
  final String studentName;
  final ExamSubmissionsResponse response;
  ExamGradingSubmitSuccess({required this.studentName, required this.response});
}

class ExamGradingSubmitError extends ExamGradingState {
  final String message;
  ExamGradingSubmitError(this.message);
}

// Cubit
class ExamGradingCubit extends Cubit<ExamGradingState> {
  final ExamGradingRepo _repo;
  final String examId;
  ExamSubmissionsResponse? _lastResponse;

  ExamGradingCubit(this._repo, {required this.examId})
      : super(ExamGradingInitial());

  Future<void> fetchSubmissions({List<TeacherStudentModel> classStudents = const []}) async {
    emit(ExamGradingLoading());
    final result = await _repo.getExamSubmissions(examId);
    result.fold(
      (err) => emit(ExamGradingError(err.errorMessage)),
      (res) {
        // Merge with class students if provided
        final mergedSubmissions = [...res.submissions];
        if (classStudents.isNotEmpty) {
          for (final student in classStudents) {
            final exists = mergedSubmissions.any((s) => s.studentId == student.oid);
            if (!exists) {
              mergedSubmissions.add(ExamSubmissionModel(
                submissionId: 'missing_${student.oid}',
                studentId: student.oid,
                studentName: student.fullName,
                submittedAt: '',
                score: 0,
                status: 'Pending',
                isGraded: false,
                answerText: null,
                attachmentUrl: null,
                fileName: null,
                gradedAt: null,
              ));
            }
          }
        }

        final finalRes = ExamSubmissionsResponse(
          total: classStudents.isNotEmpty ? classStudents.length : res.total,
          graded: mergedSubmissions.where((s) => s.isGraded).length,
          pending: mergedSubmissions.where((s) => !s.isGraded).length,
          submissions: mergedSubmissions,
        );

        _lastResponse = finalRes;
        emit(ExamGradingLoaded(finalRes));
      },
    );
  }

  Future<void> gradeStudent({
    required String studentId,
    required String studentName,
    required int score,
    required String remarks,
  }) async {
    if (_lastResponse == null) {
      emit(ExamGradingSubmitError('Cannot submit grade: Submissions not loaded.'));
      return;
    }

    emit(ExamGradingSubmitting(_lastResponse!));
    final result = await _repo.gradeStudent(
      examId: examId,
      studentId: studentId,
      score: score,
      remarks: remarks,
    );
    result.fold(
      (err) => emit(ExamGradingSubmitError(err.errorMessage)),
      (_) {
        emit(ExamGradingSubmitSuccess(
          studentName: studentName,
          response: _lastResponse!,
        ));
      },
    );
  }
}
