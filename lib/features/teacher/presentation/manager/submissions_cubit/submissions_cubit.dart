import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:school_system/features/teacher/data/models/submission_model.dart';
import 'package:school_system/features/teacher/data/repos/submissions_repo.dart';

// ─── States ───────────────────────────────────────────────────────────────────

abstract class SubmissionsState {}

class SubmissionsInitial extends SubmissionsState {}

class SubmissionsLoading extends SubmissionsState {}

class SubmissionsSuccess extends SubmissionsState {
  final List<SubmissionModel> submissions;
  SubmissionsSuccess(this.submissions);
}

class SubmissionsFailure extends SubmissionsState {
  final String errorMessage;
  SubmissionsFailure(this.errorMessage);
}

class GradeSubmitting extends SubmissionsState {}

class GradeSuccess extends SubmissionsState {
  final String message;
  final List<SubmissionModel> submissions;
  GradeSuccess(this.message, this.submissions);
}

class GradeFailure extends SubmissionsState {
  final String errorMessage;
  final List<SubmissionModel> submissions;
  GradeFailure(this.errorMessage, this.submissions);
}

// ─── Cubit ────────────────────────────────────────────────────────────────────

class SubmissionsCubit extends Cubit<SubmissionsState> {
  final SubmissionsRepo repo;
  final String homeworkId;
  final bool isExam;
  final double? totalMarks;

  List<SubmissionModel> _submissions = [];

  SubmissionsCubit({
    required this.repo,
    required this.homeworkId,
    this.isExam = false,
    this.totalMarks,
  }) : super(SubmissionsInitial());

  Future<void> fetchSubmissions() async {
    emit(SubmissionsLoading());
    final result = isExam
        ? await repo.getExamSubmissions(homeworkId)
        : await repo.getSubmissions(homeworkId);
    result.fold(
      (error) => emit(SubmissionsFailure(error.errorMessage)),
      (list) {
        _submissions = list.map((s) => SubmissionModel(
          id: s.id,
          studentName: s.studentName,
          studentEmail: s.studentEmail,
          content: s.content,
          attachmentUrl: s.attachmentUrl,
          submittedAt: s.submittedAt,
          grade: s.grade,
          totalMarks: s.totalMarks ?? totalMarks,
          feedback: s.feedback,
          status: s.status,
          isLate: s.isLate,
        )).toList();
        emit(SubmissionsSuccess(_submissions));
      },
    );
  }

  Future<void> gradeSubmission({
    required String submissionId,
    required double grade,
    String? feedback,
  }) async {
    emit(GradeSubmitting());
    final result = isExam
        ? await repo.gradeExamSubmission(
            examId: homeworkId,
            submissionId: submissionId,
            grade: grade,
            feedback: feedback,
          )
        : await repo.gradeSubmission(
            homeworkId: homeworkId,
            submissionId: submissionId,
            grade: grade,
            feedback: feedback,
          );
    result.fold(
      (error) => emit(GradeFailure(error.errorMessage, _submissions)),
      (msg) {
        // Update the local list so the grade is reflected immediately
        _submissions = _submissions.map((s) {
          if (s.id == submissionId) {
            return SubmissionModel(
              id: s.id,
              studentName: s.studentName,
              studentEmail: s.studentEmail,
              content: s.content,
              attachmentUrl: s.attachmentUrl,
              submittedAt: s.submittedAt,
              grade: grade,
              totalMarks: s.totalMarks ?? totalMarks,
              feedback: feedback,
              status: 'Graded',
              isLate: s.isLate,
            );
          }
          return s;
        }).toList();
        emit(GradeSuccess(msg, _submissions));
      },
    );
  }
}
