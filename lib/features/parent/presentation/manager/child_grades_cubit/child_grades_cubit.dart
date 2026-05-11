import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:school_system/core/api/api_errors.dart';
import 'package:school_system/features/parent/data/repos/parent_dashboard_repo.dart';
import 'child_grades_state.dart';

class ChildGradesCubit extends Cubit<ChildGradesState> {
  final ParentDashboardRepo _repo;
  final String childId;

  ChildGradesCubit(this._repo, {required this.childId})
    : super(ChildGradesInitial());

  Future<void> fetchGrades() async {
    emit(ChildGradesLoading());
    final result = await _repo.getGrades();
    result.fold((error) => emit(ChildGradesFailure(error)), (dataList) {
      try {
        final childGrades = dataList.firstWhere((g) => g.studentOid == childId);
        emit(ChildGradesSuccess(childGrades));
      } catch (_) {
        if (dataList.isNotEmpty) {
          emit(ChildGradesSuccess(dataList.first));
        } else {
          emit(
            ChildGradesFailure(
              ApiErrors(errorMessage: 'No grades found for this student'),
            ),
          );
        }
      }
    });
  }
}
