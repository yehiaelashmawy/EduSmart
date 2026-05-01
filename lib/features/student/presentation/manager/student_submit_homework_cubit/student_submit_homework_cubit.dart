import 'dart:io';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:school_system/features/student/data/repos/student_submit_homework_repo.dart';
import 'student_submit_homework_state.dart';

class StudentSubmitHomeworkCubit extends Cubit<StudentSubmitHomeworkState> {
  final StudentSubmitHomeworkRepo _repo;

  StudentSubmitHomeworkCubit(this._repo) : super(StudentSubmitHomeworkInitial());

  Future<void> submit({
    required String homeworkId,
    required File? file,
    required String submissionText,
  }) async {
    emit(StudentSubmitHomeworkLoading());

    String attachmentUrl = '';
    
    // 1. Upload attachment if exists
    if (file != null) {
      final uploadResult = await _repo.uploadAttachment(
        homeworkId: homeworkId,
        file: file,
      );

      uploadResult.fold(
        (error) {
          emit(StudentSubmitHomeworkFailure(error));
        },
        (url) {
          attachmentUrl = url;
        },
      );
      
      // If upload failed, stop here
      if (state is StudentSubmitHomeworkFailure) return;
    }

    // 2. Submit homework
    final submitResult = await _repo.submitHomework(
      homeworkId: homeworkId,
      submissionText: submissionText,
      attachmentUrl: attachmentUrl,
    );

    submitResult.fold(
      (error) => emit(StudentSubmitHomeworkFailure(error)),
      (_) => emit(StudentSubmitHomeworkSuccess()),
    );
  }
}
