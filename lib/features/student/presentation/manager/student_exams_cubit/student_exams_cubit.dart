import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:school_system/features/student/data/repos/student_exams_repo.dart';
import 'student_exams_state.dart';

class StudentExamsCubit extends Cubit<StudentExamsState> {
  final StudentExamsRepo _repo;

  StudentExamsCubit(this._repo) : super(StudentExamsInitial());

  Future<void> fetchExams() async {
    emit(StudentExamsLoading());
    final result = await _repo.fetchExams();
    result.fold(
      (error) => emit(StudentExamsFailure(error)),
      (exams) => emit(StudentExamsSuccess(exams)),
    );
  }
}
