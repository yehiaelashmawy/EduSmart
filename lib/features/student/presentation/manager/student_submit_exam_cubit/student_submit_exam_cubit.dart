import 'dart:io';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:school_system/features/student/data/repos/student_submit_exam_repo.dart';
import 'student_submit_exam_state.dart';

class StudentSubmitExamCubit extends Cubit<StudentSubmitExamState> {
  final StudentSubmitExamRepo _repo;

  StudentSubmitExamCubit(this._repo) : super(StudentSubmitExamInitial());

  Future<void> submit({
    required String examId,
    required File? file,
    required String answerText,
  }) async {
    emit(StudentSubmitExamLoading());

    String attachmentUrl = '';
    String fileName = '';

    // 1. Upload solution if file exists
    if (file != null) {
      final uploadResult = await _repo.uploadSolution(
        examId: examId,
        file: file,
      );

      uploadResult.fold(
        (error) {
          emit(StudentSubmitExamFailure(error));
        },
        (data) {
          attachmentUrl = data['attachmentUrl'] ?? '';
          fileName = data['fileName'] ?? '';
        },
      );

      if (state is StudentSubmitExamFailure) return;
    }

    // 2. Submit exam
    final submitResult = await _repo.submitExam(
      examId: examId,
      answerText: answerText,
      attachmentUrl: attachmentUrl,
      fileName: fileName,
    );

    submitResult.fold(
      (error) => emit(StudentSubmitExamFailure(error)),
      (_) => emit(StudentSubmitExamSuccess()),
    );
  }
}
